class StreamLink {
  String type;
  String url;

  StreamLink.fromParams({this.type, this.url});

  StreamLink.fromJson(jsonRes) {
    if (jsonRes != null) {
      type = jsonRes['type'];
      url = jsonRes['url'];
    }
  }

  @override
  String toString() {
    return '{"type": $type,"url": $url}';
  }
}
