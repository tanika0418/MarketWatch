class StockView {
  String id, name, person, tagLine, imgUri, currentNews;
  int stocks, worth, currentValue;
  bool isUp;
  Map<String, int> values;
  Map<String, String> news;

  StockView({
    required this.id,
    required this.name,
    required this.person,
    required this.tagLine,
    required this.imgUri,
    required this.currentNews,
    required this.stocks,
    required this.worth,
    required this.isUp,
    required this.currentValue,
    required this.values,
    required this.news,
  });
}
