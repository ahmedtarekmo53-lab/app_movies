import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/network/dio_helper.dart';
import 'package:movies_app/core/utils/cache_helper.dart';

abstract class AuthStates {}
class AuthInitialState extends AuthStates {}
class AuthLoadingState extends AuthStates {}
class AuthLoginSuccessState extends AuthStates {
  final String token;
  AuthLoginSuccessState(this.token);
}
class AuthLoginErrorState extends AuthStates {
  final String error;
  AuthLoginErrorState(this.error);
}
class AuthRegisterSuccessState extends AuthStates {}
class AuthRegisterErrorState extends AuthStates {
  final String error;
  AuthRegisterErrorState(this.error);
}

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  void login({required String email, required String password}) {
    emit(AuthLoadingState());
    
    // استخدام authDio الخاص بالـ Auth Base URL
    DioHelper.postData(
      url: 'login', 
      data: {'email': email, 'password': password},
      isAuth: true,
    ).then((value) {
      String token = value.data['token'] ?? '';
      CacheHelper.saveData(key: 'token', value: token);
      emit(AuthLoginSuccessState(token));
    }).catchError((error) {
      emit(AuthLoginErrorState(error.toString()));
    });
  }

  void register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    emit(AuthLoadingState());
    DioHelper.postData(
      url: 'register',
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
      isAuth: true,
    ).then((value) {
      emit(AuthRegisterSuccessState());
    }).catchError((error) {
      emit(AuthRegisterErrorState(error.toString()));
    });
  }
}
