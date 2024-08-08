class Event {
  String id;
  String title;
  String description;
  Owner owner;
  DateTime date;
  String address;
  Location location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.owner,
    required this.date,
    required this.address,
    required this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      title: json['title'],
      description: json['description'],
      owner: Owner.fromJson(json['owner']),
      date: DateTime.parse(json['date']),
      address: json['address'],
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'owner': owner.toJson(),
      'date': date.toIso8601String(),
      'address': address,
      'location': location.toJson(),
    };
  }
}

class Owner {
  String id;
  String name;
  String email;
  String address;

  Owner({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
    };
  }
}

class Location {
  String type;
  List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates:
          List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
