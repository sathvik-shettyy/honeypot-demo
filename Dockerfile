FROM python:3.11-slim

# System dependencies
RUN apt update && apt install -y git python3-venv

# Clone Cowrie
RUN git clone https://github.com/cowrie/cowrie.git /cowrie

WORKDIR /cowrie

# Install Cowrie
RUN python3 -m venv cowrie-env
RUN . cowrie-env/bin/activate && pip install --upgrade pip
RUN . cowrie-env/bin/activate && pip install -r requirements.txt

# Copy config (basic)
COPY cowrie/cowrie.cfg /cowrie/etc/cowrie.cfg

# Flask app
WORKDIR /app
COPY . /app

RUN pip install -r requirements.txt

# Railway uses PORT env variable
ENV PORT=8080

EXPOSE 8080 2222

CMD bash -c "\
cd /cowrie && \
bin/cowrie start && \
cd /app && \
python app.py"
