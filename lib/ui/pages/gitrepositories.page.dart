import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class GitRepositoiresPage extends StatefulWidget {
  String login;
  String avatarUrl;
  GitRepositoiresPage({required this.login, required this.avatarUrl});

  @override
  State<GitRepositoiresPage> createState() => _GitRepositoiresPageState();
}

class _GitRepositoiresPageState extends State<GitRepositoiresPage> {
  dynamic dataRepositories;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //EasyLoading.show(status: "Veuillez patientez...");
    loadRepositories();
  }

  void loadRepositories() async {
    EasyLoading.show(status: "Chargement...");
    var url = Uri.parse("https://api.github.com/users/${widget.login}/repos");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        EasyLoading.dismiss();
        dataRepositories = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositories ${widget.login}'),
        actions: [
          CircleAvatar(backgroundImage: NetworkImage(widget.avatarUrl),)
        ],
      ),
      body: Center(
          child: ListView.separated(
              itemBuilder: (context, index) => ListTile(
                title: Text('${dataRepositories[index]['name']}'),
              ),
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 1,
                color: Colors.blue,
              ),
              itemCount: dataRepositories == null ? 0 : dataRepositories.length)),
    );
  }
}
