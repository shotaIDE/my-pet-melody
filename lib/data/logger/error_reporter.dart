import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final errorReporterProvider = Provider(
  (_) => ErrorReporter(),
);

class ErrorReporter {
  Future<void> send(
    dynamic error,
    StackTrace stack, {
    String? reason,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      reason: reason,
    );
  }
}
