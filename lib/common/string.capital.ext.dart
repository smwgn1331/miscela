extension CapitalExt on String {
  String get capitalizeFirst =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get capitalize =>
      split(" ").map((str) => str.capitalizeFirst).join(" ");
}
