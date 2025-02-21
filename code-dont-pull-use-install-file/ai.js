// Function to add messages to the chat window with appropriate classes
function addMessageToChat(content, sender) {
    const chatMessages = document.getElementById('chat-messages');
    const messageElement = document.createElement('div');
    messageElement.classList.add('chat-message', sender);

    // Process markdown-like bold syntax (**bold text**)
    content = content.replace(/\*\*(.*?)\*\*/g, '<b>$1</b>');

    // Process math expressions (using LaTeX delimiters)
    content = content.replace(/\\\[(.*?)\\\]/g, '<span class="math">$1</span>');

    messageElement.innerHTML = content;
    chatMessages.appendChild(messageElement);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

// Event listener for the send button
document.getElementById('send-button').addEventListener('click', async () => {
    const userInput = document.getElementById('user-input').value.trim();
    if (userInput === '') return;

    // Display user's message
    addMessageToChat(userInput, 'user');
    document.getElementById('user-input').value = '';

    // Show typing indicator
    const typingIndicator = document.createElement('div');
    typingIndicator.classList.add('chat-message', 'ai');
    typingIndicator.innerText = 'KAI is typing...';
    typingIndicator.id = 'typing-indicator';
    document.getElementById('chat-messages').appendChild(typingIndicator);
    document.getElementById('chat-messages').scrollTop = document.getElementById('chat-messages').scrollHeight;

    // Send user's message to the server
    try {
        const response = await fetch('/deepseek', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ input: userInput })
        });

        const data = await response.json();

        // Remove typing indicator
        typingIndicator.remove();

        // Display AI's message
        addMessageToChat(data.output, 'ai');

    } catch (error) {
        console.error('Error:', error);
        // Remove typing indicator
        typingIndicator.remove();
        // Display error message
        addMessageToChat('An error occurred while processing your request.', 'ai');
    }
});

// Allow pressing Enter key to send the message
document.getElementById('user-input').addEventListener('keypress', function (e) {
    if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        document.getElementById('send-button').click();
    }
});
