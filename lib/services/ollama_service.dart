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
          ),
        );
        return generated.response;
      }
    } catch (e) {
      print('Error generating completion: $e');
      return null;
    }
  }

  /// Generates a chat completion based on a list of messages.
  ///
  /// [modelName] The name of the Ollama model to use (e.g., 'llama3', 'mistral').
  /// [messages] A list of [Message] objects representing the conversation history.
  /// [stream] Whether to stream the response (defaults to false).
  ///
  /// Returns the generated chat message content as a String, or null if an error occurs.
  Future<String?> generateChatCompletion({
    required String modelName,
    required List<Message> messages,
    bool stream = false,
  }) async {
    try {
      if (stream) {
        String fullContent = '';
        final streamResponse = _client.generateChatCompletionStream(
          request: GenerateChatCompletionRequest(
            model: modelName,
            messages: messages,
            stream: true,
          ),
        );
        await for (final res in streamResponse) {
          fullContent += res.message?.content?.trim() ?? '';
        }
        return fullContent;
      } else {
        final res = await _client.generateChatCompletion(
          request: GenerateChatCompletionRequest(
            model: modelName,
            messages: messages,
            stream: false,
          ),
        );
        return res.message?.content;
      }
    } catch (e) {
      print('Error generating chat completion: $e');
      return null;
    }
  }
}
