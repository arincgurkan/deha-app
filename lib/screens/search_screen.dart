import 'package:flutter/material.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textController = TextEditingController();
  String input = '';

  Future<dynamic> onSubmitted(String value) async {
    return await Provider.of<Auth>(context, listen: false).searchContact(value);
  }

  @override
  Widget build(BuildContext context) {
    final AppBarController appBarController = AppBarController();
    return Scaffold(
      appBar: SearchAppBar(
        primary: Color.fromRGBO(15, 31, 40, 1),
        appBarController: appBarController,
        // You could load the bar with search already active
        autoSelected: true,
        searchHint: "Please enter at least 3 characters!",
        mainTextColor: Colors.white,
        onChange: (String value) {
          setState(() {
            input = value;
          });
        },
        //Will show when SEARCH MODE wasn't active
        mainAppBar: AppBar(
          title: Text("Add Friends"),
          backgroundColor: Color.fromRGBO(15, 31, 40, 1),
          actions: <Widget>[
            InkWell(
              child: Icon(
                Icons.search,
              ),
              onTap: () {
                //This is where You change to SEARCH MODE. To hide, just
                //add FALSE as value on the stream
                appBarController.stream.add(true);
              },
            ),
          ],
        ),
      ),
      body: input.length > 2
          ? FutureBuilder(
              future: onSubmitted(input),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('An Error Occured. Please Try Again.'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data['users'].length,
                    itemBuilder: (context, postion) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data['users'][postion]['name']),
                                  Text(snapshot.data['users'][postion]
                                      ['securePhone']),
                                ],
                              ),
                              Spacer(),
                              snapshot.data['users'][postion]['canAddFriend']
                                  ? GestureDetector(
                                      child: Icon(Icons.add),
                                      onTap: () => Provider.of<Auth>(context,
                                              listen: false)
                                          .addFriend(snapshot.data['users']
                                              [postion]['id'])
                                          .then((value) => setState(() {})),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  // print('Success ${snapshot.data['users']}');
                  // return Text('Done');
                }
              },
            )
          : Center(
              child: Text('Please enter at least 3 characters.'),
            ),
    );
  }
}
