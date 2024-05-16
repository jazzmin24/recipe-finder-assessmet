import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_finder_assessment/data/search_api.dart';
import 'package:recipe_finder_assessment/screens/favourite_recipes.dart';
import 'package:recipe_finder_assessment/screens/home_page.dart';
import 'package:recipe_finder_assessment/models/search_model.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final RecipeAPIService _recipeAPIService = RecipeAPIService();
  List<SearchModel> recipes = [];
  TextEditingController _searchController = TextEditingController();
  Set<int> favoritedRecipeIds = Set<int>();

  @override
  void initState() {
    super.initState();
    _searchRecipes('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 222),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 247, 222),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 140.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: const Color.fromARGB(255, 134, 134, 134)),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 20.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search recipes by ingredients...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          _searchRecipes(value);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _searchRecipes(_searchController.text);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20.w),
            IconButton(
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 32,
              ),
              onPressed: () {
                // Navigate to FavoriteRecipesPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteRecipesPage(
                      favoritedRecipeIds: favoritedRecipeIds,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          bool isFavorited = favoritedRecipeIds.contains(recipes[index].id);
          return Card(
            color: Colors.white,
            elevation: 3,
            margin: const EdgeInsets.all(12),
            child: InkWell(
              onTap: () {
                // Handle recipe tap
              },
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 500.h, // Adjust the height as needed
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        recipes[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isFavorited) {
                            favoritedRecipeIds.remove(recipes[index].id);
                          } else {
                            favoritedRecipeIds.add(recipes[index].id);
                          }
                        });
                      },
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
                          recipes[index].title,
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to homepage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        label: const Text('Vegetarian'),
        icon: const Icon(Icons.emoji_food_beverage),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _searchRecipes(String query) async {
    try {
      List<SearchModel> fetchedRecipes;
      if (query.isEmpty) {
        // Fetch all recipes if the query is empty
        fetchedRecipes = await _recipeAPIService.getAllRecipes();
      } else {
        fetchedRecipes = await _recipeAPIService.findRecipesByQuery(query);
      }
      if (mounted) {
        setState(() {
          recipes = fetchedRecipes;
        });
      }
    } catch (e) {
      print('Error fetching recipes: $e');
      // Handle error
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
