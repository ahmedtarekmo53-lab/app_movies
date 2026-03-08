import 'package:flutter/material.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/network/dio_helper.dart';
import 'package:movies_app/core/models/movie_model.dart';
import 'package:movies_app/shared/widgets/movie_card.dart';

class BrowseTab extends StatefulWidget {
  const BrowseTab({super.key});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  final List<String> genres = [
    "Action",
    "Adventure",
    "Animation",
    "Biography",
    "Comedy",
    "Crime",
    "Documentary",
    "Drama",
    "Family",
    "Fantasy",
    "History",
    "Horror",
    "Music",
    "Musical",
    "Mystery",
    "Romance",
    "Sci-Fi",
    "Short",
    "Sport",
    "Thriller",
    "War",
    "Western"
  ];

  String selectedGenre = "Action";
  List<MovieModel> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getMoviesByGenre(selectedGenre);
  }

  void getMoviesByGenre(String genre) {
    setState(() => isLoading = true);
    DioHelper.getData(
      url: 'list_movies.json',
      query: {'genre': genre},
    ).then((value) {
      if (value.data['status'] == 'ok' && value.data['data']['movies'] != null) {
        var data = value.data['data']['movies'] as List;
        setState(() {
          movies = data.map((m) => MovieModel.fromJson(m)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          movies = [];
          isLoading = false;
        });
      }
    }).catchError((error) {
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Browse by Genre", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: genres.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedGenre == genres[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGenre = genres[index];
                    });
                    getMoviesByGenre(selectedGenre);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.grey.shade700,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        genres[index],
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : movies.isEmpty
                    ? const Center(child: Text("No movies found in this genre", style: TextStyle(color: Colors.grey)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(15),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) => MovieCard(movie: movies[index]),
                      ),
          ),
        ],
      ),
    );
  }
}
