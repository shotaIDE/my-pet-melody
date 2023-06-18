class AppDefinitions {
  static const twitterConsumerApiKey =
      String.fromEnvironment('TWITTER_CONSUMER_API_KEY');
  static const twitterConsumerSecret =
      String.fromEnvironment('TWITTER_CONSUMER_SECRET');
  static const appleSignInClientId =
      String.fromEnvironment('APPLE_SIGN_IN_CLIENT_ID');
  static const appleSignInRedirectUri =
      String.fromEnvironment('APPLE_SIGN_IN_REDIRECT_URI');
  static const revenueCatPublicAppleApiKey =
      String.fromEnvironment('REVENUE_CAT_PUBLIC_APPLE_API_KEY');
  static const revenueCatPublicGoogleApiKey =
      String.fromEnvironment('REVENUE_CAT_PUBLIC_GOOGLE_API_KEY');
  static const serverHost = String.fromEnvironment('SERVER_HOST');
  static const serverOrigin = String.fromEnvironment('SERVER_ORIGIN');

  static String get twitterRedirectUri {
    const redirectScheme = String.fromEnvironment('TWITTER_REDIRECT_SCHEME');
    return '$redirectScheme://auth/twitter';
  }
}
