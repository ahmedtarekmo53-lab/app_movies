import 'package:flutter_bloc/flutter_bloc.dart';
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
    
    // Fake Login Logic لضمان عمل التطبيق في Phase 1
    // بمجرد حصولك على API الـ Auth، قم بتفعيل الـ DioHelper.postData
    Future.delayed(const Duration(seconds: 1), () {
      String fakeToken = "dummy_token_123";
      CacheHelper.saveData(key: 'token', value: fakeToken);
      emit(AuthLoginSuccessState(fakeToken));
    });
  }

  void register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    emit(AuthLoadingState());

    // Fake Register Logic
    Future.delayed(const Duration(seconds: 1), () {
      emit(AuthRegisterSuccessState());
    });
  }
}
