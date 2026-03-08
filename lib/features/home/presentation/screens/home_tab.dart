import 'package:flutter/material.dart';
import 'package:movies_app/core/network/dio_helper.dart';
import 'package:movies_app/core/models/movie_model.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/shared/widgets/movie_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<MovieModel> movies = [];
  List<MovieModel> topRatedMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  void getAllData() async {
    setState(() => isLoading = true);
    await getTopRatedMovies();
    await getMovies();
    setState(() => isLoading = false);
  }

  Future<void> getTopRatedMovies() async {
    // API: Top Rated Movies
    return DioHelper.getData(
      url: 'list_movies.json',
      query: {'sort_by': 'rating', 'limit': 10},
    ).then((value) {
      if (value.data['status'] == 'ok') {
        var data = value.data['data']['movies'] as List;
        topRatedMovies = data.map((m) => MovieModel.fromJson(m)).toList();
      }
    }).catchError((error) => debugPrint(error.toString()));
  }

  Future<void> getMovies() async {
    // API: General Movies
    return DioHelper.getData(url: 'list_movies.json').then((value) {
      if (value.data['status'] == 'ok') {
        var data = value.data['data']['movies'] as List;
        movies = data.map((m) => MovieModel.fromJson(m)).toList();
      }
    }).catchError((error) => debugPrint(error.toString()));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: AppColors.background,
            floating: true,
            title: Text(
              "Movies App",
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),
          
          /// Top Rated Section
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    "Top Rated Movies",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 15),
                    itemCount: topRatedMovies.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 150,
                        margin: const EdgeInsets.only(right: 15),
                        child: MovieCard(movie: topRatedMovies[index]),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Text(
                    "Discover All Movies",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          /// General Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => MovieCard(movie: movies[index]),
                childCount: movies.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
