import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'logout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final HashMap<String, bool> _loginStatus = HashMap.from({
    'Access OK': false,
    'Access KO': false
  });

  Future<void> _loginGoogle() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: oauth authentication here
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _loginStatus['Access OK'] = true;
    });
  }

  Future<void> _reloadPage() async{
    setState(() {
      _isLoading = false;
      _loginStatus['Access KO'] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int errorCode = 0;
    if (!_isLoading && _loginStatus['Access OK']!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LogoutPage()),
        );
      }); // TODO: add error code
    } else if(!_isLoading && _loginStatus['Access KO']!){ /*errorCode = 404;*/ }
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4196E3),
              Color(0xFF373598),
            ],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            stops: [0, 0.8],
          ),
        ),
        child: _isLoading ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'Processing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
        ) : !_loginStatus['Access KO']! ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(
                  size: 150,
                ),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () async {
                    _loginGoogle();
                  },
                  child: Container(
                    height: 50,
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.google,
                          size: 30,
                          color: Colors.red[700],
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        const Text(
                          'Login With Google',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('lib/assets/error_authentication.png')
            ),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'Error ${errorCode.toString()} With Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _reloadPage();
              },
              child: Container(
                height: 50,
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Retry',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              )
            )
          ]
        ),
      ),
    );
  }
}
