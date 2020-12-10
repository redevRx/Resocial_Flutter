import 'package:flutter/material.dart';
import 'package:socialapp/comments/screen/comments.dart';
import 'package:socialapp/home/export/export_file.dart';

import '../exportNotify.dart';

class NotifyCard extends StatelessWidget {
  const NotifyCard({Key key, this.model, this.notifyBloc, this.myFeedBloc})
      : super(key: key);

  final NotifyModel model;
  final NotifyBloc notifyBloc;
  final MyFeedBloc myFeedBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.0),
      child: Dismissible(
          secondaryBackground: Container(
            height: 95.0,
            decoration: BoxDecoration(
                color: model.getTypeNotify() == "new feed"
                    ? Colors.blueAccent
                    : (model.getTypeNotify() == "comment")
                        ? Colors.greenAccent
                        : Colors.pinkAccent,
                borderRadius: BorderRadius.circular(12.0)),
            child: Icon(
              Icons.remove_circle_outline,
              size: 32.0,
              color: Colors.white,
            ),
          ),
          background: Container(
            height: 95.0,
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12.0)),
            child: Icon(
              Icons.remove_circle_outline,
              size: 32.0,
              color: Colors.white,
            ),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              notifyBloc.add(RemoveNotify(postId: model.postID));
            } else {
              notifyBloc.add(RemoveNotify(postId: model.postID));
            }
          },
          key: UniqueKey(),
          child: Container(
            height: 110.0,
            //normal 95
            child: Stack(
              children: [
                //bacground card content
                Positioned(
                    child: Container(
                  child: InkWell(
                    onLongPress: () {},
                    onTap: () async {
                      // print("on click notify");
                      //check if type notidy
                      //- like give go to post that like
                      //- new post or new feed go to new post
                      //- comment go to comment page
                      //and before to  page
                      //give load post info and comment info

                      final feed = FeedRepository();

                      final item = await feed.getOneFeed(model.postID);

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Comments(
                          i: 0,
                          postModels: [item],
                          uid: model.uid,
                        ),
                      ));
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(.5, .5),
                            spreadRadius: .1)
                      ]),
                      padding: EdgeInsets.only(
                        bottom: 4.0,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: 90.0,
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: BoxDecoration(
                                color: model.getTypeNotify() == "new feed"
                                    ? Colors.blueAccent.withOpacity(.6)
                                    : (model.getTypeNotify() == "comment")
                                        ? Colors.greenAccent.withOpacity(.6)
                                        : Colors.pinkAccent.withOpacity(.6),
                                boxShadow: [
                                  BoxShadow(
                                      color: model.getTypeNotify() == "new feed"
                                          ? Colors.blueAccent
                                          : (model.getTypeNotify() == "comment")
                                              ? Colors.greenAccent
                                              : Colors.pinkAccent,
                                      blurRadius: 4,
                                      offset: Offset(.5, .5),
                                      spreadRadius: .1)
                                ],
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          Container(
                            height: 90.0,
                            margin: EdgeInsets.symmetric(horizontal: 6.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Stack(
                              children: [
                                //create show user name if type is like notify
                                //if not if show
                                //if is case comment give show icon comment
                                Positioned(
                                  left: 16.0,
                                  top: 16.0,
                                  child: model.getTypeNotify() == "new feed"
                                      ? Icon(
                                          Icons.add,
                                          color: Colors.blueAccent,
                                          size: 28.0,
                                        )
                                      : (model.getTypeNotify() == "comment")
                                          ? Icon(
                                              Icons.add_comment_rounded,
                                              color: Colors.blueAccent,
                                              size: 28.0,
                                            )
                                          : Image.asset(
                                              "assets/icons/like_up.png",
                                              width: 30.0,
                                              scale: 1.0,
                                              fit: BoxFit.cover,
                                            ),
                                  // child: Text(
                                  //   (model.getTypeNotify() == "comment")
                                  //       ? "\ncomment"
                                  //       : "\n",
                                  //   style: TextStyle(
                                  //       color: Colors.black54,
                                  //       fontSize: 22.0,
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                ),
                                //type is like show "give like your post"
                                //type is post "He create new post now"
                                //type comment
                                Positioned(
                                    left: 85.0,
                                    top: 16.0,
                                    child: Text(
                                      model.getTypeNotify() == "new feed"
                                          ? "He create new post now"
                                          : (model.getTypeNotify() == "comment")
                                              ? "${model.message}"
                                              : "give like your post",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),

                // card profile info and time post
                //show time that make like or create post
                Positioned(
                    bottom: 0.0,
                    right: 32.0,
                    left: 32.0,
                    child: Card(
                      elevation: 22.0,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      child: Container(
                        height: 50.0,
                        width: 240.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // image prifile
                            Row(
                              children: [
                                Container(
                                    height: 45.0,
                                    width: 45.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(.5, .5),
                                            blurRadius: 0.5,
                                            color:
                                                Colors.black.withOpacity(.15),
                                            spreadRadius: .5)
                                      ],
                                      //shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            // '${userDetail[0].imageProfile}'
                                            model.profileUrl.toString()),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                //
                                SizedBox(
                                  width: 12.0,
                                ),
                                Text(
                                  model.name,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),

                            Text(
                              "${model.time}",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}
