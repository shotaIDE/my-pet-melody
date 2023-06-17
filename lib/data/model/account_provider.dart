enum AccountProvider { twitter, facebook }

extension AccountProviderGenerator on AccountProvider {
  static AccountProvider? fromProviderId(String providerId) {
    switch (providerId) {
      case 'twitter.com':
        return AccountProvider.twitter;
      case 'facebook.com':
        return AccountProvider.facebook;
      default:
        return null;
    }
  }
}
