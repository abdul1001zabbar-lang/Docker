==============================================
🚀 Docker Roadmap for DevOps Engineer
1. Linux Basics
2. Networking Basics
3. Python / Flask Basics
4. Docker Fundamentals
5. Docker Basic Commands
6. Docker Images
7. Docker Containers
8. Dockerfile
9. Build Custom Images
10. Docker Networking
11. Docker Volumes
12. Docker Compose
13. Real Docker Projects
14. Docker Hub
15. Docker Logs & Debugging
16. Docker Security Basics
17. Docker in CI/CD
18. Kubernetes Basics
==============================================

https://docs.docker.com/engine/
Docker hello-world
docker ubuntu
docker mysql
docker python
docker mango   ====MongoDB port, 27017
docker compose

Code → Dockerfile → Image → Container → Deploy (Azure)


===========1==========
docker run hello-world
==========================
docker run -it ubuntu
===
docker run -it ubuntu bash

=========2===========
docker pull nginx
docker run -d -p 80:80 --name mynginx nginx


==========================================



===index.html

<h1>Hello Abdul! Nginx Docker is Running</h1>

===

FROM nginx:latest

COPY index.html /user/share/nginx/html/index.html

===

docker build -t my-nginx-app .

docker run -d -p 8080:80 --name nginxcontainer my-nginx-app

=================================

docker run -d -p 6379:6379 redis



===========3============
====app.py

mkdir my-docker-app
cd my-docker-app
touch app.py Dockerfile requirements.txt

vim app.py
print("hello world")

===Dockerfile

FROM python:3.10

WORKDIR /app

COPY ..

CMD ["python","app.y"]


==
docker build -t my-python-app .

docker run -d my-python-app

docker run --name mycontainer my-python-app



================4===================

===
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "Hello Docker!"

app.run(host="0.0.0.0", port=5000)


===
FROM python:3.9
WORKDIR /app
COPY . .
RUN pip install flask
CMD ["python", "app.py"]


===
docker build -t myapp .

docker run -d --name mycontainer -p 5000:5000 my-python-app
===============5==============

mkdir my-python-flask

touch app.py Dockerfile requirements.txt

====
vim app.py
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
	return "Hello badul!, Docker is running"
	
@app.route("/about")
def	about():
	return "About page is also running"
	
app.run(host = "0.0.0.0",port = 5000)


====
vim Dockerfile

FROM python:3.10

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .


CMD["python","app.py"


===
vim requirements.txt

flask	



====
docker build -t my-python-app .

docker run -d -name myconatiner -p 8000:5000 my-python-app



===============6======================
docker run mysql

docker run mysql:8.0

docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag

