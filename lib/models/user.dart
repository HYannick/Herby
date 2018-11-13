import 'package:flutter/material.dart';

class User {
  final String id;
  final String username;
  final String avatarURL;
  final String email;
  final String password;

  User({
    @required this.id,
    this.username,
    this.avatarURL,
    @required this.email,
    @required this.password,
  });
}
