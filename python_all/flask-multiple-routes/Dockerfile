FROM python:3.10

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requiremnets.txt

COPY . .

CMD ["pyhton","app.py"]


