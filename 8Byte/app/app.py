import os
from flask import Flask, jsonify

app = Flask(__name__)


@app.get('/')
def index():
    return jsonify({
        "service": "8Byte DevOps Assignment App",
        "status": "ok",
        "environment": os.getenv("APP_ENV", "development"),
        "message": "Application is running successfully."
    })


@app.get('/health')
def health():
    return jsonify({
        "status": "healthy",
        "service": "8Byte DevOps Assignment App"
    })


if __name__ == '__main__':
    port = int(os.getenv("PORT", "8000"))
    app.run(host="0.0.0.0", port=port, debug=False)
