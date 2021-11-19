import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_mobile_app/ui/pages/gitrepositories.page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String query = '';
  TextEditingController searchTextEditingController = new TextEditingController();
  bool iconSearchVisibility = false;
  dynamic data;
  int currentPage = 0;
  int totalPages = 0;
  int pageSize = 20;
  List<dynamic> items = [];

  ScrollController scrollController = new ScrollController();

  void _search(String query) {
    EasyLoading.show(status: "Chargement...");
    var url = Uri.parse(
        "https://api.github.com/search/users?q=${query}&per_page=$pageSize&page=$currentPage");
    print(url);
    http.get(url).then((response) {
      setState(() {
        EasyLoading.dismiss();
        data = json.decode(response.body);
        items.addAll(data['items']);
        if (data['total_count'] % pageSize == 0) {
          totalPages = data['total_count'] ~/ pageSize;
        } else
          totalPages = (data['total_count'] / pageSize).floor() + 1;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          if (currentPage < totalPages - 1) {
            ++currentPage;
            _search(query);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Github Users => ${currentPage} / ${totalPages}'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      obscureText: iconSearchVisibility,
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: iconSearchVisibility == true
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                iconSearchVisibility = !iconSearchVisibility;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                width: 1,
                                color: Colors.blue,
                              ))),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      items = [];
                      currentPage = 0;
                      query = searchTextEditingController.text;
                      _search(query);
                    });
                    /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(query),
                    ));*/
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 1,
                  color: Colors.blue,
                ),
                controller: scrollController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GitRepositoiresPage(
                                    login: items[index]['login'],
                                    avatarUrl: items[index]['avatar_url'],
                                  )));
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(items[index]['avatar_url']),
                            radius: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text('${items[index]['login']}'),
                        ]),
                        CircleAvatar(
                          child: Text('${items[index]['score']}'),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
