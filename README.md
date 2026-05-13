```markdown
# 🛡️ Cloud Honeypot SOC Platform

A cloud-based honeypot and security monitoring system that uses OpenCanary to simulate vulnerable services and a Flask dashboard to visualize captured attack activity.

## 📌 Overview

This project demonstrates a deception-based security approach where fake services are exposed to attract malicious activity. All events are logged and displayed through a simple SOC-style web interface for analysis and monitoring.

## ⚙️ Features

- Lightweight honeypot using Cowrie (but I prefer Opencanary when u'll shift to AWS)
- Simulated services (SSH, HTTP, FTP, etc.)
- Centralized log collection
- Flask-based security dashboard
- REST API for accessing logs and stats
- Cloud deployment ready (Docker / Railway / Render)

## 🧱 Architecture

OpenCanary (Honeypot Sensor) → Log Files → Flask Backend → Web Dashboard

## 🚀 Getting Started

### Install dependencies
```bash
pip install -r requirements.txt
````

### Run the app

```bash
python app.py
```

## 📊 Endpoints

* `/` → System status
* `/logs` → Captured events
* `/stats` → Event statistics
* `/ui` → Dashboard interface

## ⚠️ Disclaimer

This project is for educational and research purposes only.

## 🛡️ Purpose

Built to explore deception-based security, honeypot logging, and SOC-style monitoring in cloud environments.

```
```
