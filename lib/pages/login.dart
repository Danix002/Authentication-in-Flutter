import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/data_controller.dart';
import '../services/oauth_service.dart';
import 'logout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isGoogleAuth = false;
  final HashMap<String, bool> _loginStatus = HashMap.from({
    'Access OK': false,
    'Access KO': false
  });
  final OauthService _oauthService = OauthService();
  final DataController _fileController = DataController();

  Future<void> _loginAuthGoogle() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _oauthService.googleSignIn();

    if(response != null) {
      _isGoogleAuth = true;
      final data = await _fileController.readJsonFile();
      print('Session: ${data['session']}');
      print('User: ${data['user']}');
      setState(() {
        _loginStatus['Access OK'] = true;
        _isLoading = false;
      });
    }else{
      setState(() {
        _loginStatus['Access KO'] = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _loginAuthEmail() async{
    setState(() {
      _isLoading = true;
    });
    final response = await _oauthService.emailLogin();

    if(response != null) {
      _isGoogleAuth = false;
      final data = await _fileController.readJsonFile();
      print('User Metadata: ${data['user-meta']}');
      setState(() {
        _loginStatus['Access OK'] = true;
        _isLoading = false;
      });
    }else{
      setState(() {
        _loginStatus['Access KO'] = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _reloadPage() async{
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      if(_loginStatus['Access KO']!) {
        _loginStatus['Access KO'] = false;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && _loginStatus['Access OK']!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LogoutPage(isGoogleAuth: _isGoogleAuth)),
        );
      });
    }
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
                    _loginAuthGoogle();
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
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: GestureDetector(
                    onTap: () async {
                      _loginAuthEmail();
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
                            FontAwesomeIcons.a,
                            size: 30,
                            color: Colors.red[700],
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          const Text(
                            'Login With Email',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
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
                'General Error With Login',
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
