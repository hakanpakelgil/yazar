import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/tools/locator.dart';
import 'package:yazar/view/kitaplar_sayfasi.dart';
import 'package:yazar/view_model/kitaplar_view_model.dart';

void main(){
  setupLocator();
  runApp(AnaUygulama());
}

class AnaUygulama extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(create: (context) => KitaplarViewModel(),
      child: KitaplarSayfasi(),
      ),
    );
  }
}
