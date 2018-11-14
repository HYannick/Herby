import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:herby_app/components/gradientImageBackground.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() {
    return new AuthPageState();
  }
}

class AuthPageState extends State<AuthPage> {
  Map<String, String> loginForm = {'email': '', 'password': ''};
  Map<String, String> registerForm = {
    'username': '',
    'email': '',
    'password': '',
    'passwordConfirm': ''
  };

  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final Color mainGreen = Color.fromRGBO(140, 216, 207, 1.0);
  bool registerMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Stack(children: <Widget>[
        GradientImageBackground(
            imgURL: 'assets/auth_background@2x.png',
            color: Color.fromRGBO(51, 51, 51, 1.0),
            fadeColor: Color.fromRGBO(219, 237, 145, 0.30),
            gradientOpacity: 0.6),
        Container(
          constraints: BoxConstraints.expand(),
          child: ListView(children: <Widget>[
            _buildLogo(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(61, 50, 25, 0.4),
                        offset: Offset(10.0, 6.0),
                        spreadRadius: 6.0,
                        blurRadius: 10.0)
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(25.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(10.0))),
              child: !registerMode ? _buildLogin() : _buildRegister(),
            ),
            SizedBox(
              height: 30.0,
            ),
            _buildLoginButton(context),
          ]),
        )
      ]),
    ));
  }

  Column _buildLoginButton(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          !registerMode
              ? 'Don\'t have an account?'
              : 'Already have an account?',
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              registerMode = !registerMode;
            });
          },
          child: Text(!registerMode ? 'Register' : 'Login',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0)),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            width: 200.0,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  offset: Offset(0.0, 3.0),
                  spreadRadius: 6.0,
                  blurRadius: 10.0)
            ], color: mainGreen, borderRadius: BorderRadius.circular(50.0)),
            child: ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return FlatButton(
                    child: Text(!registerMode ? 'Login' : 'Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)),
                    onPressed: () => _submitForm(model.login));
              },
            )),
      ],
    );
  }

  Form _buildLogin() {
    return Form(
        key: _loginKey,
        child: Column(
          children: <Widget>[
            _buildTextFormField(TextInputType.emailAddress, 'email', 'Email',
                minChar: 2),
            Divider(),
            _buildTextFormField(TextInputType.text, 'password', 'Password',
                minChar: 2, hidden: true)
          ],
        ));
  }

  Form _buildRegister() {
    return Form(
        key: _registerKey,
        child: Column(
          children: <Widget>[
            _buildTextFormField(TextInputType.text, 'username', 'Username',
                minChar: 2, hidden: true),
            Divider(),
            _buildTextFormField(TextInputType.emailAddress, 'email', 'Email',
                minChar: 2),
            Divider(),
            _buildTextFormField(TextInputType.text, 'password', 'Password',
                minChar: 2, hidden: true, controller: _passwordController),
            Divider(),
            _buildTextFormField(
                TextInputType.text, 'password_confirm', 'Confirm Password',
                minChar: 2, hidden: true)
          ],
        ));
  }

  Container _buildLogo() {
    return Container(
        height: 300.0,
        child: Center(
            child: SvgPicture.asset(
          'assets/drop-logo--plain.svg',
          color: Colors.white,
        )));
  }

  Padding _buildTextFormField(
      TextInputType keyboardType, String field, String label,
      {int minChar, bool hidden = false, TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
          keyboardType: keyboardType,
          obscureText: hidden,
          controller: controller,
          maxLines: keyboardType == TextInputType.multiline ? 4 : 1,
          decoration: InputDecoration.collapsed(
              hintText: label, hintStyle: TextStyle(color: Colors.black38)),
          validator: (String value) {
            if (value.isEmpty || value.length <= minChar) {
              return '$label is required and should be $minChar+ characters long.';
            }
            if (field == 'password_confirm') {
              if (controller.text != value) {
                return 'Passwords doesn\'t match.';
              }
            }
          },
          onSaved: (String value) => loginForm[field] = value),
    );
  }

  _submitForm(Function login) {
    if (!registerMode) {
      if (!_loginKey.currentState.validate()) {
        return;
      }
      _loginKey.currentState.save();
      login(loginForm['email'], loginForm['password']);
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }
    if (!_registerKey.currentState.validate()) {
      return;
    }
    _registerKey.currentState.save();
//    register(registerForm['email'], registerForm['password'], registerForm['username']);
    Navigator.pushReplacementNamed(context, '/home');
  }
}
