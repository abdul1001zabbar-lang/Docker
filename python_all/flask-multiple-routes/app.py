from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "Home page"

@app.route("/about")
def home():
    return "About page"
app.run(host="0.0.0.0",port=5000)