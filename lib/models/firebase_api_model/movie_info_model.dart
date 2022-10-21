class MovieInfoModel {
  String title;
  int adjust;

  MovieInfoModel.fromParams({this.title, this.adjust});

  MovieInfoModel.fromJson(jsonRes) {
    if (jsonRes != null) {
      title = jsonRes['title'];
      adjust = jsonRes['adjust'] ?? 0;
    }
  }

  @override
  String toString() {
    return '{"type": $title,"url": $adjust}';
  }
}
