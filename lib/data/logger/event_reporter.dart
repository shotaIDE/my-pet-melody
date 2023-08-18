import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pet_melody/data/model/account_provider.dart';

final eventReporterProvider = Provider(
  (_) => EventReporter(),
);

class EventReporter {
  Future<void> sendSignUp(AccountProvider provider) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'sign_up',
      parameters: {
        'method': provider.getFirebaseAnalyticsValue(),
      },
    );
  }

  Future<void> sendContinueWithoutLogin() async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'continue_without_login',
    );
  }
}

extension _AnalyticsValue on AccountProvider {
  String getFirebaseAnalyticsValue() {
    return name;
  }
}
