import 'package:flutter/material.dart';
import 'Dialogbox.dart';
import 'authentication.dart';

class loginRegisterPage extends StatefulWidget {
  loginRegisterPage({

 this.auth, this.onSignedIn});
  @override
  _loginRegisterPageState createState() => _loginRegisterPageState();
  final AuthImplementation auth ;
  final VoidCallback onSignedIn ;

}


enum FormType{
  login,
  register,
}

class _loginRegisterPageState extends State<loginRegisterPage> {
  Dialogbox dialogbox = new Dialogbox();

  final formKey = new GlobalKey<FormState>();
  FormType _formTYpe = FormType.login;
  String _email = "";
  String _password="";

  //methods
  bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }
  void validateAndSubmit() async
  {
    if(validateAndSave())
      {
        try
            {
              if(_formTYpe == FormType.login)
                {
                  String userId = await widget.auth.SignIn(_email, _password);

                  dialogbox.information(context, "Congratulations", "you have logged in succesfully ");

                  print("Login userId =" + userId);
                }

            else
            {
              dialogbox.information(context, "Congratulations", "you have succesfully created your account");
              String userId = await widget.auth.SignUp(_email, _password);
              print("Register userId =" + userId);
            }
            widget.onSignedIn();
            }
            catch(e)
    {
        dialogbox.information(context, "Error", e.toString());
        print("Error = "+ e.toString());
    }
      }
  }
  void moveToRegister(){
    formKey.currentState.reset();

    setState(() {
      _formTYpe = FormType.register;
    });
  }

  void moveToLogin(){
    formKey.currentState.reset();

    setState(() {
      _formTYpe = FormType.login;
    });
  }



  //Design
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Blog App'),
      ),
      body: new Container(
        margin: EdgeInsets.all(15.0),
        child: new Form(

          key: formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + createButtons(),
            ),
        ),
      ),
    );
  }

  List<Widget>createInputs()
  {
    return[
      SizedBox(height: 10.0,),
      logo(),
      SizedBox(height: 20.0,),

      new TextFormField(
        decoration: new InputDecoration(labelText:'Email'),

        validator: (value){
          return value.isEmpty ?'Email is required.':null;
        },

        onSaved: (value){
          return _email = value;
        },

      ),

      SizedBox(height: 20.0,),

      new TextFormField(
        decoration: new InputDecoration(labelText:'Password'),

        obscureText: true,

        validator: (value){
          return value.isEmpty ?'Password is required.':null;
        },

        onSaved: (value){
          return _password = value;
        },

      ),

      SizedBox(height: 20.0,),

    ];
  }

  Widget logo(){
    return new Hero(
        tag: 'hero',
        child: new CircleAvatar(
          backgroundColor: Colors.transparent,
          radius:110.0,
          child: Image.asset('images/logo.png')
        )
    );
  }

  List<Widget>createButtons()
  {
      if (_formTYpe == FormType.login)
        {
          return[
            new RaisedButton(
              onPressed: validateAndSubmit,
              child: new Text('Login',
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
              textColor: Colors.white,
              color: Colors.purple,
            ),
            new FlatButton(
              onPressed: moveToRegister,
              child: new Text('Not have an Account? Create Account?',
                style: new TextStyle(
                  fontSize: 10.0,
                ),
              ),
              textColor: Colors.red,

            ),

          ];
        }

      else{
        return[
          new RaisedButton(
            onPressed: validateAndSubmit,
            child: new Text('Create Account',
              style: new TextStyle(
                fontSize: 20.0,
              ),
            ),
            textColor: Colors.white,
            color: Colors.purple,
          ),
          new FlatButton(
            onPressed: moveToLogin,
            child: new Text('Alredy have an Account? Login',
              style: new TextStyle(
                fontSize: 20.0,
              ),
            ),
            textColor: Colors.red,

          ),

        ];
      }

  }

}

