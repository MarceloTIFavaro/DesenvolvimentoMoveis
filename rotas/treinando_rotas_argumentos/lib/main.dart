import 'package:flutter/material.dart';

void main(){
  runApp(const MyApp());

}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext){
    return MaterialApp(
      home: const TelaLogin(),
      debugShowCheckedModeBanner: false,      
    );
  }
}


// ----TELA DE LODIN (A) ----