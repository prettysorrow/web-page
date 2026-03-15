### web-page


it is assumed that the gunicorn systemd service will be named `flaskapp` and that repo directory is `/home/<username>/web-page`


---


create `.env` with following contents:


```.env
SECRET_KEY=...

YANDEX_CLIENT_ID=...
YANDEX_CLIENT_SECRET=...

GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...

TARGET=... # "LOCAL" | "REMOTE"
REMOTE_ADDRESS="your.domain.com"

DATABASE_URI=sqlite:///instance/site.db

OAUTHLIB_INSECURE_TRANSPORT=... # 0 | 1
```

1. generate `SECRET_KEY` using `python3 -c "import secrets; print(secrets.token_hex(32))"`
2. get `YANDEX_CLIENT_ID` and `YANDEX_CLIENT_SECRET` from https://oauth.yandex.ru
3. get `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` from https://console.cloud.google.com
4. run app using `./app.py`


`TARGET=LOCAL` for development on localhost or `TARGET=REMOTE` for deployment on a `REMOTE_ADDRESS`


`OAUTHLIB_INSECURE_TRANSPORT=1` for development on localhost or `OAUTHLIB_INSECURE_TRANSPORT=0` for deployment on remote server


---


create `/etc/systemd/system/flaskapp.service` with the following contents:


```md
[Unit]
Description=Flask Application
After=network.target

[Service]
Type=simple
User=<username>
Group=www-data
WorkingDirectory=/home/<username>/web-page
Environment="PATH=/home/<username>/web-page/venv/bin:/usr/local/bin:/usr/sbin:/usr/bin"
ExecStart=/home/<username>/web-page/venv/bin/gunicorn \
          --workers 10 \
          --threads 2 \
          --worker-class gthread \
          --bind 127.0.0.1:8000 \
          --max-requests 1000 \
          --timeout 30 \
          app:app

Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```


---


create `/etc/nginx/sites-enabled/flaskapp` with the following contents:


```nginx
# HTTP -> HTTPS redirect
server {
    listen 80;
    listen [::]:80;
    server_name <your-domain.com>;
    return 301 https://$server_name$request_uri;
}

# HTTPS server
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name <your-domain.com>;

    # Let's Encrypt certificates
    ssl_certificate /etc/letsencrypt/live/<your-domain.com>/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/<your-domain.com>/privkey.pem;

    # some TLS shit
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # some cludges to fix static caching issue
    location /static/ {
        alias /home/<username>/web-page/static/;
        access_log off;

        expires 2m;
        add_header Cache-Control "public, max-age=120";

        try_files $uri =404;
    }

    # gunicorn reverse proxy
    location / {
        # some cludges to fix static caching issue
        proxy_hide_header Cache-Control;
        proxy_hide_header Pragma;
        proxy_hide_header Expires;
        proxy_hide_header Surrogate-Control;

        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;

        # some cludges to fix static caching issue
        add_header Cache-Control "public, max-age=120";
    }
}
```


---


generate let's encrypt certificate using something like this:


```zsh
sudo apt install -y certbot python3-certbot-nginx 
sudo certbot --nginx -d <your-domain.com>
```

expected output:


```zsh
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Enter email address (used for urgent renewal and security notices)
 (Enter 'c' to cancel): <your-email@gmail.com>

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.6-August-18-2025.pdf. You must agree
in order to register with the ACME server. Do you agree?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o:
(Y)es/(N)o: y

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing, once your first certificate is successfully issued, to
share your email address with the Electronic Frontier Foundation, a founding
partner of the Let's Encrypt project and the non-profit organization that
develops Certbot? We'd like to send you email about our work encrypting the web,
EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: y
Account registered.
Requesting a certificate for <your-domain.com>

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/<your-domain.com>/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/<your-domain.com>/privkey.pem
This certificate expires on 2026-03-22.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

Deploying certificate
Successfully deployed certificate for <your-domain.com> to /etc/nginx/sites-enabled/flaskapp
Congratulations! You have successfully enabled HTTPS on https://<your-domain.com>

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```