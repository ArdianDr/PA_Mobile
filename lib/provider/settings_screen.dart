import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/widgets/app_large_text.dart';


class ThemeModeData extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkModeActive => _themeMode == ThemeMode.dark;
  void changeTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


class _SettingsScreenState extends State<SettingsScreen> {
  late bool isDarkModeActive;
  @override
  void initState() {
    super.initState();
    isDarkModeActive = context.read<ThemeModeData>().isDarkModeActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLargeText(text: "Theme Settings"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(
              context.watch<ThemeModeData>().isDarkModeActive
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            title: const Text("Change Mode"),
            trailing: GestureDetector(
              onTap: () {
                setState(() {
                  isDarkModeActive = !isDarkModeActive;
                });
                Provider.of<ThemeModeData>(context, listen: false).changeTheme(
                  isDarkModeActive ? ThemeMode.dark : ThemeMode.light,
                );
              },
              child: Switch(
                value: isDarkModeActive,
                onChanged: (bool value) {
                  setState(() {
                    isDarkModeActive = value;
                  });
                  Provider.of<ThemeModeData>(context, listen: false)
                      .changeTheme(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}