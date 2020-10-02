import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialapp/Profile/AddProfile/bloc/add_profile_bloc.dart';
import 'package:socialapp/Profile/AddProfile/bloc/event/add_profile_event.dart';
import 'package:socialapp/Profile/AddProfile/bloc/models/add_profile_model.dart';
import 'package:socialapp/Profile/AddProfile/bloc/state/add_profile_state.dart';
import 'package:socialapp/widgets/appBar/app_bar_login.dart';
import 'package:socialapp/widgets/cardBackground/item_card_shape_v2.dart';
import 'dart:io';

class AddProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AddProfileBloc(),
        child: addProfile(),
      ),
    );
  }
}

class addProfile extends StatefulWidget {
  @override
  _addProfileState createState() => _addProfileState();
}

class _addProfileState extends State<addProfile> {
  final txtUserStatus = TextEditingController();
  final txtNickName = TextEditingController();

  Future<void> checkPermission() async {
    if (await Permission.camera.status.isUndetermined &&
        await Permission.storage.status.isUndetermined) {
      // user grant permission yet ?
      print("user not grant permission");
      Map<Permission, PermissionStatus> statuses =
          await [Permission.camera, Permission.storage].request();

      print(statuses[Permission.camera]);
      if (await statuses[Permission.camera].isGranted &&
          await statuses[Permission.storage].isGranted) {
        //fi yet give request permission
        print("user grant permission camera and storeage");
      }
    }

    if (await Permission.camera.isRestricted) {
      //user bloc permission
      print("user block grant permission");
    }
    if (await Permission.camera.status.isGranted &&
        await Permission.storage.status.isGranted) {
      //user grant permission

      print("user grant permission camera and storage");
    }
  }

  File _image;

  //image picker from gallery
  Future<void> getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<void> getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future<void> checkCameraPermission() async {
    var status = await Permission.camera;

    if (await status.status.isUndetermined) {
      //request permission
      if (await status.request().isGranted) {
        //result that request permission
        print("user graint camera permission");
        //open camera
        //getImageCamera();
      }
    }

    //check user clock permission
    if (await status.isRestricted) {
      print("user block graint camera permission");
    }

    //user grant permission
    if (await status.isGranted) {
      print("user graint camera permission");
      Navigator.pop(context);
      //open camera
      getImageCamera();
    }
  }

  Future<void> checkGalleryPermission() async {
    var status = await Permission.storage;

    if (await status.status.isUndetermined) {
      //request permission
      if (await status.request().isGranted) {
        //result that request permission
        print("user graint storage permission");
        //open gallery
        //getImageGallery();
      }
    }

    //check user clock permission
    if (await status.isRestricted) {
      print("user block graint storage permission");
    }

    //user grant permission
    if (await status.isGranted) {
      print("user graint storage permission");
      Navigator.pop(context);
      //open gallery
      getImageGallery();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _fromTop = false;

    final AddProfileBloc profileBloc = BlocProvider.of<AddProfileBloc>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: <Widget>[
                // app bar page
                AppBarCustom(
                  title: 'Profile',
                  titleColor: Color(0xFFFF2D55),
                  status: "profile",
                ),
                BlocBuilder<AddProfileBloc, AddProfileState>(
                  builder: (context, state) {
                    if (state is onSaveAddprofileDialog) {
                      return CircularProgressIndicator();
                    } else if (state is onSaveAddProfileFailed) {
                      return Text(state.data);
                    }
                    return Container();
                  },
                ),
                BlocListener<AddProfileBloc, AddProfileState>(
                  listener: (context, state) {
                    if (state is onSaveAddProfileFailed) {
                      print(state.data);
                    } else if (state is onSaveAddprofileDialog) {
                      print(state.toString());
                    } else if (state is onSaveAddProfileSuccessfully) {
                      print(state.data);
                      Navigator.of(context).pushNamed("/home");
                    }
                  },
                  child: Container(),
                ),
                Stack(
                  children: <Widget>[
                    // create card shap background
                    _carditemShapProfile(),
                    Column(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 32.0, horizontal: 150.0),
                            child: InkWell(
                                onTap: () {
                                  _customDialog(context, _fromTop);
                                  //  customDialog(context: context,btnOk: "Camera",btnCancel: "Gallery",description: "Selected Camera or Gallery image",image: null, title: "Selected Image",);
                                },
                                child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                                  child: _image == null
                                      ? Image.network(
                                          "https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg",
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.file(
                                          _image,
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                ))),
                        textUserStatus(status: txtUserStatus),
                        textNickName(nickName: txtNickName),
                        buttonSaveAddprofile(
                            data: AddProfileModel(
                                _image, txtNickName.text, txtUserStatus.text),
                            bloc: profileBloc)
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future _customDialog(BuildContext context, bool _fromTop) {
    return showGeneralDialog(
      barrierLabel: "Select Images",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: _fromTop ? Alignment.topCenter : Alignment.bottomCenter,
          child: Container(
            height: 280,
            child: SizedBox.expand(
                child: Column(
              children: <Widget>[
                Text(
                  "Selcted",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                SizedBox(
                  height: 36.0,
                ),
                Text(
                  "Select Image From Camera\n \nor Gallery...",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      decorationColor: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 80.0, left: 32.0, right: 32.0, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                          elevation: 8.0,
                          clipBehavior: Clip.none,
                          color: Color(0xFFFF2D55),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          onPressed: () {
                            checkCameraPermission();
                          },
                          child: Text(
                            "Camera",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .apply(color: Colors.white.withOpacity(.75)),
                          )),
                      RaisedButton(
                          elevation: 8.0,
                          clipBehavior: Clip.none,
                          color: Color(0xFFFF2D55),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          onPressed: () {
                            checkGalleryPermission();
                          },
                          child: Text(
                            "Gallery",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .apply(color: Colors.white.withOpacity(.75)),
                          ))
                    ],
                  ),
                )
              ],
            )),
            margin: EdgeInsets.only(top: 50, left: 12, right: 12, bottom: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(45),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, _fromTop ? -1 : 1), end: Offset(0, 0))
                  .animate(anim1),
          child: child,
        );
      },
    );
  }
}

class buttonSaveAddprofile extends StatelessWidget {
  final AddProfileModel data;
  final AddProfileBloc bloc;

