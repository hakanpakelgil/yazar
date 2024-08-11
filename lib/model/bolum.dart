import 'package:flutter/material.dart';

class Bolum with ChangeNotifier{
  dynamic id;
  int kitapId;
  String baslik;
  String icerik;

  Bolum(this.kitapId,this.baslik) : icerik = "";

  Bolum.fromMap(Map<String,dynamic> map)
      :  id = map["id"],
        kitapId = map["kitapId"],
        baslik = map["baslik"],
        icerik = map["icerik"];

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "kitapId": kitapId,
      "baslik": baslik,
      "icerik": icerik,
    };
  }
  void guncelle(String yeniBaslik){
    baslik = yeniBaslik;
    notifyListeners();
  }
}