import 'dart:convert';

class AddressModel {
  String? address;
  String? city;
  String? state;
  String? country;
  String? zipCode;

  AddressModel({
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      address: map['address'] != null ? map['address'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      zipCode: map['zipCode'] != null ? map['zipCode'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
