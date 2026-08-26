#!/usr/bin/env bash
# Build the docs and deploy them to voho-vm. Run from the repo root.
set -euo pipefail

ZONE=europe-west2-a
PROJECT=callsupport-ai-439923
VM=voho-vm
DOMAIN=docs.voho.ai

# Paths that have moved. The static export does not carry the redirects in
# docs.json — nginx serves files, so a moved page is a 404 unless something is
# left at the old path. These links have been sent to customers, so each old
# path gets a stub that forwards to the new one.
REDIRECTS="pricing-onprem:/pricing pricing-cloud:/pricing"

echo "==> Building static export"
npx --yes mint@latest export

echo "==> Uploading"
gcloud compute scp export.zip "$VM:/tmp/voho-docs.zip" \
  --zone="$ZONE" --project="$PROJECT" --tunnel-through-iap

echo "==> Installing on $VM"
gcloud compute ssh "$VM" --zone="$ZONE" --project="$PROJECT" --tunnel-through-iap --command="
set -e
cd /tmp && rm -rf docsx && mkdir docsx
python3 -m zipfile -e voho-docs.zip docsx/
sudo rm -rf /var/www/$DOMAIN
sudo mkdir -p /var/www/$DOMAIN
sudo cp -a /tmp/docsx/. /var/www/$DOMAIN/
sudo rm -f '/var/www/$DOMAIN/Start Docs.bat' '/var/www/$DOMAIN/Start Docs.command'
for pair in $REDIRECTS; do
  from=\${pair%%:*}; to=\${pair#*:}
  sudo mkdir -p \"/var/www/$DOMAIN/\$from\"
  printf '<!doctype html><meta charset=\"utf-8\"><title>Moved</title><link rel=\"canonical\" href=\"%s\"><meta name=\"robots\" content=\"noindex\"><meta http-equiv=\"refresh\" content=\"0; url=%s\"><script>location.replace(\"%s\")</script><p>This page has moved to <a href=\"%s\">%s</a>.</p>\\n' \"\$to\" \"\$to\" \"\$to\" \"\$to\" \"\$to\" | sudo tee \"/var/www/$DOMAIN/\$from/index.html\" > /dev/null
done
sudo chown -R www-data:www-data /var/www/$DOMAIN
sudo nginx -t && sudo systemctl reload nginx
sleep 2
curl -s -o /dev/null -w 'live: HTTP %{http_code}\n' -H 'Host: $DOMAIN' http://127.0.0.1/
for pair in $REDIRECTS; do
  from=\${pair%%:*}
  curl -s -o /dev/null -w \"redirect /\$from: HTTP %{http_code}\\n\" -H 'Host: $DOMAIN' \"http://127.0.0.1/\$from\"
done
"
rm -f export.zip
echo "==> Done: https://$DOMAIN"
