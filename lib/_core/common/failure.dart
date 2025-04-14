import 'package:e_com/main.export.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

Either<Failure, R> failure<R>(String msg, [Object? e, StackTrace? s]) =>
    Left(Failure(msg, error: e, stackTrace: s ?? StackTrace.current));

class Failure {
  const Failure(
    this.message, {
    this.error,
    StackTrace? stackTrace,
  }) : _stackTrace = stackTrace;

  final String message;
  final Object? error;
  final StackTrace? _stackTrace;

  StackTrace get stackTrace => _stackTrace ?? StackTrace.current;

  Failure copyWith({
    String? message,
    String? error,
    StackTrace? stackTrace,
  }) {
    return Failure(
      message ?? this.message,
      stackTrace: stackTrace ?? this.stackTrace,
      error: error ?? this.error,
    );
  }

  Future<T> toFError<T>() {
    final future = Future<T>.error(message, stackTrace);

    return future;
  }

  AsyncError<T> toAsyncError<T>() {
    final error = AsyncError<T>(message, stackTrace);

    return error;
  }

  @override
  String toString() {
    if (kDebugMode) return '$message\n$error';

    return message;
  }

  void log() {
    talk.ex(error ?? message, stackTrace, message);
  }
}
