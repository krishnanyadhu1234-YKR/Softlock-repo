class Country {
  const Country({required this.name, required this.iso2, required this.dialCode, required this.flagEmoji});

  final String name;
  final String iso2;
  final String dialCode;
  final String flagEmoji;

  String get displayDial => '+$dialCode';
}
