import 'package:cineme/providers/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String username = '';
  String password = '';
  bool isLoadingAuth = false;

  Future<void> validateForm() async {
    setState(() {
      isLoadingAuth = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await Provider.of<Auth>(context, listen: false)
            .authinticate(email, password, _isLogin);
      } on FirebaseAuthException catch (e) {
        String err = e.code;
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          err = 'Incorrect username or password, Please try again.';
        } else if (e.code == 'email-already-in-use') {
          err = 'Email is already taken';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err),
        ));
      }
    }
    setState(() {
      isLoadingAuth = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 50,
            width: 350,
            child: TextFormField(
              onSaved: (value) {
                email = value!;
              },
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please provide a valid email';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(9),
                  child: Image.asset(
                    'assets/icons/email.png',
                    fit: BoxFit.contain,
                  ),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                label: const Text(
                  'Email',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          AnimatedContainer(
            curve: Curves.decelerate,
            duration: Duration(milliseconds: 300),
            height: !_isLogin ? 50 : 0,
            width: !_isLogin ? 350 : 0,
            child: TextFormField(
              enabled: !_isLogin,
              onSaved: (value) {
                username = value!;
              },
              validator: (value) {
                if (value!.isEmpty || value.length < 4) {
                  return 'Please provide a valid username';
                }
                return null;
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(9),
                  child: Image.asset(
                    'assets/icons/user.png',
                    fit: BoxFit.contain,
                  ),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                label: const Text(
                  'Username',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          if (!_isLogin)
            const SizedBox(
              height: 15,
            ),
          Container(
            height: 50,
            width: 350,
            child: TextFormField(
              onSaved: (value) {
                password = value!;
              },
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return 'Please provide a valid password';
                }
                return null;
              },
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(9),
                  child: Image.asset(
                    'assets/icons/password.png',
                    fit: BoxFit.contain,
                  ),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                label: const Text(
                  'Password',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          isLoadingAuth
              ? CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    elevation: 10,
                    primary: Theme.of(context).accentColor,
                  ),
                  onPressed: validateForm,
                  child: Container(
                    height: 60,
                    width: 240,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.all(14),
                          child: Image.asset(
                            'assets/icons/padlock.png',
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          _isLogin ? 'Secure Login' : 'Secure Signup',
                          style: TextStyle(fontSize: 17),
                        )
                      ],
                    ),
                  ),
                ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isLogin = !_isLogin;
              });
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: _isLogin
                          ? 'Don\'t have an account?'
                          : 'Have an account?',
                      style: TextStyle(color: Colors.white)),
                  TextSpan(
                    text: _isLogin ? ' Signup Now!' : ' Signin Now!',
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
