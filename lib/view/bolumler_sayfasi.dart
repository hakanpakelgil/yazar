import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/model/bolum.dart';
import 'package:yazar/view_model/bolumler_view_model.dart';

class BolumlerSayfasi extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: _buildBolumEkleFab(context),
    );
  }

  AppBar _buildAppBar(BuildContext context){
    BolumlerViewModel viewModel = Provider.of<BolumlerViewModel>(
        context,
        listen: false
    );
    return AppBar(
      title: Text(viewModel.kitap.isim),
    );
  }

  Widget _buildBolumEkleFab(BuildContext context){
    BolumlerViewModel viewModel = Provider.of<BolumlerViewModel>(
        context,
        listen: false
    );
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: (){
        viewModel.bolumEkle(context);
      },
    );
  }

  Widget _buildBody(){
    return Consumer<BolumlerViewModel>(
      builder: (context, viewModel, child) => ListView.builder(
        itemCount: viewModel.bolumler.length,
        itemBuilder: (BuildContext context, int index) {
          return ChangeNotifierProvider.value(
            value: viewModel.bolumler[index],
            child: _buildListItem(context, index),
          );
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    BolumlerViewModel viewModel = Provider.of<BolumlerViewModel>(
        context,
        listen: false
    );
    return Consumer<Bolum>(
      builder: (context, bolum, child) => ListTile(
        leading: CircleAvatar(
          child: Text(
              bolum.id.toString()),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                  Icons.edit
              ),
              onPressed: (){
                viewModel.bolumGuncelle(context,index);
              },
            ),
            IconButton(
              icon: Icon(
                  Icons.delete
              ),
              onPressed: (){
                viewModel.bolumSil(index);
              },
            ),
          ],
        ),
        title: Text(bolum.baslik),
        onTap: (){
          viewModel.bolumDetaySayfasiniAc(context, index);
        },
      ),
    );
  }


}

