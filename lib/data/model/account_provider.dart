enum AccountProvider { google, twitter, facebook, apple }

extension AccountProviderGenerator on AccountProvider {
  static AccountProvider? fromProviderId(String providerId) {
    switch (providerId) {
      case 'google.com':
        return AccountProvider.google;
      case 'twitter.com':
        return AccountProvider.twitter;
      case 'facebook.com':
        return AccountProvider.facebook;
      case 'apple.com':
        return AccountProvider.apple;
      default:
        return null;
    }
  }
}
