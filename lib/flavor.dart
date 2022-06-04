enum Flavor {
  emulator,
  dev,
}

class F {
  static final flavor = _getFlavor();

  static Flavor _getFlavor() {
    const flavorString = String.fromEnvironment('FLAVOR');
    return Flavor.values.firstWhere(
      (value) => value.name == flavorString,
      orElse: () => Flavor.emulator,
    );
  }
}
