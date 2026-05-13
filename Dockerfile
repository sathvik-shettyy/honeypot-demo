FROM python:3.11-slim

# Install Cowrie dependencies
RUN apt update && apt install -y git python3-venv

# Clone Cowrie
RUN git clone https://github.com/cowrie/cowrie.git /cowrie

WORKDIR /cowrie

# Setup Cowrie
RUN python3 -m venv cowrie-env
RUN . cowrie-env/bin/activate && pip install --upgrade pip
RUN . cowrie-env/bin/activate && pip install -r requirements.txt

# Copy config
COPY cowrie/cowrie.cfg /cowrie/etc/cowrie.cfg

# Setup Flask app
WORKDIR /app
COPY . /app

RUN pip install -r requirements.txt

EXPOSE 2222 5000

CMD bash -c "cd /cowrie && bin/cowrie start && cd /app && python app.py"
