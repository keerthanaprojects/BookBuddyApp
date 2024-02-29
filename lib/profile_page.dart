import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkMode;
  const ProfilePage({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "no username";
  String languagePreference = "English";
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _changeLanguagePreference(String newLanguage) {
    setState(() {
      languagePreference = newLanguage;
    });
  }

  void _logout() {
    print("logging out....");
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void _showLanguagePreferenceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Language Preference'),
          content: Column(
            children: [
              ListTile(
                title: Text('English'),
                onTap: () {
                  _changeLanguagePreference('English');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Spanish'),
                onTap: () {
                  _changeLanguagePreference('Spanish');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _loadUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString('username') ?? "NO USERNAME";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Page',
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.grey[900],
          ),
        ),
        backgroundColor: widget.isDarkMode ? Colors.grey[900] : null,
      ),
      body: Container(
        color: widget.isDarkMode
            ? Colors.grey[900]
            : Color.fromRGBO(225, 240, 218, 1),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 29, 209, 182),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Language Preference',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    languagePreference,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showLanguagePreferenceDialog();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Change Language Preference'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _logout();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
