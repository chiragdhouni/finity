class IndianCity {
  int cityid;
  String cityname;

  IndianCity({required this.cityid, required this.cityname});

  factory IndianCity.fromJson(Map<String, dynamic> json) {
    return IndianCity(
      cityid: json['cityid'],
      cityname: json['cityname'],
    );
  }

  // from map
  factory IndianCity.fromMap(Map<String, dynamic> map) {
    return IndianCity(
      cityid: map['cityid'],
      cityname: map['cityname'],
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      'cityid': cityid,
      'cityname': cityname,
    };
  }
}
