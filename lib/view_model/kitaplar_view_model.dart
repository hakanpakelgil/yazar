import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/model/kitap.dart';
import 'package:yazar/repository/database_repository.dart';
import 'package:yazar/tools/locator.dart';
import 'package:yazar/tools/sabitler.dart';
import 'package:yazar/view/bolumler_sayfasi.dart';
import 'package:yazar/view_model/bolumler_view_model.dart';

class KitaplarViewModel with ChangeNotifier{
  DatabaseRepository _databaseRepository = locator<DatabaseRepository>();

  ScrollController _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  List<Kitap> get kitaplar => _kitaplar;

  List<Kitap> _kitaplar = [];

  List<int> _tumKategoriler = [-1];

  int _secilenKategori = -1;

  List<int> get tumKategoriler => _tumKategoriler;

  set secilenKategori(int value) {
    _secilenKategori = value;
    notifyListeners();
  }

  int get secilenKategori => _secilenKategori;

  List<int> _secilenKitapIdleri = [];

  List<int> get secilenKitapIdleri => _secilenKitapIdleri;

  KitaplarViewModel(){
    _tumKategoriler.addAll(Sabitler.kategoriler.keys);
    _scrollController.addListener(_kaydirmaKontrol);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _ilkKitaplariGetir();
    });
  }

  void kitapEkle(BuildContext context) async {
    List<dynamic>? sonuc = await _pencereAc(context);

    if (sonuc != null && sonuc.length > 1) {
      String kitapAdi = sonuc[0];
      int kategori = sonuc[1];

      Kitap yeniKitap = Kitap(kitapAdi, DateTime.now(), kategori);
      int kitapIdsi = await _databaseRepository.createKitap(yeniKitap);
      yeniKitap.id = kitapIdsi;
      _kitaplar.add(yeniKitap);
      notifyListeners();
      //setState(() {});
    }
  }

  void kitapGuncelle(BuildContext context, int index) async {
    Kitap kitap = _kitaplar[index];

    List<dynamic>? sonuc = await _pencereAc(
      context,
      mevcutIsim: kitap.isim,
      mevcutKategori: kitap.kategori,
    );

    if (sonuc != null && sonuc.length > 1) {
      String yeniKitapAdi = sonuc[0];
      int yeniKategori = sonuc[1];

      if (kitap.isim != yeniKitapAdi || kitap.kategori != yeniKategori) {
        kitap.guncelle(yeniKitapAdi, yeniKategori);
        int guncellenenSatirSayisi = await _databaseRepository.updateKitap(kitap);
        if (guncellenenSatirSayisi > 0) {}
      }
    }
  }

  void kitapSil(int index) async {
    Kitap kitap = _kitaplar[index];
    int silinenSatirSayisi = await _databaseRepository.deleteKitap(kitap);
    if (silinenSatirSayisi > 0) {
      _kitaplar.removeAt(index);
      notifyListeners();
    }
  }

  void seciliKitaplariSil() async {
    int silinenSatirSayisi =
    await _databaseRepository.deleteKitaplar(_secilenKitapIdleri);
    if (silinenSatirSayisi > 0) {
      _kitaplar.removeWhere((kitap) => _secilenKitapIdleri.contains(kitap.id));
      notifyListeners();
    }
  }

  Future<void> _ilkKitaplariGetir() async {
    if(_kitaplar.isEmpty){
      _kitaplar = await _databaseRepository.readTumKitaplar(_secilenKategori, 0);
    }
    notifyListeners();
  }

  Future<void> _sonrakiKitaplariGetir() async {
    int? sonKitapId = _kitaplar.last.id;

    if (sonKitapId != null) {
      List<Kitap> sonrakiKitaplar =
      await _databaseRepository.readTumKitaplar(_secilenKategori, sonKitapId);
      _kitaplar.addAll(sonrakiKitaplar);
      notifyListeners();
    }
  }

  Future<List<dynamic>?> _pencereAc(
      BuildContext context, {
        String mevcutIsim = "",
        int mevcutKategori = 0,
      }) {
    TextEditingController isimController = TextEditingController(
      text: mevcutIsim,
    );
    return showDialog<List<dynamic>>(
      context: context,
      builder: (context) {
        int kategori = mevcutKategori;

        return AlertDialog(
          title: Text(
            "Kitap Adını Giriniz",
          ),
          content: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: isimController,
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Kategori:"),
                      DropdownButton<int>(
                        value: kategori,
                        items: Sabitler.kategoriler.keys.map((kategoriId) {
                          return DropdownMenuItem<int>(
                              value: kategoriId,
                              child:
                              Text(Sabitler.kategoriler[kategoriId] ?? ""));
                        }).toList(),
                        onChanged: (int? yeniDeger) {
                          if (yeniDeger != null) {
                            setState(() {
                              kategori = yeniDeger;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Onayla"),
              onPressed: () {
                Navigator.pop(context, [isimController.text.trim(), kategori]);
              },
            ),
          ],
        );
      },
    );
  }
  void bolumlerSayfasiniAc(BuildContext context, int index) {
    MaterialPageRoute sayfaYolu = MaterialPageRoute(
      builder: (context) {
        return ChangeNotifierProvider(
            create: (context) => BolumlerViewModel(_kitaplar[index]),
            child: BolumlerSayfasi(),
        );
      },
    );
    Navigator.push(context, sayfaYolu);
  }

  void _kaydirmaKontrol() {
    if(_scrollController.offset == _scrollController.position.maxScrollExtent){
      _sonrakiKitaplariGetir();
    }
  }
}