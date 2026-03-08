import 'package:flutter/material.dart';
import 'package:movies_app/core/network/dio_helper.dart';
import 'package:movies_app/core/models/movie_model.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/shared/widgets/movie_card.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  List<MovieModel> searchResults = [];
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();

  void searchMovies(String query) {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }
    
    setState(() => isLoading = true);
    DioHelper.getData(
      url: 'list_movies.json',
      query: {'query_term': query},
    ).then((value) {
      if (value.data['status'] == 'ok' && value.data['data']['movies'] != null) {
        var data = value.data['data']['movies'] as List;
        setState(() {
          searchResults = data.map((m) => MovieModel.fromJson(m)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          searchResults = [];
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
        title: TextField(
          controller: searchController,
          onChanged: searchMovies,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search Movies...",
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.movie_creation_outlined, size: 100, color: Colors.grey[800]),
                      const SizedBox(height: 20),
                      const Text("Type to search for movies", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) => MovieCard(movie: searchResults[index]),
                ),
    );
  }
}
