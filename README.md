# 🧠 MindNote AI

A Flutter-based app designed for **mental health professionals** to efficiently track patient progress, manage session notes, and gain insights. Leveraging a **fine-tuned** Gemma 3n model on ollama.

---

## 📱 Features

- 👤 **Patient management** (add/edit/view profiles)  
- 🗓️ **Session scheduling** and tracking  
- 📝 **Session notes** generation (SOAP & DAP templates)  
- 🖼️ **Image-based insights** via a vision-capable GGUF model  
- 🔒 **Privacy-first**: all inference runs locally on your machine  

---

## 🚀 Getting Started

These instructions will help you run the full stack—both the Flutter app and the Ollama server with text & vision models—on your local development environment.

### Prerequisites

- **Flutter SDK** (≥3.0.0) & [setup guide](https://flutter.dev/docs/get-started/install)  
- **Android Studio** or **Xcode** for emulator/simulator support  
- **Dart** (bundled with Flutter)  
- **Ollama CLI & Server** (v0.6+)

### 1. Clone & Install Flutter Dependencies

```bash
# Clone the repo
git clone https://github.com/VanessaTong/MindNoteAI.git
cd MindNoteAI

# Fetch Dart & Flutter packages
flutter pub get

```

### 2. Set Up Ollama Server & Models
a. Install Ollama
```bash
brew install ollama
```
Or download the appropriate installer from https://ollama.com/download and follow the prompts.

b. Launch the Ollama daemon
```bash
# Foreground (for manual testing)
ollama serve

# Verify if it is running
curl http://localhost:11434
```

c. Pull gemma 3 model for vision model

```bash
ollama pull gemma3
```

d. Download a GGUF file directly from Hugging Face:

1. **Via web UI:**

   - Go to the Hugging Face model page (e.g. `https://huggingface.co/vannotanno/gemma3n-finetune-notes-gguf`).
   - Click **Download** next to the `.gguf` asset.

2. **Using the Hugging Face Hub CLI:**

   ```bash
   pip install huggingface_hub
   huggingface-cli download google/gemma-3-vision-gguf --filename gemma3-vision.gguf
   ```

3. **Using wget or curl:**

   ```bash
   wget -O gemma3-vision.gguf "https://huggingface.co/vannotanno/gemma3n-finetune-notes-gguf/tree/main/gemma-3n-ft-notes-v2.gguf"
   ```

Then import into ollama:

```bash
echo "FROM ./gemma-3n-ft-notes-v2.gguf" > Modelfile
ollama create gemma3n-text-gen -f Modelfile
```

### 4. Run the Flutter App

#### Android Emulator

```bash
flutter run -d emulator-5554
```

#### iOS Simulator

```bash
flutter run -d ios
```

You can also target web:

```bash
flutter run -d chrome
```

---

## 🌐 Web Demo (UI Only)

For a quick UI preview, we've deployed a **hardcoded demo** on Google Cloud Run: `https://therapy-notes-gem-446856640264.us-central1.run.app/`. This demo does **not** run any models or host inference; it's purely for front-end demonstration.

---

## 📖 Usage

1. **Text-only notes**: leave the image uploader empty, type or paste your session transcript, choose SOAP/DAP, then tap **Generate**.
2. **Vision insights**: tap **Upload Image**, then tap **Generate** and display its description.
