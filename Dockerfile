FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    git \
    python3-venv \
    build-essential \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# -------------------------
# Clone Cowrie
# -------------------------
RUN git clone https://github.com/cowrie/cowrie.git /cowrie

WORKDIR /cowrie

# -------------------------
# Proper Cowrie install (IMPORTANT FIX)
# -------------------------
RUN python3 -m venv cowrie-env

RUN /bin/bash -c "\
    source cowrie-env/bin/activate && \
    pip install --upgrade pip && \
    pip install wheel && \
    pip install -r requirements.txt && \
    pip install ."

# -------------------------
# Flask App
# -------------------------
WORKDIR /app
COPY . /app

RUN pip install flask

ENV PORT=8080
EXPOSE 8080 2222

# -------------------------
# FINAL START (STABLE)
# -------------------------
CMD bash -c "\
source /cowrie/cowrie-env/bin/activate && \
cd /cowrie && \
bin/cowrie start & \
cd /app && \
python app.py"
