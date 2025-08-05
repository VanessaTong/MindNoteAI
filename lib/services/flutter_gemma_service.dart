import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma/pigeon.g.dart';
import 'dart:typed_data'; // For Uint8List

class FlutterGemmaService {
  final gemma = FlutterGemmaPlugin.instance;

  FlutterGemmaService();

  Future<void> loadModel() async {
    print("loading model");
    return gemma.modelManager
        .setModelPath('/data/local/tmp/gemma-3n-E4B-it-int4.task');
  }

  Future<String> inference(Uint8List? imageBytes) async {
    if (imageBytes == null) {
      return '';
    }
    print("starting inference model");
    final inferenceModel = await FlutterGemmaPlugin.instance.createModel(
      modelType: ModelType.gemmaIt, // Required, model type to create
      preferredBackend: PreferredBackend.gpu, // Optional, backend type
      maxTokens: 512, // Recommended for multimodal models
      // supportImage: true, // Enable image support
      maxNumImages: 1, // Optional, maximum number of images per message
    );

    final session = await inferenceModel.createSession(
        // enableVisionModality: true, // Enable image processing
        );

    print("starting inference session");

    await session.addQueryChunk(
        Message.text(text: 'Tell me something interesting', isUser: true));

    // await session.addQueryChunk(Message.withImage(
    //   text: 'Extract the text from this image',
    //   imageBytes: imageBytes,
    //   isUser: true,
    // ));

    String response = '';
    // Note: session.getResponse() returns String directly
    await for (final token in session.getResponseAsync()) {
      print(token);
      response += token;
    }

    await session.close();

    return response;
  }
}
