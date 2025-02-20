async function sendMessage() {
    let userInput = document.getElementById('user-input').value;
    if (userInput.trim() !== "") {
        addMessage("User", userInput);
        document.getElementById('thinking').style.display = 'flex'; // Show the thinking GIF
        let response = await getAIResponse(userInput);
        document.getElementById('thinking').style.display = 'none';  // Hide the thinking GIF
        addMessage("AI", response);
        document.getElementById('user-input').value = "";
    }
}

function addMessage(sender, message) {
    let messageBox = document.createElement('div');
    messageBox.textContent = `${sender}: ${message}`;
    document.getElementById('messages').appendChild(messageBox);
}

async function getAIResponse(userInput) {
    try {
        const serverUrls = [
            'http://127.0.0.1:1234/deepseek',  // Localhost URL
            'http://192.168.1.102:1234/deepseek'  // Local IP Address URL
        ];

        let response;
        for (const url of serverUrls) {
            console.log('Sending request to the server...', userInput, url); // Log input and request status
            response = await fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ input: userInput })
            });

            if (response.ok) {
                console.log('Received response from the server...', url); // Log after receiving the response
                break;  // Break loop if response is OK
            } else {
                console.log(`HTTP error! status: ${response.status} for URL ${url}`);
            }
        }

        let data = await response.json();
        console.log('Server response data:', data); // Log the response data
        return data.output;
    } catch (error) {
        console.error('Error during fetch:', error); // Log detailed error
        return 'An error occurred while processing your request.';
    }
}
