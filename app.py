from flask import Flask, jsonify, render_template
import json
import os

app = Flask(__name__)

LOG_FILE = "/cowrie/var/log/cowrie/cowrie.json"


@app.route("/")
def home():
    return {
        "status": "active",
        "service": "honeypot-demo",
        "message": "Honeypot API running"
    }


@app.route("/logs")
def logs():
    events = []

    if not os.path.exists(LOG_FILE):
        return jsonify({
            "status": "no_logs",
            "message": "Cowrie logs not found yet"
        })

    try:
        with open(LOG_FILE, "r") as f:
            for line in f.readlines()[-100:]:
                try:
                    events.append(json.loads(line))
                except:
                    continue
    except Exception as e:
        return jsonify({"error": str(e)})

    return jsonify({
        "count": len(events),
        "events": events
    })


@app.route("/ui")
def ui():
    return render_template("index.html")


@app.route("/stats")
def stats():
    if not os.path.exists(LOG_FILE):
        return {"total_events": 0}

    try:
        with open(LOG_FILE, "r") as f:
            count = sum(1 for _ in f)
        return {"total_events": count}
    except:
        return {"total_events": 0}


@app.route("/debug")
def debug():
    log_path = "/cowrie/var/log/cowrie"
    files = {}

    if os.path.exists(log_path):
        for root, _, filenames in os.walk(log_path):
            for file in filenames:
                try:
                    path = os.path.join(root, file)
                    with open(path, "r") as f:
                        files[file] = f.read()[-2000:]
                except:
                    files[file] = "unable to read"

    return jsonify(files)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
