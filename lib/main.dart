import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp8/helloUI.dart';
import 'contract_linking.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContractLinking(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HelloUI(),
      ),
    );
  }
}