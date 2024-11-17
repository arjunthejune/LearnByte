from flask import Flask, request, jsonify
from groq import Groq
from dotenv import load_dotenv
import os
import json
load_dotenv()


client = Groq(api_key=os.environ.get('GROQ_API_KEY'))
app = Flask(__name__)

with open("prompt.txt", "r") as f:
    system_prompt = f.read().strip()

@app.route('/getCards', methods=['POST'])
def getCards():
    data = request.json
    userInput = data.get('userInput', "Please generate a flashcard set based on the data provided")
    
    try:
        completion = client.chat.completions.create(
            messages=[
                {
                    "role": "system",
                    "content": system_prompt + "\nIMPORTANT: Your response MUST be in valid JSON format with the following structure: {'title': 'string', 'cards': [{'term': 'string', 'definition': 'string'}]}. Do not include any text outside of this JSON structure."
                },
                {
                    "role": "user",
                    "content": userInput
                },
            ],
            model="mixtral-8x7b-32768",
            temperature=0.2  # Lower temperature for more consistent outputs
        )
        
        # Parse the JSON response
        response_content = completion.choices[0].message.content
        json_response = json.loads(response_content)
        
        # Validate the structure of the JSON response
        if not isinstance(json_response, dict) or 'title' not in json_response or 'cards' not in json_response:
            raise ValueError("Invalid JSON structure in the response")
        
        return jsonify(json_response)
    except json.JSONDecodeError as e:
        return jsonify({"error": f"Failed to parse JSON response from the model. Error: {str(e)}"}), 500
    except ValueError as e:
        return jsonify({"error": str(e)}), 500
    except Exception as e:
        return jsonify({"error": f"An unexpected error occurred: {str(e)}"}), 500

if __name__ == "__main__":
    app.run(port=5000, debug=True)