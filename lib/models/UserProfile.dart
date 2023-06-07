class UserProfile {
  String name, contact, userId;
  int amount;
  List<Company> company;

  UserProfile({
    required this.name,
    required this.contact,
    required this.userId,
    required this.amount,
    required this.company,
  });

  factory UserProfile.fromMap(Map map) {
    List<Company> temp = [];
    var tempMap = map["company"] as Map;
    temp = tempMap.values.map((e) => Company.fromMap(e)).toList();
    return UserProfile(
      name: map["name"],
      contact: map["contact"],
      userId: map["userId"],
      amount: map["amount"],
      company: temp,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> companyMap = {};
    for (var data in company) {
      companyMap[data.id] = data.toMap();
    }
    return {
      "name": name,
      "contact": contact,
      "userId": userId,
      "amount": amount,
      "company": companyMap,
    };
  }
}

class Company {
  String id;
  int stocks;

  Company({
    required this.id,
    required this.stocks,
  });

  factory Company.fromMap(Map map) {
    return Company(
      id: map["id"],
      stocks: map["stocks"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "stocks": stocks,
    };
  }
}
