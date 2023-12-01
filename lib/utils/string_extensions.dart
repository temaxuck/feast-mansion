extension StringExtension on String {
  String capitalize() {
    String targetString = this;
    List<String> stringSeparatedBySpace = targetString.toLowerCase().split(" ");
    List<String> capitalizedWord = [];

    for (var word in stringSeparatedBySpace) {
      word.isEmpty ? "" : capitalizedWord.add("${word[0].toUpperCase()}${word.substring(1)}");
    }

    return capitalizedWord.join(" ");
  }

  String toSentenceCase() {
    String targetString = this;

    if (targetString.isNotEmpty) {
      return '${targetString[0].toUpperCase()}${targetString.substring(1)}';
    }

    return '';
  }
}