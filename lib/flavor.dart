enum Flavor {
  emulator,
  dev,
  prod,
}

final flavor = _getFlavor();

Flavor _getFlavor() {
  const flavorString = String.fromEnvironment('FLAVOR');
  return Flavor.values.firstWhere(
    (value) => value.name == flavorString,
    orElse: () => Flavor.emulator,
  );
}
