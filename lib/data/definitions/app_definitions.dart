const twitterConsumerApiKey =
    String.fromEnvironment('TWITTER_CONSUMER_API_KEY');
const twitterConsumerSecret = String.fromEnvironment('TWITTER_CONSUMER_SECRET');
const revenueCatPublicAppleApiKey =
    String.fromEnvironment('REVENUE_CAT_PUBLIC_APPLE_API_KEY');
const revenueCatPublicGoogleApiKey =
    String.fromEnvironment('REVENUE_CAT_PUBLIC_GOOGLE_API_KEY');
const serverHost = String.fromEnvironment('SERVER_HOST');
const serverOrigin = String.fromEnvironment('SERVER_ORIGIN');

const appStoreId = '6450181110';

const maxPiecesOnFreePlan = 5;
const maxPiecesOnPremiumPlan = 30;

String get twitterRedirectUri {
  const redirectScheme = String.fromEnvironment('TWITTER_REDIRECT_SCHEME');
  return '$redirectScheme://auth/twitter';
}
