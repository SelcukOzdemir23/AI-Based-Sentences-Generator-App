import '../../domain/repositories/abstract/poem_repository.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PoemRepositoryImpl implements PoemRepository {
  PoemRepositoryImpl();

  @override
  Future<String> getPoems(String productName) async {
    // TODO: Replace YOUR_API_KEY with your API key.
    var apiKey = "AIzaSyCVeWf_8fpMPXvxZFFJ0U_8AuFcD0aTP5w";

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta2/models/chat-bison-001:generateMessage?key=$apiKey');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "prompt": {
        "context":
            "You are a Turkish translator and you create various and complex sentences containing the word '$productName'. Use the provided 'phrase' variations for creating sentences with different levels of difficulty.",

        "messages": [
          {
            "content":
                "$productName! Create sentences using different 'phrase' variations for diverse and complex structures. Provide the difficulty level and Turkish translations immediately below each set of sentences. Use the following format:",
            "content": """
Small Definition: <your answer>
<Meaning of the word as Turkish (if the word has more than one meaning , give all of them)>
Easy: <your sentences>
<Turkish translation>
Moderate: <your sentences>
<Turkish translation>
Difficult: <your sentences>
<Turkish translation>
<Phrases with $productName>
            """
          }
        ]
      },
      "temperature": 1,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return decodedResponse['candidates'][0]['content'];
      } else {
        return 'Request failed with status: ${response.statusCode}.\n\n${response.body}';
      }
    } catch (error) {
      throw Exception('Error sending POST request: $error');
    }
  }
}
