from flask import Flask, jsonify, render_template
import json
import os

app = Flask(__name__)

LOG_FILE = "/cowrie/var/log/cowrie/cowrie.json"

@app.route("/")
def home():
    return {"status": "Honeypot Active", "service": "Cowrie SSH Decoy"}

@app.route("/logs")
def logs():
    logs = []

    if not os.path.exists(LOG_FILE):
        return jsonify({"message": "No logs yet - waiting for attackers"})

    with open(LOG_FILE, "r") as f:
        for line in f.readlines()[-100:]:
            try:
                logs.append(json.loads(line))
            except:
                continue

    return jsonify(logs)

@app.route("/ui")
def ui():
    return render_template("index.html")


@app.route("/stats")
def stats():
    if not os.path.exists(LOG_FILE):
        return {"total_events": 0}

    count = sum(1 for _ in open(LOG_FILE))
    return {"total_events": count}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
