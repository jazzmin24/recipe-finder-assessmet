import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_finder_assessment/data/search_api.dart';
import 'package:recipe_finder_assessment/models/search_model.dart';

class FavoriteRecipesPage extends StatelessWidget {
  final Set<int> favoritedRecipeIds;
  final RecipeAPIService _recipeAPIService = RecipeAPIService();
  

  FavoriteRecipesPage({required this.favoritedRecipeIds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 222),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 247, 222),
        title: const Text('Favorite Recipes'),
      ),
      body: FutureBuilder<List<SearchModel>>(
        future: _fetchFavoriteRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final recipe = snapshot.data![index];
                return Card(
                  color: Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.all(12),
                  child: InkWell(
                   
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 500.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              recipe.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.5), // Semi-transparent black background
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                recipe.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              
              },
            );
          }
        },
      ),
    );
  }

  Future<List<SearchModel>> _fetchFavoriteRecipes() async {
    List<SearchModel> favoriteRecipes = [];
    try {
      for (int id in favoritedRecipeIds) {
        final recipe = await _recipeAPIService.getRecipeById(id);
       
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
