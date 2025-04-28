import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/account_provider.dart';

final Provider<EventReporter> eventReporterProvider = Provider(
  (_) => EventReporter(),
);

class EventReporter {
  Future<void> signUp(AccountProvider provider) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'sign_up',
      parameters: {
        'method': provider.getFirebaseAnalyticsValue(),
      },
    );
  }

  Future<void> continueWithoutLogin() async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'continue_without_login',
    );
  }

  Future<void> startToConvertMovieForDetection() async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'start_to_convert_movie_for_detection',
    );
  }

  Future<void> startToDetect() async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'start_to_detect',
    );
  }

  Future<void> videoFinished() async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'video_finished',
    );
  }
}

extension _AnalyticsValue on AccountProvider {
  String getFirebaseAnalyticsValue() {
    return name;
  }
}
