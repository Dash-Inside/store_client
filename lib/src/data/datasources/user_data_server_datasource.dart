import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_client/core/failure/failure.dart';
import 'package:store_client/core/services/services.dart';
import 'package:store_client/src/data/data_failures/data_failure.dart';
import 'package:store_client/src/data/models/user_data_model.dart';
import 'package:store_client/src/data/models/user_model.dart';
import 'package:store_client/src/domain/entities/role.dart';

class UserDataServerDatasource {
  final client = Dio();
  Future<Either<Failure, List<UserDataModel>>> getAllUserDataAllRequest() async {
    try {
      final Response response = await client.get('http://127.0.0.1:1337/api/user-data/');
      final List<dynamic> listMapAllRequest = response.data['data'];
      final List<UserDataModel> result = [];
      listMapAllRequest.forEach((element) {
        result.add(UserDataModel.fromMap(element as Map<String, dynamic>));
      });

      return Right(result);
    } catch (e, stackTrace) {
      return Left(DataFailure(message: 'Failure $e', stackTrace: stackTrace));
    }
  }

  Future<Either<Failure, UserDataModel>> getConcreteUserDataRequest({
    required int id,
  }) async {
    try {
      final Response response = await client.get('http://127.0.0.1:1337/api/user-data/$id');

      return Right(UserDataModel.fromMap(response.data['data']));
    } catch (e, stackTrace) {
      return Left(DataFailure(message: 'Failure $e', stackTrace: stackTrace));
    }
  }

  Future<Either<Failure, UserDataModel>> putUserDataRequest({
    required int id,
    required String? userName,
    required Role? role,
    required String? avatarUrl,
  }) async {
    try {
      final Response response = await client.put(
        'http://127.0.0.1:1337/api/user-data/$id',
        data: <String, dynamic>{
          'data': {
            'username': userName,
            'role': role.toString().replaceFirst('Role.', ''),
            'avatarUrl': avatarUrl,
          },
        },
      );

      return Right(UserDataModel.fromMap(response.data['data']));
    } catch (e, stackTrace) {
      return Left(DataFailure(message: 'Failure $e', stackTrace: stackTrace));
    }
  }

  Future<Either<Failure, UserModel>> loginUserDataRequest({
    required String login,
    required String password,
  }) async {
    try {
      final SharedPreferences sharedPreferences = services.get<SharedPreferences>();
      final Response response = await client.post(
        'http://127.0.0.1:1337/api/auth/local',
        data: <String, dynamic>{
          "identifier": login,
          "password": password,
        },
      );
      await sharedPreferences.setString('JWT', response.data['jwt']);

      return Right(UserModel.fromMap(response.data['user']));
    } catch (e, stackTrace) {
      return Left(DataFailure(message: 'Failure $e', stackTrace: stackTrace));
    }
  }

  Future<Either<Failure, UserModel>> changePasswordUserDataRequest({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final SharedPreferences sharedPreferences = services.get<SharedPreferences>();
      final Response response = await client.post(
        'http://127.0.0.1:1337/api/auth/change-password',
        options: Options(headers: {'Authorization': 'Bearer ${sharedPreferences.getString('JWT')}'}),
        data: jsonEncode(
          <String, dynamic>{
            "currentPassword": currentPassword,
            "password": newPassword,
            "passwordConfirmation": newPasswordConfirmation,
          },
        ),
      );
      await sharedPreferences.remove('JWT');
      await sharedPreferences.setString('JWT', response.data['jwt']);

      return Right(UserModel.fromMap(response.data['user']));
    } catch (e, stackTrace) {
      return Left(DataFailure(message: 'Failure $e', stackTrace: stackTrace));
    }
  }
}
