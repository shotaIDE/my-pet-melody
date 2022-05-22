enum Flavor {
  local,
  dev,
}

class F {
  static final flavor = _getFlavor();

  static Flavor _getFlavor() {
    const flavorString =
        String.fromEnvironment('FLAVOR', defaultValue: 'local');
    return Flavor.values.firstWhere(
      (value) => value.name == flavorString,
      orElse: () => Flavor.local,
    );
  }
}
