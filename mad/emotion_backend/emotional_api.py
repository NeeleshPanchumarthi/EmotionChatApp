from flask import Flask, request, jsonify
from flask_cors import CORS
from transformers import pipeline
from google import genai

# 🔑 Replace with your Gemini API Key
client = genai.Client(api_key="AIzaSyDYOnvTwuSPwNkobUDAGGZrKsFd6sNrZsE")

app = Flask(__name__)
CORS(app)

# 🧠 Emotion detection model (local ML)
emotion_model = pipeline(
    "text-classification",
    model="j-hartmann/emotion-english-distilroberta-base",
    top_k=None
)

# 🧠 Memory storage
conversation_history = []
emotion_history = []

# ⭐ Confidence threshold
THRESHOLD = 0.5


# -------- Greeting detector --------
def is_greeting(text):
    greetings = [
        "hi", "hello", "hey",
        "good morning", "good evening", "good afternoon"
    ]
    return text.lower().strip() in greetings


@app.route("/chat", methods=["POST"])
def chat():
    data = request.get_json()
    user_text = data.get("message", "").strip()

    if not user_text:
        return jsonify({"reply": "Say something 🙂"})

    # ✅ Instant greeting response
    if is_greeting(user_text):
        reply = "Hey! 😊 How are you doing today?"
        return jsonify({
            "reply": reply,
            "emotion": "neutral",
            "confidence": 1.0,
            "dominant_emotion": "neutral"
        })

    # ---------- Emotion Detection ----------
    results = emotion_model(user_text)[0]

    top = max(results, key=lambda x: x["score"])
    confidence = round(top["score"], 3)

    if confidence < THRESHOLD:
        emotion = "neutral"
    else:
        emotion = top["label"]

    # Save memory
    emotion_history.append(emotion)
    conversation_history.append(f"User: {user_text}")

    # ---------- Dominant Emotion ----------
    if emotion_history:
        dominant_emotion = max(
            set(emotion_history),
            key=emotion_history.count
        )
    else:
        dominant_emotion = "neutral"

    # ---------- Format conversation history ----------
    history_text = "\n".join(conversation_history[-6:])

    # ---------- Prompt ----------
    prompt = f"""
You are a friendly human-like chat companion.

User emotion now: {emotion}
Dominant emotion in conversation: {dominant_emotion}

Conversation history:
{history_text}

Reply casually like a real friend.
NOT like a therapist.
Keep it short (1–2 sentences).
Be warm, natural, and engaging.
"""

    # ---------- Gemini Response ----------
    try:
        response = client.models.generate_content(
            model="gemini-2.0-flash",
            contents=prompt
        )

        reply = response.text.strip()

    except Exception as e:
        reply = f"Error: {e}"

    # Save bot reply
    conversation_history.append(f"Bot: {reply}")

    return jsonify({
        "reply": reply,
        "emotion": emotion,
        "confidence": confidence,
        "dominant_emotion": dominant_emotion
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5012, debug=True)