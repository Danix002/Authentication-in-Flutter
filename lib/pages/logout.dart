import 'dart:collection';
import 'package:events_app/pages/login.dart';
import 'package:flutter/material.dart';

import '../controllers/data_controller.dart';
import '../services/oauth_service.dart';
import '../controllers/client_controller.dart';


class LogoutPage extends StatefulWidget {
  final bool isGoogleAuth;
  const LogoutPage({super.key, required this.isGoogleAuth});
  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  bool _isLoading = true;
  bool _isReloading = false;
  final HashMap<String, bool> _logoutStatus = HashMap.from({
    'Dis access OK': false,
    'Dis access KO': false
  });
  final OauthService _oauthService = OauthService();
  final ClientController _clientController = ClientController();
  String? _fullName;
  String? _email;

  Future<void> _logoutAuth(bool isGoogleAuth) async {
    setState(() {
      _isLoading = true;
    });

    final bool response;
    if(isGoogleAuth) {
      response = await _oauthService.googleLogout();
    }else{
      response = await _oauthService.emailLogout();
    }
    if (response) {
      setState(() {
        _fullName = null;
        _email = null;
        _logoutStatus['Dis access OK'] = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _logoutStatus['Dis access KO'] = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _reloadPage() async{
    setState(() {
      _isReloading = true;
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _logoutStatus['Dis access KO'] = false;
      _isLoading = false;
      _isReloading = false;
    });
  }

  Future<void> _getUserInfo(bool isGoogleAuth) async{
    if(!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }
    if(isGoogleAuth) {
      _fullName ??= await _clientController.userFullName;
      _email ??= await _clientController.userEmail;
    }else{

    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading && !_isReloading){
      _getUserInfo(widget.isGoogleAuth);
    }
    if (!_isLoading && _logoutStatus['Dis access OK']!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
    }
    final size = MediaQuery.of(context).size;
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
        ) : !_logoutStatus['Dis access KO']! ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('lib/assets/flag_authentication.png')
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 400,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 232, 232, 232),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Name: $_fullName',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Email: $_email',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                _logoutAuth(widget.isGoogleAuth);
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
                      'Logout',
                      style: TextStyle(fontSize: 20, color: Colors.white),
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
                'General Error With Logout',
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
