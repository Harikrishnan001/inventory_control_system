import 'package:flutter/material.dart';
import '/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ICSColors.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: ICSFontSize.large,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsTile(
              title: 'Account Details',
              iconData: Icons.account_circle_outlined,
            ),
            SettingsTile(
              title: 'Category',
              iconData: Icons.folder_outlined,
            ),
            SettingsTile(
              title: 'Preferences',
              iconData: Icons.accessibility_new_outlined,
            ),
            SettingsTile(
              title: 'Privacy and Security',
              iconData: Icons.shield_outlined,
            ),
            SettingsTile(
              title: 'Reset Appdata',
              iconData: Icons.restart_alt,
            ),
            SettingsTile(
              title: 'Send Feedback',
              iconData: Icons.chat_bubble,
            ),
            SizedBox(height: 40),
            ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(StadiumBorder()),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 15.0,
                    ),
                    SizedBox(width: 3.0),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: ICSFontSize.medium,
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  const SettingsTile({
    Key? key,
    required this.title,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(iconData, size: 30),
          title: Text(title),
        ),
        Divider(
          thickness: 2,
          indent: 10,
          endIndent: 10,
        ),
      ],
    );
  }
}
