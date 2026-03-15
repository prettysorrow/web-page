venv: requirements.txt
	python3 -m venv venv
	source venv/bin/activate
	pip install -r requirements.txt

update:
	git fetch
	git pull
	sudo systemctl restart nginx
	sudo systemctl restart flaskapp

status:
	sudo nginx -t
# 		nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
# 		nginx: configuration file /etc/nginx/nginx.conf test is successful
	sudo systemctl status nginx
# 		● nginx.service - A high performance web server and a reverse proxy server
# 			Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
# 			Active: active (running) since Tue 2026-02-24 16:00:32 UTC; 2 weeks 4 days ago
# 			Docs: man:nginx(8)
# 			Main PID: 1204055 (nginx)
# 				Tasks: 3 (limit: 2314)
# 				Memory: 6.8M (peak: 8.0M)
# 					CPU: 10.657s
# 				CGroup: /system.slice/nginx.service
# 						├─1204055 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
# 						├─1204056 "nginx: worker process"
# 					└─1204057 "nginx: worker process"

# 		Feb 24 16:00:32 <hostname> systemd[1]: Starting nginx.service - A high performance web server and a reverse proxy server...
# 		Feb 24 16:00:32 <hostname> systemd[1]: Started nginx.service - A high performance web server and a reverse proxy server.
	sudo systemctl status flaskapp
# 		● flaskapp.service - Flask Application
# 			Loaded: loaded (/etc/systemd/system/flaskapp.service; enabled; preset: enabled)
# 			Active: active (running) since Wed 2026-03-11 06:04:16 UTC; 3 days ago
# 		Main PID: 1463555 (gunicorn)
# 			Tasks: 24 (limit: 2314)
# 			Memory: 431.5M (peak: 432.0M)
# 				CPU: 6min 8.441s
# 			CGroup: /system.slice/flaskapp.service
# 					├─1463555 /home/<username>/web-page/venv/bin/python3 /home/<username>/web-page/venv/bin/gunicorn --workers 10 --threads 2 --worker-class gthread ->
# 					├─1463579 /home/<username>/web-page/venv/bin/python3 /home/<username>/web-page/venv/bin/gunicorn --workers 10 --threads 2 --worker-class gthread ->
# 					├─1463581 /home/<username>/web-page/venv/bin/python3 /home/<username>/web-page/venv/bin/gunicorn --workers 10 --threads 2 --worker-class gthread ->
# 					├─1463582 /home/<username>/web-page/venv/bin/python3 /home/<username>/web-page/venv/bin/gunicorn --workers 10 --threads 2 --worker-class gthread ->
# 					├─1463583 /home/<username>/web-page/venv/bin/python3 /home/<username>/web-page/venv/bin/gunicorn --workers 10 --threads 2 --worker-class gthread ->
# 					├─1463584 /home/<username>/web-page/venv/bin/python3 /home/<username>/web-page/venv/bin/gunicorn --workers 10 --threads 2 --worker-class gthread ->
# 					├─1463585 /home/<username>/web-page/venv/bin/python3 /home/<username>/web-page/venv/bin/gunicorn --workers 10 --threads 2 --worker-class gthread ->
# 					├─1463586 /home/<username>/web-page/venv/bin/python3 /home/<username>/web-page/venv/bin/gunicorn --workers 10 --threads 2 --worker-class gthread ->
# 					├─1463588 /home/<username>/web-page/venv/bin/python3 /home/<username>/web-page/venv/bin/gunicorn --workers 10 --threads 2 --worker-class gthread ->
# 					├─1463589 /home/<username>/web-page/venv/bin/python3 /home/<username>/web-page/venv/bin/gunicorn --workers 10 --threads 2 --worker-class gthread ->
# 					└─1463590 /home/<username>/web-page/venv/bin/python3 /home/<username>/web-page/venv/bin/gunicorn --workers 10 --threads 2 --worker-class gthread ->

# 		Mar 11 06:04:16 <hostname> gunicorn[1463579]: [2026-03-11 06:04:16 +0000] [1463579] [INFO] Booting worker with pid: 1463579
# 		Mar 11 06:04:16 <hostname> gunicorn[1463581]: [2026-03-11 06:04:16 +0000] [1463581] [INFO] Booting worker with pid: 1463581
# 		Mar 11 06:04:16 <hostname> gunicorn[1463582]: [2026-03-11 06:04:16 +0000] [1463582] [INFO] Booting worker with pid: 1463582
# 		Mar 11 06:04:16 <hostname> gunicorn[1463583]: [2026-03-11 06:04:16 +0000] [1463583] [INFO] Booting worker with pid: 1463583
# 		Mar 11 06:04:16 <hostname> gunicorn[1463584]: [2026-03-11 06:04:16 +0000] [1463584] [INFO] Booting worker with pid: 1463584
# 		Mar 11 06:04:16 <hostname> gunicorn[1463585]: [2026-03-11 06:04:16 +0000] [1463585] [INFO] Booting worker with pid: 1463585
# 		Mar 11 06:04:17 <hostname> gunicorn[1463586]: [2026-03-11 06:04:17 +0000] [1463586] [INFO] Booting worker with pid: 1463586
# 		Mar 11 06:04:17 <hostname> gunicorn[1463588]: [2026-03-11 06:04:17 +0000] [1463588] [INFO] Booting worker with pid: 1463588
# 		Mar 11 06:04:17 <hostname> gunicorn[1463589]: [2026-03-11 06:04:17 +0000] [1463589] [INFO] Booting worker with pid: 1463589
# 		Mar 11 06:04:17 <hostname> gunicorn[1463590]: [2026-03-11 06:04:17 +0000] [1463590] [INFO] Booting worker with pid: 1463590