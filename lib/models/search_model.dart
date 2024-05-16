class SearchModel {
  final int id;
  final String title;
  final String image;


  SearchModel({
    required this.id,
    required this.title,
    required this.image,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
        );
  }
}
