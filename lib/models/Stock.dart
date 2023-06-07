class Stock {
  String id, name, person, tagLine, imgUri;
  Map<String, int> values;
  Map<String, String> news;

  Stock({
    required this.id,
    required this.name,
    required this.person,
    required this.news,
    required this.tagLine,
    required this.imgUri,
    required this.values,
  });

  factory Stock.fromMap(Map map) {
    Map<String, dynamic> valuesMapRaw = map["values"];
    Map<String, int> valuesMap =
        valuesMapRaw.map((k, v) => MapEntry(k, int.parse(v.toString())));

    Map<String, dynamic> newsMapRaw = map["news"];
    Map<String, String> newsMap =
        newsMapRaw.map((k, v) => MapEntry(k, v.toString()));
    return Stock(
      id: map["id"],
      name: map["name"],
      person: map["person"],
      tagLine: map["tagLine"],
      imgUri: map["imgUri"],
      values: valuesMap,
      news: newsMap,
    );
  }
}
