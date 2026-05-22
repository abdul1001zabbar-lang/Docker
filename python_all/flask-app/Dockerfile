FROM python:3.10

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

CMD ["python","app.py"]


#docker build -t flaskapp .
#docker run -d --name c1 -p 5000:5000 flaskapp

