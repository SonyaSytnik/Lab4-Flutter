import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/animation.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: 'Lab 4',
            theme: notifier.darkMode ? dark_mode : light_mode,
            home: MyStatefulWidget(),
            routes: {
              '/second': (context) => SecondScreen(),
            },
          );
        }));
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin {
  bool pressAttention = false;
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lab 4'),
        ),
        body: ListView(
          children: [
            Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => SwitchListTile(
                title: Text("Dark"),
                onChanged: (val) {
                  notifier.toggleChangeTheme();
                },
                value: notifier.darkMode,
              ),
            ),
            RaisedButton(
              child: Text('Screen 1'),
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: animation.value,
              width: animation.value,
              child: FlutterLogo(),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

ThemeData light_mode = ThemeData(
  brightness: Brightness.light,
);

ThemeData dark_mode = ThemeData(
  brightness: Brightness.dark,
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _preferences;
  bool _darkMode;

  bool get darkMode => _darkMode;

  ThemeNotifier() {
    _darkMode = true;
    _loadFromPreferences();
  }

  _initialPreferences() async {
    if (_preferences == null)
      _preferences = await SharedPreferences.getInstance();
  }

  _savePreferences() async {
    await _initialPreferences();
    _preferences.setBool(key, _darkMode);
  }

  _loadFromPreferences() async {
    await _initialPreferences();
    _darkMode = _preferences.getBool(key) ?? true;
    notifyListeners();
  }

  toggleChangeTheme() {
    _darkMode = !_darkMode;
    _savePreferences();
    notifyListeners();
  }
}

req() async {
  await http.get(Uri.https('jsonplaceholder.typicode.com', 'albums/1'));
  http.get(Uri.parse('google.com')).then((value) => value);
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Screen 2"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to the first screen by popping the current route
            // off the stack.
            Navigator.pop(context);
          },
          child: Text('Back'),
        ),
      ),
    );
  }
}
