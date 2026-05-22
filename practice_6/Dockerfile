FROM python:3.10

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

CMD ["python","app.py"]



#docker build -t notes-app .
#docker run -d -p 5000:5000 --name notescontainer notes-app