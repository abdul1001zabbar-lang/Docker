from flask import Flask, render_template, request

app = Flask(__name__)

notes = []

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/notes", methods=["GET", "POST"])
def add_note():

    if request.method == "POST":
        note = request.form.get("note")
        notes.append(note)

    return render_template("notes.html", notes=notes)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)