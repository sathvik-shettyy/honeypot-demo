FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# -------------------------
# Install Cowrie PROPERLY
# -------------------------
RUN git clone https://github.com/cowrie/cowrie.git /cowrie

WORKDIR /cowrie

RUN python3 -m venv cowrie-env

RUN /bin/bash -c "\
    source cowrie-env/bin/activate && \
    pip install --upgrade pip && \
    pip install wheel && \
    pip install -r requirements.txt && \
    pip install twisted && \
    python -m cowrie --help || true"

# IMPORTANT: run official installer
RUN /bin/bash -c "\
    source cowrie-env/bin/activate && \
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
# FINAL START COMMAND (FIXED)
# -------------------------
CMD bash -c "\
source /cowrie/cowrie-env/bin/activate && \
cd /cowrie && \
bin/cowrie start && \
cd /app && \
python app.py"
