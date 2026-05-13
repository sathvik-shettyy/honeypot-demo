FROM python:3.11-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    python3-venv \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# ------------------------
# Install Cowrie
# ------------------------
RUN git clone https://github.com/cowrie/cowrie.git /cowrie

WORKDIR /cowrie

RUN python3 -m venv cowrie-env && \
    . cowrie-env/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install twisted

# Optional safety: ensure permissions
RUN chmod -R 755 /cowrie

# ------------------------
# Flask App Setup
# ------------------------
WORKDIR /app
COPY . /app

RUN pip install flask

# Railway port
ENV PORT=8080

EXPOSE 8080 2222

# ------------------------
# FIXED START COMMAND (IMPORTANT PART)
# ------------------------
CMD bash -c "\
. /cowrie/cowrie-env/bin/activate && \
cd /cowrie && \
twistd -n cowrie & \
cd /app && \
python app.py"
