import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart';

void main() => runApp(
      InitialPage(),
    );

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocalAuthentication localAuthentication = LocalAuthentication();
  bool _isValid = false;
  Future<void> authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await localAuthentication.authenticateWithBiometrics(
        localizedReason: 'Scan your fingerprint to authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
      if (authenticated) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => WelcomePage(),
          ),
        );
        _isValid = true;
      } else {
        print("Failed");
        setState(() => _isValid = false);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: 500), () {
      authenticate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fingerprint Example'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.fingerprint,
                size: 80,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              child: Text('Provided Your Fingerprint Scan'),
            ),
          ),
          Flexible(
            flex: 1,
            child: _isValid
                ? SizedBox()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      color: Theme.of(context).errorColor,
                      onPressed: authenticate,
                      child: Text('Try Again'),
                      textTheme: ButtonTextTheme.primary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome Page'),
      ),
    );
  }
}
