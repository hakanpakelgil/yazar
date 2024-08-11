import 'package:flutter/material.dart';

class Kitap with ChangeNotifier{
  dynamic id;
  String isim;
  DateTime olusturulmaTarihi;
  int kategori;

  bool seciliMi = false;

  Kitap(this.isim, this.olusturulmaTarihi, this.kategori);

  Kitap.fromMap(Map<String,dynamic> map)
      : id = map["id"],
        isim = map["isim"],
        olusturulmaTarihi = map["olusturulmaTarihi"],
        kategori = map["kategori"] ?? 0;

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "isim": isim,
      "olusturulmaTarihi": olusturulmaTarihi,
      "kategori": kategori,
    };
  }

  void guncelle(String yeniIsim, int yeniKategori){
    isim = yeniIsim;
    kategori = yeniKategori;
    notifyListeners();
  }

  void sec(bool yeniDeger){
    seciliMi = yeniDeger;
    notifyListeners();
  }
}