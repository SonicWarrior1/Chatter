import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fwitch/models/livestream.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedCreen extends StatefulWidget {
  const FeedCreen({Key? key}) : super(key: key);

  @override
  State<FeedCreen> createState() => _FeedCreenState();
}

class _FeedCreenState extends State<FeedCreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Text('Live Users '),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          StreamBuilder<dynamic>(
            stream:
                FirebaseFirestore.instance.collection('livestream').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    LiveStream post =
                        LiveStream.fromMap(snapshot.data.docs[index].data);
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(post.image),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(post.username),
                                  Text(post.title),
                                  Text('${post.viewers} watching'),
                                  Text(
                                    'Started ${timeago.format(post.startedAt.toDate())}',
                                  )
                                ],
                              ),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.more_vert))
                            ]),
                      ),
                    );
                  },
                  itemCount: snapshot.data.docs.length,
                ),
              );
            },
          )
        ],
      ),
    ));
  }
}
