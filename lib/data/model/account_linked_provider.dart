enum AccountLinkedProvider { twitter }

extension AccountLinkedProviderGenerator on AccountLinkedProvider {
  static AccountLinkedProvider? fromProviderId(String providerId) {
    switch (providerId) {
      case 'twitter.com':
        return AccountLinkedProvider.twitter;
      default:
        return null;
    }
  }
}
