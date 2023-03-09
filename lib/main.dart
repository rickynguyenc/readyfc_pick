import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:readyfc_app/listselectmember_screen.dart';
import 'package:readyfc_app/result_randomteam_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ReadyFc',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ListMemberScreen(),
        routes: {
          "/listmember": (context) => ListMemberScreen(),
          "/result": (context) => ResultRandomTeam(),
        });
  }
}
