import 'package:common_utils/common_utils.dart';

class MyPlayerUtils {
  static final supportedExtensionsVideo = <String>[
    ".3gp",
    ".avi",
    ".m4v",
    ".mkv",
    ".mov",
    ".mp4",
    ".ts",
    ".webm"
  ];

  static bool isSupportedInVideoPlayer(String uri) {
    if (TextUtil.isEmpty(uri)) return false;
    bool supported =
        supportedExtensionsVideo.any((element) => uri.contains(element));
    return supported;
  }
}
