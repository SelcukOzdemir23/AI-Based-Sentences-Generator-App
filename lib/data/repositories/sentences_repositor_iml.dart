import '../../domain/repositories/abstract/sentences_repository.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PoemRepositoryImpl implements PoemRepository {
  PoemRepositoryImpl();

  @override
  Future<String> getPoems(String productName) async {
    // TODO: Replace YOUR_API_KEY with your API key.
    var apiKey = "AIzaSyAbKZgDxZ-lL-vNXStTl0S4vZftDSYu890";

    const endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";
    final headers = {'Content-Type': 'application/json'};

    final promptText = """
    Senden "$productName" kelimesini kullanarak ingilizce cümleler üretmeni istiyorum. İngilizce sözlük uygulaması için kullanacağım bunu. 
    
    Öncelikle kelimenin ufak bir tanımını ver. Güzel bir şekilde tanımını yap! Bu tanımı ingilizce olarak yap.
    Burada kelimenin hangi seviye kelime olduğunu yaz. (A1,A2,B1,B2,C1,C2)
    Ayrıca kelimenin sıfatmı, isim mi, zarf mı, fiil mi olduğunu belirt. İngilizce olarak. 
    Ardından Türkçe olarak ne anlama geldiğini yaz. 
    
    Ardından "Easy","Moderate","Difficult" olmak üzere 3 çeşitli türde cümleler üretmeni istiyorum. 
    
    Öncelikle içinde "$productName" geçen ve karışık olmayan ve herkesin anlayabileceği kolay ingilizce cümleler ver. 
    Hemen ardında her cümlenin türkçe anlamını ver. 
    
    Sonra içinde "$productName" geçen ve orta seviyede ingilizce cümleler ver. 
    Hemen ardında her cümlenin türkçe anlamını ver. 
    
    Sonra içinde "$productName" geçen ve İleri seviyede cümleler ver. . 
    Hemen ardında her cümlenin türkçe anlamını ver. 
    
    Sonrasında $productName kelimesiyle kurulan "phrase" leri ver. Phrase'lerin türkçe anlamlarını hemen altına ver. 
    
    $productName kelimesinin çeşitli şekilde "phrase" hallerini kullanmaya dikkat et. Bir sözlük gibi çalış. Cümleler kurarken $productName kelimesinin çok kullanılan phrase halleri varsa onlarla da cümle kur. 
    
    
    "$productName" bir KELİME ya da bir PHRASE olmalı. Eğer ki uzun bir cümle ise CEVAP VERME , sadece : "Lütfen bir kelime girin" yaz. 
    
    Çıktı şuna benzemeli:
    
    Small Definition: 
    Level:
    Type:
    
    Turkish Meaning: 
    
    Easy Sentences:
    
    Moderate Sentences:
    
    Difficult Sentences: 
    
    Phrase with $productName: 
    
    
    
    
    """;
    final body = {
      "contents": [
        {
          "parts": [
            {"text": promptText}
          ]
        }
      ]
    };

    try {
      final response = await http.post(Uri.parse("$endpoint?key=$apiKey"), headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return decodedResponse['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Request failed with status: ${response.statusCode}.\n\n${response.body}';
      }
    } catch (error) {
      throw Exception('Error sending POST request: $error');
    }
  }
}
