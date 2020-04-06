import 'package:flutter/material.dart';
import 'loginRegisterPage.dart';
import 'HomePage.dart';
import 'authentication.dart';

class Mapping extends StatefulWidget {
  final AuthImplementation auth;

  Mapping
      ({
    this.auth
  });

  State<StatefulWidget> createState() {
    return MappingSate();
  }
}
  enum AuthStatus
  {
  notSignedIn,
  signedIn,
}


class MappingSate extends State<Mapping>
{
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  void initSate()
  {
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId)
    {
      setState(() {
        _authStatus = firebaseUserId == null ? AuthStatus.notSignedIn != null : AuthStatus.signedIn;});
    });
  }
  void _signedIn()
  {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signOut()
  {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    switch(_authStatus)
    {
      case AuthStatus.notSignedIn:
        return new loginRegisterPage(
          auth: widget.auth,
          onSignedIn: _signedIn
        );
      case AuthStatus.signedIn:
        return new HomePage(
            auth: widget.auth,
            onSignedOut: _signOut,
        );
        // TODO: Handle this case.
        break;
    }
  }
}


