# groq_translation.py
from decouple import config
from groq import Groq

# Set up the Groq client
client = Groq(api_key=config("GROQ_API_KEY"))


# Translate text using the Groq API
def groq_infer(query, language="english"):
    # Create a chat completion
    chat_completion = client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": """
                You are a helpful assistant that help an elderly person.
                You should treat that person with respect and patience
                and answer her in the following language: {language}
                """,
            },
            {"role": "user", "content": f"{query}"},
        ],
        model="mixtral-8x7b-32768",
        temperature=0.2,
        max_tokens=1024,
        stream=False,
        response_format={"type": "text"},
        # response_format={"type": "json_object"},
    )
    # Return the translated text

    return chat_completion.choices[0].message.content
