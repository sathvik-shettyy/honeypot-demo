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
# Install dependencies
# -------------------------
RUN python3 -m venv cowrie-env

RUN /bin/bash -c "\
    source cowrie-env/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt"

# -------------------------
# Flask App
# -------------------------
WORKDIR /app
COPY . /app

RUN pip install flask

ENV PORT=8080
EXPOSE 8080 2222

# -------------------------
# FINAL FIX (CORRECT ENTRYPOINT)
# -------------------------
CMD bash -c "\
source /cowrie/cowrie-env/bin/activate && \
cd /cowrie && \
twistd -n -y etc/cowrie.tac & \
cd /app && \
python app.py"
