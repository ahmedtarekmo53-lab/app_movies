import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies_app/core/models/movie_model.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/shared/widgets/custom_button.dart';
import 'package:movies_app/core/network/dio_helper.dart';
import 'package:movies_app/shared/widgets/movie_card.dart';
import 'package:movies_app/core/utils/cache_helper.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieModel movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  List<MovieModel> suggestedMovies = [];
  List<dynamic> parentalGuides = [];
  bool isLoadingSuggestions = true;
  bool isLoadingGuides = true;
  bool isInWatchlist = false;

  late Box<MovieModel> watchlistBox;
  late Box<MovieModel> historyBox;

  @override
  void initState() {
    super.initState();
    watchlistBox = Hive.box<MovieModel>('watchlist');
    historyBox = Hive.box<MovieModel>('history');
    isInWatchlist = watchlistBox.containsKey(widget.movie.id);
    
    getSuggestions();
    getParentalGuides();
  }

  void getSuggestions() {
    DioHelper.getData(
      url: 'movie_suggestions.json',
      query: {'movie_id': widget.movie.id},
    ).then((value) {
      if (value.data['status'] == 'ok' && value.data['data']['movies'] != null) {
        var data = value.data['data']['movies'] as List;
        setState(() {
          suggestedMovies = data.map((m) => MovieModel.fromJson(m)).toList();
          isLoadingSuggestions = false;
        });
      } else {
        setState(() => isLoadingSuggestions = false);
      }
    }).catchError((error) {
      setState(() => isLoadingSuggestions = false);
    });
  }

  void getParentalGuides() {
    DioHelper.getData(
      url: 'movie_parental_guides.json',
      query: {'movie_id': widget.movie.id},
    ).then((value) {
      if (value.data['status'] == 'ok' && value.data['data']['parental_guides'] != null) {
        setState(() {
          parentalGuides = value.data['data']['parental_guides'];
          isLoadingGuides = false;
        });
      } else {
        setState(() => isLoadingGuides = false);
      }
    }).catchError((error) {
      setState(() => isLoadingGuides = false);
    });
  }

  void toggleWatchlist() async {
    if (isInWatchlist) {
      await watchlistBox.delete(widget.movie.id);
    } else {
      await watchlistBox.put(widget.movie.id, widget.movie);
    }
    
    setState(() {
      isInWatchlist = !isInWatchlist;
    });

    // Update count in CacheHelper for Profile Tab
    await CacheHelper.saveData(key: "wishListCount", value: watchlistBox.length);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isInWatchlist ? "Added to Watch List" : "Removed from Watch List"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void addToHistory() async {
    await historyBox.put(widget.movie.id, widget.movie);
    
    // Update count in CacheHelper for Profile Tab
    await CacheHelper.saveData(key: "historyCount", value: historyBox.length);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Added to History"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.movie.bigPoster,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [AppColors.background, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.movie.title,
                          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: toggleWatchlist,
                        icon: Icon(
                          isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                          color: AppColors.primary,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.primary, size: 20),
                      const SizedBox(width: 5),
                      Text("${widget.movie.rating} (IMDb)", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(width: 15),
                      Text("${widget.movie.year}  •  ${widget.movie.runtime} min", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    children: widget.movie.genres.map((genre) => Chip(
                      label: Text(genre),
                      backgroundColor: Colors.grey[900],
                      labelStyle: const TextStyle(color: AppColors.primary, fontSize: 12),
                    )).toList(),
                  ),
                  const SizedBox(height: 25),
                  const Text("Story Line", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(widget.movie.description, style: const TextStyle(color: Colors.grey, fontSize: 15, height: 1.5)),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: "Watch Now", 
                    onPressed: () {
                      addToHistory();
                      // Logic to play movie...
                    }
                  ),
                  const SizedBox(height: 30),

                  /// Parental Guides Section
                  if (parentalGuides.isNotEmpty) ...[
                    const Text("Parental Guide", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...parentalGuides.take(3).map((guide) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${guide['type']}: ${guide['notes']}",
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 30),
                  ],

                  /// Suggestions Section
                  const Text("More Like This", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  isLoadingSuggestions
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : SizedBox(
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: suggestedMovies.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 15),
                                child: MovieCard(movie: suggestedMovies[index]),
                              );
                            },
                          ),
                        ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
