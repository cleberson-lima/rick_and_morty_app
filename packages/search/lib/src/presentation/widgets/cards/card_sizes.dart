/// Card sizes for [ResponsiveResultsView] (tile height, max tile width).
abstract final class CardSizes {
  static const characterHeight = 300.0;
  static const characterMaxWidth = 220.0;
  static const episodeHeight = 96.0;
  // One column on phones (the "Name | S01E01" title needs the width).
  static const episodeMaxWidth = 420.0;
  static const locationHeight = 176.0;
  // Two columns on phones, so "Saiba mais" fits.
  static const locationMaxWidth = 190.0;
}
