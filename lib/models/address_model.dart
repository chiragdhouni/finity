// import 'dart:convert';

// // AddressModel
// class AddressModel {
//   String? address;
//   String? city;
//   String? state;
//   String? country;
//   String? zipCode;

//   AddressModel({
//     this.address,
//     this.city,
//     this.state,
//     this.country,
//     this.zipCode,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'address': address,
//       'city': city,
//       'state': state,
//       'country': country,
//       'zipCode': zipCode,
//     };
//   }

//   factory AddressModel.fromMap(Map<String, dynamic> map) {
//     return AddressModel(
//       address: map['address'] != null ? map['address'] as String : null,
//       city: map['city'] != null ? map['city'] as String : null,
//       state: map['state'] != null ? map['state'] as String : null,
//       country: map['country'] != null ? map['country'] as String : null,
//       zipCode: map['zipCode'] != null ? map['zipCode'] as String : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'address': address,
//       'city': city,
//       'state': state,
//       'country': country,
//       'zipCode': zipCode,
//     };
//   }

//   factory AddressModel.fromJson(String source) =>
//       AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }

import 'dart:convert';

// AddressModel
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

  // Converts the object to a Map
  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
    };
  }

  // Creates an instance of AddressModel from a Map
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      address: map['address'] as String?,
      city: map['city'] as String?,
      state: map['state'] as String?,
      country: map['country'] as String?,
      zipCode: map['zipCode'] as String?,
    );
  }

  // Converts the object to JSON
  Map<String, dynamic> toJson() {
    return toMap(); // Reusing the `toMap` method for this
  }

  // Creates an instance of AddressModel from a JSON object (Map) directly
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel.fromMap(
        json); // Directly call fromMap with the JSON map
  }
}
