import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:store_client/core/failure/failure.dart';
import 'package:store_client/core/services/services.dart';
import 'package:store_client/core/usecases/usecases.dart';
import 'package:store_client/src/domain/entities/message.dart';
import 'package:store_client/src/domain/repository/messenger_repository.dart';

class SendMessageUsecase extends UseCase<Unit, Message> {
  @override
  FutureOr<Either<Failure, Unit>> call(Message message) {
    final MessengerRepository messengerRepository = services.get<MessengerRepository>();

    return messengerRepository.sendMessage(message: message);
  }
}
