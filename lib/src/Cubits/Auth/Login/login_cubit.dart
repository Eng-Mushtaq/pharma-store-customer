import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_warehouse_store_mobile/main.dart';
import 'package:pharmacy_warehouse_store_mobile/src/model/user.dart';
import 'package:pharmacy_warehouse_store_mobile/src/services/api.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void signInWithPhoneNumberAndPassword(
      {required String phoneNumber, required String password}) async {
    try {
      emit(LoginLoading());
      dynamic loginData = await Api.request(
        url: 'login',
        body: {
          'email': phoneNumber,
          'password': password,
        },
        headers: {
          'FCMToken': User.fCMToken ?? "",
        },
        token: User.token,
        methodType: MethodType.post,
      );
      dynamic token = loginData['token'];
      print(loginData);
      User.token = token;
      // await Future.delayed(const Duration(seconds: 2));
      emit(LoginSuccess());
    } on DioException catch (exception) {
      logger.e("Login Cubit : \nNetwork Failure + ${exception.toString()}");
      emit(LoginFailure(errorMessage: exception.message.toString()));
    } catch (e) {
      logger.e("Login Cubit : \nGeneral Failure + ${e.toString()}");
      emit(LoginFailure(errorMessage: e.toString()));
    }
  }
}
class LoginModel {
  LoginModel({
    required this.user,
    required this.token,
  });
  late final UserModel user;
  late final String token;

  LoginModel.fromJson(Map<String, dynamic> json){
    user = UserModel.fromJson(json['user']);
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user'] = user.toJson();
    _data['token'] = token;
    return _data;
  }
}

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    this.avatar,
    this.note,
    this.type,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final Null phone;
  late final Null address;
  late final Null avatar;
  late final Null note;
  late final Null type;
  late final String email;
  late final Null emailVerifiedAt;
  late final String createdAt;
  late final String updatedAt;

  UserModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phone = null;
    address = null;
    avatar = null;
    note = null;
    type = null;
    email = json['email'];
    emailVerifiedAt = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['address'] = address;
    _data['avatar'] = avatar;
    _data['note'] = note;
    _data['type'] = type;
    _data['email'] = email;
    _data['email_verified_at'] = emailVerifiedAt;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}