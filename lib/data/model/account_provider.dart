enum AccountProvider { google, apple }

extension AccountProviderGenerator on AccountProvider {
  static AccountProvider? fromProviderId(String providerId) {
    switch (providerId) {
      case 'google.com':
        return AccountProvider.google;
      case 'apple.com':
        return AccountProvider.apple;
      default:
        return null;
    }
  }
}
