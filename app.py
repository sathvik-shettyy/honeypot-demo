from flask import Flask, jsonify, render_template
import json

app = Flask(__name__)

LOG_FILE = "cowrie/var/log/cowrie/cowrie.json"

@app.route("/")
def home():
    return {"message": "Honeypot is running"}

@app.route("/logs")
def logs():
    data = []
    try:
        with open(LOG_FILE, "r") as f:
            for line in f.readlines()[-50:]:  # last 50 events
                data.append(json.loads(line))
    except:
        return {"error": "No logs yet"}
    return jsonify(data)

@app.route("/ui")
def ui():
    return render_template("index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
