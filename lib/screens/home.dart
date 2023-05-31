import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase/screens/add_task.dart';
import 'package:todo_firebase/services/utility_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

Widget circularProgressbar = const SizedBox(
    child: Center(
  child: CircularProgressIndicator(),
));

class _HomeState extends State<Home> {
  FirebaseUtilityServices utility = FirebaseUtilityServices();
  String? uid = '';
  Future getUserId() async {
    String? user = await FirebaseAuth.instance.currentUser?.uid;
    uid = user;
    return uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TODO'), actions: [
        IconButton(
            onPressed: () {
              utility.logout(context);
            },
            icon: const Icon(Icons.logout))
      ]),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
              future: getUserId(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(uid)
                        .collection('mytask')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          snapshot.connectionState) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: ((context, index) {
                                var time = (snapshot.data?.docs[index]
                                        ['timestamp'] as Timestamp)
                                    .toDate();
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => AddTask(
                                                title_val: snapshot
                                                    .data?.docs[index]['title'],
                                                description_val:
                                                    snapshot.data?.docs[index]
                                                        ['description']))));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(5),
                                      tileColor: Colors.black26,
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('tasks')
                                              .doc(uid)
                                              .collection('mytask')
                                              .doc(snapshot
                                                  .data?.docs[index]['time']
                                                  .toString())
                                              .delete();
                                        },
                                      ),
                                      title: Text(
                                          snapshot.data?.docs[index]['title'] +
                                              ' : ' +
                                              DateFormat.yMd()
                                                  .add_jm()
                                                  .format(time),
                                          style: TextStyle(fontSize: 20)),
                                      subtitle: Text(
                                          snapshot.data?.docs[index]
                                              ['description'],
                                          style: TextStyle(fontSize: 15)),
                                    ),
                                  ),
                                );
                              }));
                        } else {
                          return circularProgressbar;
                        }
                      } else {
                        return circularProgressbar;
                      }
                    },
                  );
                } else {
                  return circularProgressbar;
                }
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddTask(title_val: "", description_val: "")));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
