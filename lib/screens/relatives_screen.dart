import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';

class RelativesScreen extends StatefulWidget {
  @override
  _RelativesScreenState createState() => _RelativesScreenState();
}

class _RelativesScreenState extends State<RelativesScreen> {
  var isLoading = false;

  var pageIndex = 0;
  var inputText = '';

  Future<dynamic> onSubmitted(String value) async {
    return await Provider.of<Auth>(context, listen: false).searchContact(value);
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(15, 31, 40, 1),
        // leading: Icon(Icons.notifications),
        title: Text('FRIENDS'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 34,
                right: 34,
                top: 25,
                bottom: 10,
              ),
              child: Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - 68) / 3,
                    child: GestureDetector(
                      child: pageIndex == 0
                          ? Text(
                              'Add Friend',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text('Add Friend'),
                      onTap: () {
                        setState(() {
                          pageIndex = 0;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 68) / 3,
                    child: GestureDetector(
                      child: pageIndex == 1
                          ? Text(
                              'My Friends',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text('My Friends'),
                      onTap: () {
                        setState(() {
                          pageIndex = 1;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 68) / 3,
                    child: GestureDetector(
                      child: pageIndex == 2
                          ? Text(
                              'Notifications',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text('Notifications'),
                      onTap: () {
                        setState(() {
                          pageIndex = 2;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8,
              ),
              child: Divider(color: Colors.black),
            ),
            pageIndex == 0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                            ),
                            hintText: ('Please enter name or phone'),
                          ),
                          controller: _controller,
                          onChanged: (value) {
                            setState(() {
                              inputText = value;
                            });
                          },
                        ),
                        SizedBox(height: 18,),
                        inputText.length < 3
                            ? SizedBox.shrink()
                            : FutureBuilder(
                                future: onSubmitted(inputText),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                          'An Error Occured. Please Try Again.'),
                                    );
                                  } else {
                                    return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data['users'].length,
                                      itemBuilder: (context, postion) {
                                        return Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(snapshot.data['users']
                                                        [postion]['name']),
                                                    Text(snapshot.data['users']
                                                            [postion]
                                                        ['securePhone']),
                                                  ],
                                                ),
                                                Spacer(),
                                                snapshot.data['users'][postion]
                                                        ['canAddFriend']
                                                    ? GestureDetector(
                                                        child: Icon(Icons.add),
                                                        onTap: () => Provider
                                                                .of<Auth>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                            .addFriend(snapshot
                                                                        .data[
                                                                    'users']
                                                                [postion]['id'])
                                                            .then((value) =>
                                                                setState(
                                                                    () {})),
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
                              ),
                      ],
                    ),
                  )
                : FutureBuilder(
                    future: Provider.of<Auth>(context).getRelations(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (!snapshot.hasData) {
                        return Center(
                          child: Text('No Friends'),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('An Error Occured. Please Try Again.'),
                        );
                      } else {
                        print(snapshot);
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data['users'].length,
                            itemBuilder: (context, postion) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: snapshot.data['users'][postion]
                                              ['relation']['status'] ==
                                          1
                                      ? Slidable(
                                          actionPane:
                                              SlidableDrawerActionPane(),
                                          actionExtentRatio: 0.25,
                                          secondaryActions: <Widget>[
                                            new IconSlideAction(
                                              caption: 'Delete',
                                              color: Colors.red,
                                              icon: Icons.delete,
                                              onTap: () {
                                                Provider.of<Auth>(context,
                                                        listen: false)
                                                    .removeFriend(
                                                        snapshot.data['users']
                                                            [postion]['id'])
                                                    .then((value) =>
                                                        setState(() {}));
                                                _showSnackBar(context,
                                                    'Deleted ${snapshot.data['users'][postion]['name']}');
                                              },
                                            ),
                                          ],
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data['users'][postion]
                                                    ['name'],
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                '${snapshot.data['users'][postion]['securePhone']} - ${snapshot.data['users'][postion]['locationCode']}',
                                              ),
                                            ],
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data['users']
                                                      [postion]['name'],
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  '${snapshot.data['users'][postion]['securePhone']} - ${snapshot.data['users'][postion]['locationCode']}',
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            snapshot.data['users'][postion]
                                                    ['relation']['canAccept']
                                                ? isLoading
                                                    ? CircularProgressIndicator()
                                                    : Row(
                                                        children: [
                                                          GestureDetector(
                                                            child: Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            onTap: () {
                                                              setState(
                                                                () {
                                                                  isLoading =
                                                                      true;
                                                                },
                                                              );
                                                              Provider.of<Auth>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .acceptRequest(
                                                                    snapshot.data[
                                                                            'users']
                                                                        [
                                                                        postion]['id'],
                                                                  )
                                                                  .then(
                                                                    (value) => {
                                                                      setState(
                                                                        () {
                                                                          isLoading =
                                                                              false;
                                                                        },
                                                                      ),
                                                                    },
                                                                  );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          GestureDetector(
                                                            child: Icon(
                                                              Icons.remove,
                                                              color: Colors.red,
                                                            ),
                                                            onTap: () {
                                                              setState(
                                                                () {
                                                                  isLoading =
                                                                      true;
                                                                },
                                                              );
                                                              Provider.of<Auth>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .rejectRequest(
                                                                    snapshot.data[
                                                                            'users']
                                                                        [
                                                                        postion]['id'],
                                                                  )
                                                                  .then(
                                                                    (value) => {
                                                                      setState(
                                                                        () {
                                                                          isLoading =
                                                                              false;
                                                                        },
                                                                      ),
                                                                    },
                                                                  );
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                : snapshot.data['users']
                                                                    [postion]
                                                                ['relation']
                                                            ['status'] ==
                                                        0
                                                    ? CircularProgressIndicator()
                                                    : SizedBox.shrink()
                                          ],
                                        ),
                                ),
                              );
                            });
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
