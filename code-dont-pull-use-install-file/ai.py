from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import cohere
import subprocess
import re

app = Flask(__name__)
CORS(app)  # Enable CORS for the Flask app

# Initialize Cohere API client
COHERE_API_KEY = '2aLtVIUEFBujt0p8BKHUNQYShm0IkeJfkRmcrc5e'
co = cohere.Client(COHERE_API_KEY)

# Routes for serving static files
@app.route('/')
def index():
    return send_from_directory('.', 'ai.html')

@app.route('/ai.css')
def stylesheet():
    return send_from_directory('.', 'ai.css')

@app.route('/ai.js')
def javascript():
    return send_from_directory('.', 'ai.js')

@app.route('/logo.png')
def logo():
    return send_from_directory('.', 'logo.png')

@app.route('/favicon.ico')
def favicon():
    return send_from_directory('.', 'favicon.ico')

# Function to generate text with Cohere
def generate_text_with_cohere(messages):
    try:
        user_input = messages[-1]['content']
        conversation_history = '\n'.join([f"{msg['role']}: {msg['content']}" for msg in messages])
        print("Sending input to Cohere:", user_input)
        response = co.generate(
            model='command-xlarge-nightly',  # You can specify the model name
            prompt=conversation_history + "\nai:",
            max_tokens=1500,  # Set the max tokens as needed
            temperature=0.3,
            k=0,
            p=0.75,
            stop_sequences=["\nuser:"]
        )
        output = response.generations[0].text.strip()
        # Make any text enclosed in ** bold
        output = re.sub(r'\*\*(.*?)\*\*', r'<b>\1</b>', output)
        # Format math expressions like LaTeX
        output = re.sub(r'\[([^\]]+)\]', r'\\[\1\\]', output)
        # Apply additional formatting
        output = output.replace('Step 1:', '**Step 1:**')
        output = output.replace('Step 2:', '**Step 2:**')
        output = output.replace('Step 3:', '**Step 3:**')
        output = output.replace('Step 4:', '**Step 4:**')
        output = output.replace('So, the result of the expression is:', '**So, the result of the expression is:**')
        return output
    except Exception as e:
        print("Cohere Exception:", str(e))
        raise e

# Function to run DeepSeek AI (fallback)
def generate_text_with_deepseek(messages):
    try:
        user_input = messages[-1]['content']
        print("Running DeepSeek for input:", user_input)
        process = subprocess.Popen(
            ['ollama', 'run', 'deepseek-r1:7b', '-p', user_input],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        stdout, stderr = process.communicate()
        print("DeepSeek stdout:", stdout)
        print("DeepSeek stderr:", stderr)
        output = stdout.strip()
        # Remove <think> tags using regex
        output = re.sub(r'</?think>', '', output)
        # Make any text enclosed in ** bold
        output = re.sub(r'\*\*(.*?)\*\*', r'<b>\1</b>', output)
        # Format math expressions like LaTeX
        output = re.sub(r'\[([^\]]+)\]', r'\\[\1\\]', output)
        # Apply additional formatting
        output = output.replace('Step 1:', '**Step 1:**')
        output = output.replace('Step 2:', '**Step 2:**')
        output = output.replace('Step 3:', '**Step 3:**')
        output = output.replace('Step 4:', '**Step 4:**')
        output = output.replace('So, the result of the expression is:', '**So, the result of the expression is:**')
        return output
    except Exception as e:
        print("DeepSeek Exception:", str(e))
        return "An error occurred while processing your request."

# API endpoint
@app.route('/deepseek', methods=['POST'])
def deepseek():
    data = request.json
    messages = data.get('messages', [])
    print("Received messages:", messages)
    try:
        output = generate_text_with_cohere(messages)
    except Exception:
        print("Cohere failed, falling back to DeepSeek.")
        output = generate_text_with_deepseek(messages)
    print("Result:", output)
    return jsonify({'output': output})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=4321)
