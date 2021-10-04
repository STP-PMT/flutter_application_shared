import 'package:flutter/material.dart';
import 'package:flutter_application_shared/models/user_model.dart';
import 'package:flutter_application_shared/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<UserModel>? userModel;
  var accEmail = TextEditingController();
  var accName = TextEditingController();
  var accSname = TextEditingController();

  String token = "";
  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<Null> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token")!;
    getdata();
  }

  Future<Null> getdata() async {
    final String url = "http://itoknode@itoknode.comsciproject.com/user/User";
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      setState(() {
        var responseString = response.body;
        userModel = userModelFromJson(responseString);
        accEmail.text = userModel![0].accEmail;
        accName.text = userModel![0].accName;
        accSname.text = userModel![0].accSname;
      });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: (userModel == null)
          ? Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  )
                ],
              ),
            )
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('${userModel![0].accName} ${userModel![0].accSname}'),
                  accountEmail: Text('${userModel![0].accEmail}'),
                  currentAccountPicture: CircleAvatar(),
                ),
                ListTile(
                  title: Text("Log out"),
                  leading: Icon(Icons.logout),
                  onTap: () async {
                    SharedPreferences preFerences = await SharedPreferences.getInstance();
                    preFerences.clear();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                )
              ],
            ),
    );
  }
}
