import 'package:ollama_dart/ollama_dart.dart';

/// A service class to interact with the Ollama API.
/// It encapsulates the OllamaClient and provides methods for common operations.
class OllamaService {
  final OllamaClient _client;

  /// Initializes the OllamaService.
  /// [baseUrl] is the base URL for the Oll Ollama API.
  /// Defaults to 'http://localhost:11434/api' if not provided.
  OllamaService({String baseUrl = 'http://10.0.2.2:11434/api'})
      : _client = OllamaClient(baseUrl: baseUrl);

  /// Generates a text completion for a given prompt using a specified model.
  ///
  /// [modelName] The name of the Ollama model to use (e.g., 'llama3', 'mistral').
  /// [prompt] The text prompt for which to generate a completion.
  /// [stream] Whether to stream the response (defaults to false).
  ///
  /// Returns the generated response as a String, or null if an error occurs.
  Future<String?> generateCompletion({
    required String modelName,
    required String prompt,
    bool stream = false,
  }) async {
    try {
      if (stream) {
        String fullResponse = '';
        final streamResponse = _client.generateCompletionStream(
          request: GenerateCompletionRequest(
            model: modelName,
            prompt: prompt,
            stream: true,
            format: ResponseFormat.json,
          ),
        );
        await for (final res in streamResponse) {
          fullResponse += res.response?.trim() ?? '';
        }
        return fullResponse;
      } else {
        final generated = await _client.generateCompletion(
          request: GenerateCompletionRequest(
            model: modelName,
            prompt: prompt,
            stream: false,
            format: ResponseFormat.json,
          ),
        );
        return generated.response;
      }
    } catch (e) {
      print('Error generating completion: $e');
      return null;
    }
  }

  /// A function to generate clinical notes (SOAP or DAP) from a transcript using a generative AI model.
  ///
  /// [format]: The desired note format. Can be "soap" or "dap".
  /// [transcript]: The raw text from the patient-clinician conversation.
  ///
  /// Returns a Future<String> containing the generated notes in JSON format.
  String generatePromptFromTranscript(String transcript) {
    // --- Construct the Prompt for the AI Model ---
    // We build a detailed prompt that tells the model exactly how to behave.
    // It includes the persona, the required output format (JSON), and examples for both SOAP and DAP notes.
    final String prompt = """
      You are an assistant for a mental health company.
      Your task is to review the audio transcription of a therapy session and generate case notes in first-person perspective, as if the therapist is personally writing them.
      Follow the specific template selected by the therapist for the session.
      Ensure the language used is professional, clear, and concise.
      Only include information explicitly mentioned in the audio, using direct quotes where appropriate to enhance accuracy.
      Avoid adding interpretations or assumptions beyond what was discussed in the session.
      Respond only with valid JSON. Do not write an introduction or summary.
      Here is a sample output for the SOAP template:
      {{
          "Subjective": "Generated notes about the patient's subjective experience here.",
          "Objective": "Generated notes about objective observations and data here.",
          "Assessment": "Generated assessment and diagnosis here.",
          "Plan": "Generated treatment plan and next steps here."
      }}

      Here is the transcription of the therapy session: "$transcript"
    """;

    return prompt;
  }

  /// A function to generate clinical notes (SOAP or DAP) from a transcript using a generative AI model.
  ///
  /// [format]: The desired note format. Can be "soap" or "dap".
  /// [transcript]: The raw text from the patient-clinician conversation.
  ///
  /// Returns a Future<String> containing the generated notes in JSON format.
  List<String> generatePrompt(String transcript) {
    // --- Construct the Prompt for the AI Model ---
    // We build a detailed prompt that tells the model exactly how to behave.
    // It includes the persona, the required output format (JSON), and examples for both SOAP and DAP notes.
    final List<String> prompt = [
      "You are an assistant for a mental health company.",
      "Your task is to review the audio transcription of a therapy session and generate case notes in first-person perspective, as if the therapist is personally writing them.",
      "Follow the specific template selected by the therapist for the session.",
      "Ensure the language used is professional, clear, and concise.",
      "Only include information explicitly mentioned in the audio, using direct quotes where appropriate to enhance accuracy.",
      "Avoid adding interpretations or assumptions beyond what was discussed in the session.",
      "Respond only with valid JSON. Do not write an introduction or summary.",
      """Here is a sample output for the SOAP template:
      {{
          "Subjective": "Generated notes about the patient's subjective experience here.",
          "Objective": "Generated notes about objective observations and data here.",
          "Assessment": "Generated assessment and diagnosis here.",
          "Plan": "Generated treatment plan and next steps here."
      }}
      """,
      "Here is the transcription of the therapy session: '$transcript'"
    ];

    return prompt;
  }
}
