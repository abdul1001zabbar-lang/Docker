FROM python:3.10

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requrements.txt

COPY . .

CMD ["python","app.py"]


#docker build -t myflaskapp .

#docker volume create myvolume
#docker network create mynetwork

#docker run -d --name flask-c1 -p 5000:5000  -v myvolume:/data -network mynetwork myflaskapp

#docker exec -it c1 bash
#echo "hello-world" >/data/demo.txt
#exit

#docker run -d --name nginx-c1 --natwork mynetwork -v myvolume:/usr/share/nginx/html -p 8080:80 nginx

#####################################
#docker ps

#curl localhost:5000

#curl localhost:8080

#docker exec -it nginx-c1 bash

#cd /usr/share/nginx/html

#ls

#cat demo.txt

#exit

#docker exec -it nginx-c1 bash

#apt update

#apt install curl -y

#curl flask-c1:5000

#exit

#docker network inspect app-network

#docker volume inspect app-data

#docker stop flask-c1

#docker stop nginx-c1

#docker start flask-c1

#docker start nginx-c1

#docker rm -f flask-c1

#docker rm -f nginx-c1

#docker network rm app-network

#docker volume rm app-data
##########