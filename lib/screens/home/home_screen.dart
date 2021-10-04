import 'package:flutter/material.dart';
import 'package:flutter_application_shared/models/user_model.dart';
import 'package:flutter_application_shared/screens/home/drawer_widget.dart';
import 'package:flutter_application_shared/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<UserModel> userModel;
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
      });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter with Shared Preferences"),
      ),
      body: Container(),
      drawer: NavBar(),
    );
  }
}
