import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_engineer/screens/theme_settings_screen.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String? _selectedDirectory;
  final _supabaseClient = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadSelectedDirectory();
  }

  Future<void> _loadSelectedDirectory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDirectory = prefs.getString('selected_directory');
    });
  }

  Future<void> _selectDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_directory', selectedDirectory);
      setState(() {
        _selectedDirectory = selectedDirectory;
      });
    }
  }

  void _changeLanguage(Locale locale) {
    context.setLocale(locale);
    Navigator.of(context).pop(true);
  }

  Future<void> _deleteAccount() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('settingsScreen.deleteAccountTitle'.tr(),
              style: TextStyle(color: themeProvider.textColor)),
          content: Text('settingsScreen.deleteAccountWarning'.tr(),
              style: TextStyle(color: themeProvider.textColor)),
          backgroundColor: themeProvider.backgroundColor,
          actions: [
            TextButton(
              child: Text('settingsScreen.cancel'.tr(),
                  style: TextStyle(color: themeProvider.accentColor)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('settingsScreen.ok'.tr(),
                  style: TextStyle(color: themeProvider.accentColor)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final confirmedAgain = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('settingsScreen.deleteAccountConfirmTitle'.tr(),
                style: TextStyle(color: themeProvider.textColor)),
            content: Text('settingsScreen.deleteAccountConfirmContent'.tr(),
                style: TextStyle(color: themeProvider.textColor)),
            backgroundColor: themeProvider.backgroundColor,
            actions: [
              TextButton(
                child: Text('settingsScreen.no'.tr(),
                    style: TextStyle(color: themeProvider.accentColor)),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('settingsScreen.yes'.tr(),
                    style: TextStyle(color: themeProvider.accentColor)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      if (confirmedAgain == true) {
        try {
          final userId = _supabaseClient.auth.currentUser!.id;

          await _supabaseClient.from('notes').delete().eq('user_id', userId);

          await _supabaseClient.auth.admin.deleteUser(userId);

          await _supabaseClient.auth.signOut();
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('settingsScreen.deleteAccountError'.tr())),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        title: Text('settingsScreen.title'.tr(),
            style: TextStyle(color: themeProvider.textColor)),
        backgroundColor: themeProvider.accentColor,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('settingsScreen.accountSettings'.tr(),
                style: TextStyle(color: themeProvider.textColor)),
          ),
          ListTile(
            title: Text('settingsScreen.changePassword'.tr(),
                style: TextStyle(color: themeProvider.textColor)),
            trailing: Icon(Icons.lock, color: themeProvider.accentColor),
            onTap: () {
              Navigator.pushNamed(context, '/reset_password');
            },
          ),
          ListTile(
            title: Text('settingsScreen.logout'.tr(),
                style: TextStyle(color: themeProvider.textColor)),
            trailing: Icon(Icons.logout, color: themeProvider.accentColor),
            onTap: () {
              Supabase.instance.client.auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          ListTile(
            title: Text('settingsScreen.deleteAccount'.tr(),
                style: TextStyle(color: themeProvider.textColor)),
            trailing: Icon(Icons.logout, color: themeProvider.accentColor),
            onTap: _deleteAccount,
          ),
          const Divider(),
          ListTile(
            title: Text('settingsScreen.trash'.tr(),
                style: TextStyle(color: themeProvider.textColor)),
          ),
          ListTile(
            title: Text('settingsScreen.deletedNotes'.tr(),
                style: TextStyle(color: themeProvider.textColor)),
            trailing: Icon(Icons.restore_from_trash,
                color: themeProvider.accentColor),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/deleted_notes');
            },
          ),
          if (!kIsWeb) ...[
            const Divider(),
            ListTile(
              title: Text('settingsScreen.fileSaveLocation'.tr(),
                  style: TextStyle(color: themeProvider.textColor)),
            ),
            ListTile(
              title: Text(
                _selectedDirectory != null
                    ? _selectedDirectory!
                    : 'settingsScreen.notSelected'.tr(),
                style: TextStyle(color: themeProvider.textColor),
              ),
              trailing: Icon(Icons.folder, color: themeProvider.accentColor),
              onTap: _selectDirectory,
            ),
          ],
          const Divider(),
          ListTile(
            title: Text('settingsScreen.themeSettings'.tr(),
                style: TextStyle(color: themeProvider.textColor)),
          ),
          ListTile(
            title: Text('settingsScreen.selectTheme'.tr(),
                style: TextStyle(color: themeProvider.textColor)),
            trailing: Icon(Icons.color_lens, color: themeProvider.accentColor),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ThemeSettingsScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: Text('settingsScreen.language'.tr(),
                style: TextStyle(color: themeProvider.textColor)),
          ),
          ListTile(
            title: Text('settingsScreen.selectLanguage'.tr(),
                style: TextStyle(color: themeProvider.textColor)),
            trailing: Icon(Icons.language, color: themeProvider.accentColor),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('selectLanguage'.tr()),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Türkçe'),
                          onTap: () {
                            _changeLanguage(Locale('tr', 'TR'));
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('English'),
                          onTap: () {
                            _changeLanguage(Locale('en', 'US'));
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
