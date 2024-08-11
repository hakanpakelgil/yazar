import 'package:yazar/base/database_base.dart';
import 'package:yazar/model/bolum.dart';
import 'package:yazar/model/kitap.dart';
import 'package:yazar/service/base/database_service.dart';
import 'package:yazar/service/sqflite/sqflite_database_service.dart';
import 'package:yazar/tools/locator.dart';

class DatabaseRepository implements DatabaseBase{
  final DatabaseService _service = locator<SqfliteDatabaseService>();

  @override
  Future createBolum(Bolum bolum) async{
    return await _service.createBolum(bolum);
  }

  @override
  Future createKitap(Kitap kitap) async{
    return await _service.createKitap(kitap);
  }

  @override
  Future<int> deleteBolum(Bolum bolum) async{
    return await _service.deleteBolum(bolum);
  }

  @override
  Future<int> deleteKitap(Kitap kitap) async{
    return await _service.deleteKitap(kitap);
  }

  @override
  Future<int> deleteKitaplar(List kitapIdleri) async{
    return await _service.deleteKitaplar(kitapIdleri);
  }

  @override
  Future<List<Bolum>> readTumBolumler(kitapId) async{
    return await _service.readTumBolumler(kitapId);
  }

  @override
  Future<List<Kitap>> readTumKitaplar(int kategoriId, sonKitapId) async{
    return await _service.readTumKitaplar(kategoriId, sonKitapId);
  }

  @override
  Future<int> updateBolum(Bolum bolum) async{
    return await _service.updateBolum(bolum);
  }

  @override
  Future<int> updateKitap(Kitap kitap) async{
    return await _service.updateKitap(kitap);
  }
}