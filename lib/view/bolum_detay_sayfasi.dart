import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/view_model/bolum_detay_view_model.dart';

class BolumDetaySayfasi extends StatelessWidget {

  TextEditingController _icerikController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }
  AppBar _buildAppBar(BuildContext context){
    BolumDetayViewModel viewModel = Provider.of<BolumDetayViewModel>(
        context,
        listen: false
    );
    return AppBar(
      title: Text(viewModel.bolum.baslik),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
            viewModel.icerigiKaydet(_icerikController.text);
          }
          )
      ],
    );
  }



  Widget _buildBody(BuildContext context) {
    BolumDetayViewModel viewModel = Provider.of<BolumDetayViewModel>(
        context,
        listen: false
    );
    _icerikController.text = viewModel.bolum.icerik;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _icerikController,
        maxLines: 1000,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          )
        ),
      ),
    );
  }
}
