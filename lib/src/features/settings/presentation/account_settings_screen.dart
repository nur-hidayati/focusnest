import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatefulWidget {
  final String userId;
  const AccountSettingsScreen({
    required this.userId,
    super.key,
  });

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
