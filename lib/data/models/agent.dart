class Agent {
  const Agent({
    required this.id,
    required this.name,
    required this.photo,
    required this.phone,
    required this.email,
    required this.rating,
  });

  final String id;
  final String name;
  final String photo;
  final String phone;
  final String email;
  final double rating;

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] as String,
      name: json['name'] as String,
      photo: json['photo'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'photo': photo,
        'phone': phone,
        'email': email,
        'rating': rating,
      };
}
