import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/call/bloc/call_bloc.dart';
import 'package:socialapp/call/model/call_model.dart';
import 'package:socialapp/call/repository/call_agora_repository.dart';
import 'package:socialapp/call/screen/pickUp/pick_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final String uid;
  final CallBloc callBloc;
  final CallAgoraRepository callAgoraRepository = CallAgoraRepository();
  PickupLayout(
      {Key key, @required this.callBloc, @required this.scaffold, this.uid});

  @override
  Widget build(BuildContext context) {
    // callBloc.add(OnCallStreamStating(uid: uid));
    // return BlocBuilder<CallBloc, CallState>(
    //   cubit: callBloc,
    //   builder: (context, state) {
    //     if (state is OnCallStreamSuccess) {
    //       if (state.callModel != null) {
    //         if (!state.callModel.hasDialled) {
    //           return PickUpScreen(call: state.callModel, uid: uid);
    //         } else {
    //           return scaffold;
    //         }
    //       } else {
    //         return scaffold;
    //       }
    //     } else {
    //       return scaffold;
    //     }
    //   },
    // );
    return StreamBuilder<DocumentSnapshot>(
      stream: callAgoraRepository.CallStream1(),
      builder: (context, snapshot) {
        CallModel callModel;
        try {
          callModel = CallModel.formMap(snapshot.data.data());
          if (!callModel.hasDialled) {
            return PickUpScreen(
              call: callModel,
              uid: uid,
            );
          } else {
            return scaffold;
          }
        } catch (e) {
          print("not call error :$e");
          return scaffold;
        }
      },
    );
  }
}