  const buttonSaveAddprofile({
    Key key,
    this.data,
    this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          RaisedButton(
              elevation: 8.0,
              clipBehavior: Clip.none,
              color: Color(0xFFFF2D55),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              onPressed: () {
                print(data.nickName + " : " + data.status);
                bloc.add(onSaveAddprofile(data));
              },
              child: Text(
                "Save",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .apply(color: Colors.white.withOpacity(.75)),
              ))
        ],
      ),
    );
  }
}

class textNickName extends StatelessWidget {
  final TextEditingController nickName;
  const textNickName({
    Key key,
    this.nickName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
      child: Container(
        child: TextField(
          controller: nickName,
          decoration: InputDecoration(
              hintText: "Nick Name",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  borderSide: BorderSide(
                      color: Color(0xFFFF2D55).withOpacity(.75), width: 4.0)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                      color: Color(0xFFFF2D55).withOpacity(.75), width: 2.0)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                      color: Color(0xFFFF2D55).withOpacity(.75), width: 4.0)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                      color: Color(0xFFFF2D55).withOpacity(.75), width: 2.0))),
        ),
      ),
    );
  }
}

class textUserStatus extends StatelessWidget {
  final TextEditingController status;
  const textUserStatus({
    Key key,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
      child: Container(
        child: TextField(
          keyboardType: TextInputType.multiline,
          controller: status,
          maxLengthEnforced: true,
          maxLength: 50,
          decoration: InputDecoration(
              hintText: "User Status",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  borderSide: BorderSide(
                      color: Color(0xFFFF2D55).withOpacity(.75), width: 4.0)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                      color: Color(0xFFFF2D55).withOpacity(.75), width: 2.0)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                      color: Color(0xFFFF2D55).withOpacity(.75), width: 4.0)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                      color: Color(0xFFFF2D55).withOpacity(.75), width: 2.0))),
        ),
      ),
    );
  }
}

class _carditemShapProfile extends StatelessWidget {
  const _carditemShapProfile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
          clipper: BackgroundClipper(),
          child: Hero(
            tag: "background",
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFF2D55).withOpacity(.29),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.59,
            ),
          )),
    );
  }
}

//  text: "Select image from Camera or Gallery..."

class myClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return getClipper();
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

Rect getClipper() {
  return Rect.fromLTWH(0, 0, 200, 100);
}