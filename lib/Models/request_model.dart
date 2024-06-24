class RequestModel {
  final String id; // Document ID in Firestore
  final String title;
  final String description;

  RequestModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map, String id) {
    return RequestModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }
}
