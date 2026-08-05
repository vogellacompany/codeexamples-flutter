import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:web_app_prototype/data/user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;
  bool _isObscure = true;
  Color? _eyeColor;
  List _loginMethod = [
    {
      "title": "facebook",
      "icon": FontAwesomeIcons.facebook,
    },
    {
      "title": "google",
      "icon": FontAwesomeIcons.google,
    },
    {
      "title": "twitter",
      "icon": FontAwesomeIcons.twitter,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0), BlendMode.dstATop),
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                SizedBox(height: 70.0),
                buildEmailTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                buildForgetPasswordText(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
                buildOtherLoginText(),
                buildOtherMethod(context),
                buildRegisterText(context),
              ],
            )));
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('NO Account？'),
            GestureDetector(
              child: Text(
                'Click And Register',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                //TODO Go into Another page for registering
                print('go into register');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  ButtonBar buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _loginMethod
          .map((item) => Builder(
                builder: (context) {
                  return IconButton(
                      icon: FaIcon(item['icon'],
                          color: Theme.of(context).iconTheme.color),
                      onPressed: () {
                        //TODO : Oauth2.0 login methods
                        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: new Text("${item['title']}Login"),
                          action: new SnackBarAction(
                            label: "Cancell",
                            onPressed: () {},
                          ),
                        ));
                      });
                },
              ))
          .toList(),
    );
  }

  Align buildOtherLoginText() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          'Other',
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ));
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: const StadiumBorder(side: BorderSide()),
          ),
          onPressed: () {
            final messenger = ScaffoldMessenger.of(context);
            if (!mockUsers.containsKey(_email)) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Username does not exist')),
              );
              return;
            }
            if (mockUsers[_email] != _password) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Password does not match')),
              );
              return;
            }
            //TODO jump to the second page
          },
          child: Text(
            'Login',
            style: Theme.of(context).primaryTextTheme.headlineSmall,
          ),
        ),
      ),
    );
  }

  Padding buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          child: Text(
            'forgot password？',
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String? value) => _password = value,
      obscureText: _isObscure,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'please type in password';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Emall Address',
      ),
      validator: (String? value) {
        var emailReg = RegExp(
            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (value == null || value.isEmpty) {
          return 'please type in email';
        }
        if (!emailReg.hasMatch(value)) {
          return 'please give correct email format';
        }
        return null;
      },
      onSaved: (String? value) => _email = value,
    );
  }

  Align buildTitle() {
    return Align(
      alignment: Alignment.center,
        child: Image(image: AssetImage('assets/logo.png')),
    );
  }
}