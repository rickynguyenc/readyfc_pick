import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListMemberScreen extends HookConsumerWidget {
  const ListMemberScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(appBar: AppBar(title: Text('Danh sach cau thu'),),body: Container(child: Row(children: [
      Column(children: [
        Container(child: Text('Hau ve'),),

      ],),
    ],)),);
  }
  Widget chooseMember(){
    return ListTile(
      title: ,
    )
  }
}