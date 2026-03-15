import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies_app/core/constants/app_colors.dart';
import 'package:movies_app/core/constants/routes.dart';
import 'package:movies_app/core/utils/cache_helper.dart';
import 'package:movies_app/core/models/movie_model.dart';
import 'package:movies_app/shared/widgets/movie_card.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with SingleTickerProviderStateMixin {
  late TabController tabController;
  String name = "";
  String avatar = "";

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    loadUserData();
  }

  void loadUserData() {
    setState(() {
      name = CacheHelper.getData(key: "userName") ?? "John Safwat";
      avatar = CacheHelper.getData(key: "userAvatar") ?? "assets/images/Component 11 – 1.png";
    });
  }

  void logout() async {
    await CacheHelper.clearData();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SizedBox(height: 60),
          /// Header Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(avatar.isEmpty ? "assets/images/Component 11 – 1.png" : avatar),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: Hive.box<MovieModel>('watchlist').listenable(),
                            builder: (context, Box<MovieModel> box, _) {
                              return _buildStatColumn(box.length.toString(), "Wish List");
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: Hive.box<MovieModel>('history').listenable(),
                            builder: (context, Box<MovieModel> box, _) {
                              return _buildStatColumn(box.length.toString(), "History");
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          /// Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      final result = await Navigator.pushNamed(context, AppRoutes.updateProfile);
                      if (result == true) {
                        loadUserData();
                      }
                    },
                    child: const Text("Edit Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: logout,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Exit", style: TextStyle(color: Colors.white)),
                        SizedBox(width: 5),
                        Icon(Icons.logout, size: 16, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          /// Tab Bar
          TabBar(
            controller: tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.white,
            tabs: const [
              Tab(icon: Icon(Icons.list), text: "Watch List"),
              Tab(icon: Icon(Icons.folder), text: "History"),
            ],
          ),
          /// Tab Views
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildHiveList('watchlist'),
                _buildHiveList('history'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildHiveList(String boxName) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MovieModel>(boxName).listenable(),
      builder: (context, Box<MovieModel> box, _) {
        if (box.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.movie_filter, size: 100, color: Colors.grey.withOpacity(0.5)),
                const SizedBox(height: 20),
                Text("Your $boxName is empty", style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        final movies = box.values.toList();
        return GridView.builder(
          padding: const EdgeInsets.all(15),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return MovieCard(movie: movies[index]);
          },
        );
      },
    );
  }
}
