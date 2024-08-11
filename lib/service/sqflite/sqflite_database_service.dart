import 'package:sqflite/sqflite.dart';
import 'package:yazar/model/bolum.dart';
import 'package:yazar/model/kitap.dart';
import 'package:path/path.dart';
import 'package:yazar/service/base/database_service.dart';

class SqfliteDatabaseService implements DatabaseService{
  Database? _veriTabani;

  String _kitaplarTabloAdi = "kitaplar";
  String _idKitaplar = "id";
  String _isimKitaplar = "isim";
  String _olusturulmaTarihiKitaplar = "olusturulmaTarihi";
  String _kategoriKitaplar = "kategori";

  String _bolumlerTabloAdi = "bolumler";
  String _idBolumler = "id";
  String _kitapIdBolumler = "kitapId";
  String _baslikBolumler = "baslik";
  String _icerikBolumler = "icerik";
  String _olusturulmaTarihiBolumler = "olusturulmaTarihi";

  Future<Database?> _veriTabaniniGetir() async {
    if(_veriTabani == null){
      String dosyaYolu = await getDatabasesPath();
      String veriTabaniYolu = join(dosyaYolu, "yazar.db");
      _veriTabani = await openDatabase(
        veriTabaniYolu,
        version: 2,
        onCreate: _tabloOlustur,
        onUpgrade: _tabloGuncelle,
      );
    }
    return _veriTabani;
  }

  Future<void> _tabloOlustur(Database db, int versiyon) async{
    await db.execute(
        """
      CREATE TABLE $_kitaplarTabloAdi (
        $_idKitaplar INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
        $_isimKitaplar TEXT NOT NULL,        
        $_olusturulmaTarihiKitaplar INTEGER,
        $_kategoriKitaplar INTEGER DEFAULT 0
      );
      """
    );
    await db.execute(
        """
      CREATE TABLE $_bolumlerTabloAdi (
        $_idBolumler INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
        $_kitapIdBolumler INTEGER NOT NULL,        
        $_baslikBolumler TEXT NOT NULL,
        $_icerikBolumler TEXT,
        $_olusturulmaTarihiBolumler TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY("$_kitapIdBolumler") REFERENCES "$_kitaplarTabloAdi"("$_idKitaplar") ON UPDATE CASCADE ON DELETE CASCADE
        );
    """
    );
  }

  Future<void> _tabloGuncelle(Database db, int oldVersion, int newVersion) async {
    await db.execute(
        "ALTER TABLE $_kitaplarTabloAdi ADD COLUMN $_kategoriKitaplar INTEGER DEFAULT 0"
    );
  }

  @override
  Future createBolum(Bolum bolum) async{
    Database? db = await _veriTabaniniGetir();
    if(db != null){
      return await db.insert(_bolumlerTabloAdi, bolum.toMap());
    }
    else {
      return -1;
    }
  }

  @override
  Future createKitap(Kitap kitap) async{
    Database? db = await _veriTabaniniGetir();
    if(db != null){
      return await db.insert(_kitaplarTabloAdi, _kitapToMap(kitap));
    }
    else {
      return -1;
    }
  }

  @override
  Future<int> deleteBolum(Bolum bolum) async{
    Database? db = await _veriTabaniniGetir();
    if(db != null){
      return await db.delete(
          _bolumlerTabloAdi,
          where: "$_idBolumler = ?",
          whereArgs: [bolum.id]
      );
    }
    else {
      return 0;
    }
  }

  @override
  Future<int> deleteKitap(Kitap kitap) async{
    Database? db = await _veriTabaniniGetir();
    if(db != null){
      return await db.delete(
          _kitaplarTabloAdi,
          where: "$_idKitaplar = ?",
          whereArgs: [kitap.id]
      );
    }
    else {
      return 0;
    }
  }

  @override
  Future<int> deleteKitaplar(List kitapIdleri) async{
    Database? db = await _veriTabaniniGetir();
    if(db != null && kitapIdleri.isNotEmpty){
      String filtre = "$_idKitaplar in (";
      for(int i=0;i < kitapIdleri.length;i++){
        if(i != kitapIdleri.length -1){
          filtre += "?,";
        }
        else{
          filtre += "?)";
        }
      }

      return await db.delete(
        _kitaplarTabloAdi,
        where: filtre,
        whereArgs: kitapIdleri,
      );
    }
    else {
      return 0;
    }
  }

  @override
  Future<List<Bolum>> readTumBolumler(kitapId) async{
    Database? db = await _veriTabaniniGetir();
    List<Bolum> bolumler = [];

    if(db != null){
      List<Map<String, dynamic>> bolumlerMap = await db.query(
        _bolumlerTabloAdi,
        where: "$_kitapIdBolumler = ?",
        whereArgs: [kitapId],
      );
      for(Map<String,dynamic> m in bolumlerMap){
        Bolum b = Bolum.fromMap(m);
        bolumler.add(b);
      }
    }

    return bolumler;
  }

  @override
  Future<List<Kitap>> readTumKitaplar(int kategoriId, sonKitapId) async{
    Database? db = await _veriTabaniniGetir();
    List<Kitap> kitaplar = [];

    if(db != null){
      String filtre = "$_idKitaplar > ?";
      List<dynamic> filtreArgumanlari = [sonKitapId];

      if(kategoriId >= 0){
        filtre += " and $_kategoriKitaplar = ?";
        filtreArgumanlari.add(kategoriId);
      }

      List<Map<String, dynamic>> kitaplarMap = await db.query(
        _kitaplarTabloAdi,
        where: filtre,
        whereArgs: filtreArgumanlari,
        orderBy: "$_idKitaplar",
        limit: 15,
        //offset:
      );
      for(Map<String,dynamic> m in kitaplarMap){
        Kitap k = _mapToKitap(m);
        kitaplar.add(k);
      }
    }

    return kitaplar;
  }

  @override
  Future<int> updateBolum(Bolum bolum) async{
    Database? db = await _veriTabaniniGetir();
    if(db != null){
      return await db.update(
          _bolumlerTabloAdi,
          bolum.toMap(),
          where: "$_idBolumler = ?",
          whereArgs: [bolum.id]
      );
    }
    else {
      return 0;
    }
  }

  @override
  Future<int> updateKitap(Kitap kitap) async{
    Database? db = await _veriTabaniniGetir();
    if(db != null){
      return await db.update(
          _kitaplarTabloAdi,
          _kitapToMap(kitap),
          where: "$_idKitaplar = ?",
          whereArgs: [kitap.id]
      );
    }
    else {
      return 0;
    }
  }

  Map<String, dynamic> _kitapToMap(Kitap kitap) {
    Map<String,dynamic> kitapMap = kitap.toMap();
    DateTime olusturulmaTarihi = kitapMap["olusturulmaTarihi"];
    if(olusturulmaTarihi != null){
      kitapMap["olusturulmaTarihi"] = olusturulmaTarihi.millisecondsSinceEpoch;
    }
    return kitapMap;
  }

  Kitap _mapToKitap(Map<String, dynamic> m) {
    Map<String, dynamic> kitapMap = Map.from(m);
    int? olusturulmaTarihi = m["olusturulmaTarihi"];
    if(olusturulmaTarihi != null){
      m["olusturulmaTarihi"] = DateTime.fromMillisecondsSinceEpoch(
        olusturulmaTarihi,
      );
    }
    return Kitap.fromMap(kitapMap);
  }
  
}