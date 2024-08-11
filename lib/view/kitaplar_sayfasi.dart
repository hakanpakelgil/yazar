import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/model/kitap.dart';
import 'package:yazar/tools/sabitler.dart';
import 'package:yazar/view_model/kitaplar_view_model.dart';

class KitaplarSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: _buildKitapEkleFab(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    KitaplarViewModel viewModel = Provider.of<KitaplarViewModel>(
        context,
        listen: false
    );
    return AppBar(
      title: Text("Kitaplar Sayfası"),
      actions: [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            viewModel.seciliKitaplariSil();
          },
        ),
      ],
    );
  }

  Widget _buildKitapEkleFab(BuildContext context) {
    KitaplarViewModel viewModel = Provider.of<KitaplarViewModel>(
        context,
        listen: false
    );
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        viewModel.kitapEkle(context);
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildKategoriFiltresi(),
        Expanded(
          child: Consumer<KitaplarViewModel>(
            builder: (context, viewModel, child) => ListView.builder(
              itemBuilder: (context,index) {
                return ChangeNotifierProvider.value(
                  value: viewModel.kitaplar[index],
                  child: _buildListItem(context,index),
                );
              },
              controller: viewModel.scrollController,
              itemCount: viewModel.kitaplar.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKategoriFiltresi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Kategori:"),
        Consumer<KitaplarViewModel>(
          builder: (context, viewModel, child) => DropdownButton<int>(
            value: viewModel.secilenKategori,
            items: viewModel.tumKategoriler.map((kategoriId) {
              return DropdownMenuItem<int>(
                  value: kategoriId,
                  child: Text(
                    kategoriId == -1
                        ? "Hepsi"
                        : Sabitler.kategoriler[kategoriId] ?? "",
                  ));
            }).toList(),
            onChanged: (int? yeniDeger) {
              if (yeniDeger != null) {
                  viewModel.secilenKategori = yeniDeger;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context,int index) {
    KitaplarViewModel viewModel = Provider.of<KitaplarViewModel>(
        context,
        listen: false
    );
    return Consumer<Kitap>(
      builder: (context, kitap, child) => ListTile(
        leading: CircleAvatar(
          child: Text(kitap.id.toString()),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                viewModel.kitapGuncelle(context, index);
              },
            ),
            Checkbox(
              value: kitap.seciliMi,
              onChanged: (bool? yeniDeger) {
                if (yeniDeger != null) {
                  int? kitapId = kitap.id;
                  if (kitapId != null) {
                      if (yeniDeger) {
                        viewModel.secilenKitapIdleri.add(kitapId);
                      } else {
                        viewModel.secilenKitapIdleri.remove(kitapId);
                      }
                      kitap.sec(yeniDeger);
                  }
                }
              },
            ),
          ],
        ),
        title: Text(kitap.isim),
        subtitle: Text(Sabitler.kategoriler[kitap.kategori] ?? ""),
        onTap: () {
          viewModel.bolumlerSayfasiniAc(context, index);
        },
      ),
    );
  }


}
