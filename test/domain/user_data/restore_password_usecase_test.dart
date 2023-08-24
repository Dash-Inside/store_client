import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:store_client/core/failure/failure.dart';
import 'package:store_client/core/services/services.dart';
import 'package:store_client/src/data/repositories/remote/user_data_server_repository.dart';
import 'package:store_client/src/domain/entities/role.dart';
import 'package:store_client/src/domain/entities/user.dart';
import 'package:store_client/src/domain/repository/user_data_repository.dart';
import 'package:store_client/src/domain/usecases/user_data/restore_password_usecase.dart';

import '../../injector/services.dart';

Future<void> main() async {
  await initTestServices();

  final User userData = User(
    id: 1,
    username: 'username',
    avatarUrl: 'avatarUrl',
    role: Role.user,
  );
  final String restoreCode = 'restoreCode';
  final String password = 'password';
  final String comfirmedPassword = 'comfirmedPassword';

  final RestorePasswordUseCaseParams restorePasswordUseCaseParams = RestorePasswordUseCaseParams(
    restoreCode: restoreCode,
    password: password,
    comfirmedPassword: comfirmedPassword,
  );

  test('restore_password_usecase_test', () async {
    // Act.
    final UserDataRepository userDataRepository = services.get<UserDataRepository>();
    when(userDataRepository.restorePasswordUser(
      restoreCode: restoreCode,
      password: password,
      comfirmedPassword: comfirmedPassword,
    )).thenAnswer((_) async {
      return Right(userData);
    });

    // Arrange.
    final RestorePasswordUseCase restorePasswordUseCase = RestorePasswordUseCase();
    final Either<Failure, UserData> result = await restorePasswordUseCase.call(restorePasswordUseCaseParams);

    // Accert.
    verify(userDataRepository.restorePasswordUser(
      restoreCode: restoreCode,
      password: password,
      comfirmedPassword: comfirmedPassword,
    )).called(1);
    verifyNoMoreInteractions(UserDataServerRepository);
    expect(result, Right(userData));
  });
}
