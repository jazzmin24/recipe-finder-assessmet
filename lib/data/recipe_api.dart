import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_finder_assessment/models/recipe_model.dart';

Future<List<Recipe>> fetchRecipesByDiet(String diet) async {
  final apiKey = 'a00f00a49e0449209e4f9b58c4cbcd27';
  final url = Uri.https('api.spoonacular.com', '/recipes/complexSearch', {
    'diet': diet,
    'apiKey': apiKey,
  });

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['results'] != null) {
        List<dynamic> results = data['results'];
        List<Recipe> recipes =
            results.map((json) => Recipe.fromJson(json)).toList();
        return recipes;
      } else {
        throw Exception('No results found');
      }
    } else {
      throw Exception('Failed to load recipes');
    }
  } catch (e) {
    print('Error: $e');
    return []; 
  }
}
