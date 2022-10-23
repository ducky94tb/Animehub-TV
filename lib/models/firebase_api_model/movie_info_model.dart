class MovieInfoModel {
  String title;
  int adjust;

  MovieInfoModel.fromParams({this.title, this.adjust});

  int getIntValue(final s) {
    if (s is int) return s;
    return int.tryParse(s) ?? 0;
  }

  MovieInfoModel.fromJson(jsonRes) {
    if (jsonRes != null) {
      title = jsonRes['title'];
      adjust = getIntValue(jsonRes['adjustNo'] ?? 0);
    }
  }

  @override
  String toString() {
    return '{"title": $title,"adjustNo": $adjust}';
  }
}
