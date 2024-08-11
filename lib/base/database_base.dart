import 'package:yazar/model/bolum.dart';
import 'package:yazar/model/kitap.dart';

abstract class DatabaseBase {
  Future<dynamic> createKitap(Kitap kitap);

  Future<List<Kitap>> readTumKitaplar(int kategoriId,dynamic sonKitapId);

  Future<int> updateKitap(Kitap kitap);

  Future<int> deleteKitap(Kitap kitap);

  Future<int> deleteKitaplar(List<dynamic> kitapIdleri);

  Future<dynamic> createBolum(Bolum bolum);

  Future<List<Bolum>> readTumBolumler(dynamic kitapId);

  Future<int> updateBolum(Bolum bolum);

  Future<int> deleteBolum(Bolum bolum);
}