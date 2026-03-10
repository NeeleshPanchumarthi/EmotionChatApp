# EmotionChatApp

An intelligent emotion-aware chat application that detects user emotions from text and generates context-aware responses. The app combines modern mobile development, machine learning, and AI-powered conversational responses to create a more empathetic chat experience.

🚀 Features

Emotion Detection from Text

Uses a fine-tuned DistilRoBERTa transformer model to classify user emotions.

AI Generated Responses

Integrates Google Gemini API to generate context-aware replies based on detected emotions.

Mobile Application

Built with Flutter for cross-platform mobile support.

Machine Learning Backend

Uses PyTorch for loading and running the trained emotion detection model.

REST API Backend

Backend implemented with Flask to serve emotion detection and response generation endpoints.

Real-time Interaction

User message → emotion detection → AI reply generation → response returned to the Flutter app.


🧠 Tech Stack

Mobile
 Flutter
 Dart
Backend
  Flask
  Python
  PyTorch
  Transformers
ML Model
  DistilRoBERTa (Emotion Classification Model)
AI Response Generation
  Google Gemini API

