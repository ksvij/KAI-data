from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import asyncio
import subprocess
import re

app = Flask(__name__)
CORS(app)  # Enable CORS for the Flask app

@app.route('/')
def index():
    return send_from_directory('.', 'ai.html')

@app.route('/ai.css')
def stylesheet():
    return send_from_directory('.', 'ai.css')

@app.route('/ai.js')
def javascript():
    return send_from_directory('.', 'ai.js')

@app.route('/thinking.gif')
def thinking():
    return send_from_directory('.', 'thinking.gif')

@app.route('/logo.png')
def logo():
    return send_from_directory('.', 'logo.png')

@app.route('/favicon.ico')
def favicon():
    return send_from_directory('.', 'favicon.ico')

async def run_deepseek(user_input):
    # Check if the user is asking for the AI's name
    if re.search(r'\b(your name|who are you|what is your name|introduce yourself|what should I call you|may I know your name)\b', user_input, re.IGNORECASE):
        return "I am KAI, built by Kshiraj Vij on 16 Feb 2025."

    try:
        print("Running subprocess for input:", user_input)  # Logging the input
        process = await asyncio.create_subprocess_exec(
            'ollama', 'run', f'deepseek-r1:1.5b', user_input,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        stdout, stderr = await process.communicate()
        print("Subprocess stdout:", stdout.decode())  # Logging the stdout
        print("Subprocess stderr:", stderr.decode())  # Logging the stderr
        output = stdout.decode().strip()
        # Remove <think> tags using regex
        output = re.sub(r'</?think>', '', output)
        if stderr:
            print("Subprocess result after tag removal:", output)  # Detailed logging after tag removal
        else:
            print("Subprocess error:", stderr.decode())  # Detailed error logging
            output = "An error occurred while processing your request."
    except Exception as e:
        print("Subprocess exception:", str(e))
        output = "An error occurred while processing your request."
    return output

@app.route('/deepseek', methods=['POST'])
async def deepseek():
    user_input = request.json['input']
    print("Received input:", user_input)  # Debugging line
    output = await run_deepseek(user_input)
    print("Result:", output)  # Debugging line
    return jsonify({'output': output})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=1234)
