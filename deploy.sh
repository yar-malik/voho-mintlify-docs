#!/usr/bin/env bash
# Build the docs and deploy them to voho-vm. Run from the repo root.
set -euo pipefail

ZONE=europe-west2-a
PROJECT=callsupport-ai-439923
VM=voho-vm
DOMAIN=docs.voho.ai

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
sudo chown -R www-data:www-data /var/www/$DOMAIN
sudo nginx -t && sudo systemctl reload nginx
sleep 2
curl -s -o /dev/null -w 'live: HTTP %{http_code}\n' -H 'Host: $DOMAIN' http://127.0.0.1/
"
rm -f export.zip
echo "==> Done: https://$DOMAIN"
