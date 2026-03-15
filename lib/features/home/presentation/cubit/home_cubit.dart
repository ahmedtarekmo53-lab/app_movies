import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/models/movie_model.dart';
import 'package:movies_app/core/network/dio_helper.dart';

abstract class HomeStates {}
class HomeInitialState extends HomeStates {}
class HomeLoadingState extends HomeStates {}
class HomeSuccessState extends HomeStates {}
class HomeErrorState extends HomeStates {
  final String error;
  HomeErrorState(this.error);
}

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<MovieModel> movies = [];
  Set<String> genres = {};

  void getMovies() {
    emit(HomeLoadingState());
    DioHelper.getData(url: 'list_movies.json').then((value) {
      if (value.data['status'] == 'ok') {
        var data = value.data['data']['movies'] as List;
        movies = data.map((m) => MovieModel.fromJson(m)).toList();
        
        // المتطلب الخاص بالتوثيق: تحويل الـ Genres لـ Set
        genres = MovieModel.getAllGenres(movies);
        
        emit(HomeSuccessState());
      }
    }).catchError((error) {
      emit(HomeErrorState(error.toString()));
    });
  }
}
