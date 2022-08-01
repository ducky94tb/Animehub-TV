import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movie/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'actions/api/tmdb_api.dart';
import 'actions/app_config.dart';
import 'actions/timeline.dart';
import 'generated/i18n.dart';
import 'models/item.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();

  static _AppState of(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>();
}

class _AppState extends State<App> {
  final i18n = I18n.delegate;

  final AbstractRoutes routes = Routes.routes;
  final ThemeData _lightTheme =
      ThemeData.light().copyWith(accentColor: Colors.transparent);
  final ThemeData _darkTheme =
      ThemeData.dark().copyWith(accentColor: Colors.transparent);
  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitializing = true;

  Future _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _darkMode = prefs.getString('darkMode');
    if (_darkMode != null) {
      final darkMode = Item(_darkMode);
      if (darkMode.name == 'Dark') {
        changeTheme(ThemeMode.dark);
      } else if (darkMode.name == 'Light') {
        changeTheme(ThemeMode.light);
      }
    }
    setLocaleInfo('zh', TimelineInfoCN());
    setLocaleInfo('en', TimelineInfoEN());
    setLocaleInfo('Ja', TimelineInfoJA());

    await AppConfig.instance.init(context);

    await TMDBApi.instance.init();
    setState(() {
      _isInitializing = false;
    });
  }

  @override
  void initState() {
    I18n.onLocaleChanged = onLocaleChange;

    _init();
    super.initState();
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      I18n.locale = locale;
    });
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  ThemeMode getTheme() {
    return _themeMode;
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage("images/blue.png"),
          )),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircularProgressIndicator(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Text("Powered by themoviedb",
                      textDirection: TextDirection.ltr),
                )
              ],
            ),
          ));
    }
    return MaterialApp(
      title: 'Movie',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _themeMode,
      localizationsDelegates: [
        I18n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: I18n.delegate.supportedLocales,
      localeResolutionCallback:
          I18n.delegate.resolution(fallback: new Locale("en", "US")),
      home: routes.buildPage('startpage', null),
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute<Object>(builder: (BuildContext context) {
          return routes.buildPage(settings.name, settings.arguments);
        });
      },
    );
  }
}
