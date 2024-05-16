import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_finder_assessment/models/recipe_model.dart';
import 'package:recipe_finder_assessment/models/search_model.dart';

class RecipeAPIService {
  final String _baseUrl = 'https://api.spoonacular.com';
  final String _apiKey = 'a00f00a49e0449209e4f9b58c4cbcd27';

  Future<List<SearchModel>> findRecipesByQuery(String query) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/recipes/findByIngredients?ingredients=$query&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SearchModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<SearchModel>> getAllRecipes() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/recipes/complexSearch?apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> recipes = data['results'];
      return recipes.map((json) => SearchModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<Recipe> getRecipeById(int id) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/recipes/$id/information?apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Recipe.fromJson(data);
    } else {
      throw Exception('Failed to load recipe');
    }
  }

  Future<List<SearchModel>> fetchFavoriteRecipes(
      Set<int> favoritedRecipeIds) async {
    List<SearchModel> favoriteRecipes = [];
    try {
      for (int id in favoritedRecipeIds) {
        final recipe = await getRecipeById(id);
        final searchModel = SearchModel(
          id: recipe.id,
          title: recipe.title,
          image: recipe.image, 
        );
        favoriteRecipes.add(searchModel);
      }
    } catch (e) {
      print('Error fetching favorite recipes: $e');
    }
    return favoriteRecipes;
  }
}
