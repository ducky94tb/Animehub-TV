import 'fembed.dart';
import 'jetload.dart';
import 'vidcloud.dart';

class StreamLinkConvertFactory {
  StreamLinkConvertFactory._();
  static final StreamLinkConvertFactory instance = StreamLinkConvertFactory._();
  List<String> hosts = [
    'archive',
    'bitporno',
    'clipwatching',
    'cloudvideo',
    'dood',
    'feurl',
    'fembed',
    'gamovideo',
    'gounlimited',
    'jawcloud',
    'jetload',
    'mediafire',
    'mixdrop',
    'mp4upload',
    "ninjastream",
    'openlay',
    'powvideo',
    'prostream',
    'streamplay',
    'streamtape',
    'supervideo',
    'upstream',
    'uptostream',
    'uqload',
    'veoh',
    'vidcloud',
    'videobin',
    'videomega',
    'vidfast',
    'vidia',
    'vidlox',
    'vidoza',
    'vidtodo',
    'vup',
    'waaw'
  ];
  Future<String> getLink(String link) async {
    final String _domain = _getDomain(link);
    String _link;
    switch (_domain) {
      case 'archive':
        break;
      case 'bitporno':
        break;
      case 'clipwatching':
        break;
      case 'cloudvideo':
        break;
      case 'dood':
        break;
      case 'feurl':
      case 'fembed':
        _link = await Fembed.getUrl(link);
        break;
      case 'gamovideo':
        break;
      case 'gounlimited':
        break;
      case 'jawcloud':
        break;
      case 'jetload':
        _link = await Jetload.getUrl(link);
        break;
      case 'mixdrop':
        break;
      case 'mp4upload':
        break;
      case 'ninjastream':
        break;
      case 'openlay':
        break;
      case 'prostream':
        break;
      case 'powvideo':
        break;
      case 'streamplay':
        break;
      case 'streamtape':
        break;
      case 'supervideo':
        break;
      case 'upstream':
        break;
      case 'uptostream':
        break;
      case 'uqload':
        break;
      case 'veoh':
        break;
      case 'vidcloud':
        _link = await Vidcloud.getUrl(link);
        break;
      case 'videobin':
        break;
      case 'videomega':
        break;
      case 'vidfast':
        break;
      case 'vidia':
        break;
      case 'vidlox':
        break;
      case 'vidoza':
        break;
      case 'vidtodo':
        break;
      case 'vup':
        break;
      case 'waaw':
        break;
    }
    return _link;
  }

  String _getDomain(String link) {
    for (var e in hosts) if (link.contains(e)) return e;
    return '';
  }
}
