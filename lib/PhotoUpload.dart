import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'HomePage.dart';

class UploadPhotoPage extends StatefulWidget
{
  State<StatefulWidget> createSate()
  {
    return _UploadPhoto();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }}

class _UploadPhoto extends State<StatefulWidget>{
  File sampleImage;
  String _myValue , url;
  final Formkey = new GlobalKey<FormState>();


  Future getImage() async
  {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }
  bool validateAndSave()
  {
    final form = Formkey.currentState;
    if(form.validate())
      {
        form.save();
        return true ;
      }
    else
      {
        return false;
      }
  }
  void uploadStatusImage ()async
  {
      if(validateAndSave())
        {
          final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post images");
          var timeKey = new DateTime.now();
          final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString()).putFile(sampleImage);
          var Imageurl = await (await uploadTask.onComplete).ref.getDownloadURL();
          url = Imageurl.toString();
          print("Image Url =" + url);
          saveToDatabase(url);
          goToHomePage();
        }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Upload Image"),
          centerTitle: true,
        ),
      body: new Center(
        child: sampleImage == null? Text("Select an image"): enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add image',
        child: new Icon(Icons.add_a_photo)
      ),
    );
  }
  Widget enableUpload()
  {
    return new Container(
      child: new Form(
        key: Formkey,
      child: Column(
        children: <Widget>[
          Image.file(sampleImage, height: 330.0,width: 660.0,),
          SizedBox(height: 15.0,),
          TextFormField
        (
            decoration: new InputDecoration(labelText: 'Description'),
            validator: (value){
              return value.isEmpty ? 'Description is required ' : null;
        },
            onSaved: (value)
  {
     return _myValue = value ;
  },
          ),
          SizedBox(height: 150.0,),
          RaisedButton
            (
            elevation: 10.0,
            child: Text("Add a new post"),
            textColor: Colors.white,
            color: Colors.purple,
          onPressed: uploadStatusImage,
          )
        ],
      ),
  ),
    );
  }

  void saveToDatabase(String url) {
    var dbtimeKey = new DateTime.now();
    var formatdate = new DateFormat('MMM d, yyyy');
    var formattime = new DateFormat('EEEE, hh:mm aaa');
    String date = formatdate.format(dbtimeKey);
    String time = formattime.format(dbtimeKey);
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data =
        {
          "image":url,
          "description":_myValue,
          "date": date,
          "time":time
        };
    ref.child("Posts").push().set(data);
  }

  void goToHomePage() {
    Navigator.push(context,MaterialPageRoute(builder: (context)
    {
      return new HomePage();
    })
    );
  }
}