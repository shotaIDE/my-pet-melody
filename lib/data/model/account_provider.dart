enum AccountProvider { twitter }

extension AccountProviderGenerator on AccountProvider {
  static AccountProvider? fromProviderId(String providerId) {
    switch (providerId) {
      case 'twitter.com':
        return AccountProvider.twitter;
      default:
        return null;
    }
  }
}
