import 'package:flutter/material.dart';
import 'PhotoUpload.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({

    this.auth,

    this.onSignedOut
  });
  @override
  _HomePageState createState() => _HomePageState();
  final AuthImplementation auth ;
  final VoidCallback onSignedOut ;

}

class _HomePageState extends State<HomePage> {

  List<Posts> postslist = [];

  void initState()
  {
    super.initState();
    DatabaseReference postsref = FirebaseDatabase.instance.reference().child("Posts");

    postsref.once().then((DataSnapshot snap)
    {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      postslist.clear();
      for(var individualKey in KEYS)
        {
          Posts posts = new Posts(
            DATA[individualKey]['image'],
            DATA[individualKey]['description'],
            DATA[individualKey]['date'],
            DATA[individualKey]['time'],
          );
          postslist.add(posts);
        }
      setState(()
      {
        print('Lenght : $postslist.length');
      }
      );
    });
  }

  void _logoutUser() async{
    try
        {
          await widget.auth.SignOut();
          widget.onSignedOut();
        }
        catch(e)
    {
      print("Error = "+ e.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),

      body: new Container(
        child: postslist.length == 0 ? new Text("No blog post available") : new ListView.builder(
          itemCount: postslist.length,
          itemBuilder: (_,index)
          {
            return PostsUI(postslist[index].image,postslist[index].description,postslist[index].date,postslist[index].time);
          }
        ),
      ),

      bottomNavigationBar: new BottomAppBar(
        color: Colors.purple,
        child: new Container(
          margin: const EdgeInsets.only(left: 70.0,right: 70.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,

            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.local_car_wash),
                iconSize: 50,
                color: Colors.white,

                onPressed: _logoutUser,
              ),
              new IconButton(
                icon: new Icon(Icons.camera_alt),
                iconSize: 40,
                color: Colors.white,

                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>UploadPhotoPage()),
                  );
                },
              ),


            ],

          ),
        ),
      ),
    );
  }
  Widget PostsUI(String image ,String description,String date,String time)
  {
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: new EdgeInsets.all(14.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            new Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            new Text (
              date,
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
            new Text (

              time,
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.center,
            ),
              ],
            ),
            SizedBox(height: 10.0,),
            new Image.network(image, fit:BoxFit.cover),
            SizedBox(height: 10.0,),
            new Text (
              description,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
    );
  }
}
