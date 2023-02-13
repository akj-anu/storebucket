class SearchData {
  String? title;
  String? code;
  String? description;
  String? name;
  String? id;

  SearchData({this.title, this.code, this.description, this.id, this.name});

  SearchData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    code = json['code'];
    description = json['description'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['code'] = code;
    data['description'] = description;
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
