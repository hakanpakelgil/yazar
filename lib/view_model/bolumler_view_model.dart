import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/model/bolum.dart';
import 'package:yazar/model/kitap.dart';
import 'package:yazar/repository/database_repository.dart';
import 'package:yazar/tools/locator.dart';
import 'package:yazar/view/bolum_detay_sayfasi.dart';
import 'package:yazar/view_model/bolum_detay_view_model.dart';

class BolumlerViewModel with ChangeNotifier{
  DatabaseRepository _databaseRepository = locator<DatabaseRepository>();

  List<Bolum> _bolumler = [];

  List<Bolum> get bolumler => _bolumler;

  final Kitap _kitap;

  Kitap get kitap => _kitap;

  BolumlerViewModel(this._kitap){
    WidgetsBinding.instance.addPostFrameCallback((_){
      _tumBolumleriGetir();
    });
  }

  void bolumEkle(BuildContext context) async {
    String? bolumBasligi = await _pencereAc(context);
    int? kitapId = _kitap.id;

    if(bolumBasligi != null && kitapId != null){
      Bolum yeniBolum = Bolum(kitapId, bolumBasligi);
      int bolumIdsi = await _databaseRepository.createBolum(yeniBolum);
      yeniBolum.id = bolumIdsi;
      _bolumler.add(yeniBolum);
      notifyListeners();
    }
  }

  void bolumGuncelle(BuildContext context, int index) async {
    String? yeniBolumBasligi = await _pencereAc(context);

    if(yeniBolumBasligi != null){
      Bolum bolum = _bolumler[index];
      bolum.guncelle(yeniBolumBasligi);
      int guncellenenSatirSayisi = await _databaseRepository.updateBolum(bolum);
      if(guncellenenSatirSayisi > 0){}
    }
  }

  void bolumSil(int index) async{
    Bolum bolum = _bolumler[index];
    int silinenSatirSayisi = await _databaseRepository.deleteBolum(bolum);
    if(silinenSatirSayisi > 0) {  
      _bolumler.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> _tumBolumleriGetir() async{
    int? kitapId = _kitap.id;

    if(kitapId != null){
      _bolumler = await _databaseRepository.readTumBolumler(kitapId);
      notifyListeners();
    }
  }

  Future<String?> _pencereAc(BuildContext context){
    return showDialog<String>(
      context: context,
      builder: (context){
        String? sonuc;

        return AlertDialog(
          title: Text(
            "Bölüm Adını Giriniz",
          ),
          content: TextField(
            onChanged: (yeniDeger){
              sonuc = yeniDeger;
            },
          ),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Onayla"),
              onPressed: (){
                Navigator.pop(context, sonuc);
              },
            ),
          ],
        );
      },
    );
  }
  void bolumDetaySayfasiniAc(BuildContext context, int index){
    MaterialPageRoute sayfaYolu = MaterialPageRoute(
      builder: (context){
        return ChangeNotifierProvider(
            create: (context) => BolumDetayViewModel(_bolumler[index]),
          child: BolumDetaySayfasi(),
        );
      },
    );
    Navigator.push(context, sayfaYolu);

  }
}