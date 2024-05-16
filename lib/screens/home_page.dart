import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_finder_assessment/data/recipe_api.dart';
import 'package:recipe_finder_assessment/models/recipe_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> dietCategories = [
    'All',
    'Gluten Free',
    'Ketogenic',
    'Vegetarian',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Vegan',
    'Pescetarian',
    'Paleo',
    'Primal',
    'Low FODMAP',
    'Whole30',
  ];

  String selectedCategory = 'All';

  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipesByCategory(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 247, 222),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 247, 222),
        title: const Text('Recipes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 130.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dietCategories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _fetchRecipesByCategory(dietCategories[index]);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                        color: selectedCategory == dietCategories[index]
                            ? Colors.white
                            : const Color.fromARGB(255, 232, 232, 232),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: selectedCategory == dietCategories[index]
                                ? Colors.black
                                : Colors.transparent)),
                    child: Center(
                      child: Text(
                        dietCategories[index],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 40.sp),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      // Handle recipe tap
                    },
                    child: Stack(
                      children: [
                        SizedBox(
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
          ),
        ],
      ),
    );
  }

  Future<void> _fetchRecipesByCategory(String category) async {
    setState(() {
      selectedCategory = category;
      recipes.clear();
    });

    try {
      if (category == 'All') {
        // Fetch all recipes
        List<Recipe> allRecipes = await _fetchAllRecipes();
        setState(() {
          recipes = allRecipes;
        });
      } else {
        // Fetch recipes based on the selected category
        List<Recipe> categoryRecipes = await fetchRecipesByDiet(category);
        setState(() {
          recipes = categoryRecipes;
        });
      }
    } catch (e) {
      print("Error fetching recipes: $e");
    }
  }

  // Function to fetch all recipes
  Future<List<Recipe>> _fetchAllRecipes() async {
    List<Recipe> allRecipes = [];
    for (String category in dietCategories.sublist(1)) {
      List<Recipe> categoryRecipes = await fetchRecipesByDiet(category);
      allRecipes.addAll(categoryRecipes);
    }
    return allRecipes;
  }
}
