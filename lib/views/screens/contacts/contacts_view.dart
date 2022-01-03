import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/base/base_view.dart';
import '../../../core/helper/call.utilities.dart';
import '../../../core/init/extensions/context/responsive_extension.dart';
import '../../../core/init/extensions/context/theme_extension.dart';
import 'contacts_view_model.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ContactsViewModel>(
        viewModel: ContactsViewModel(),
        onPageBuilder: (BuildContext context, ContactsViewModel _model) =>
            Observer(builder: (_) {
              return Scaffold(
                appBar: appBar(context),
                body: body(context, _model),
              );
            }),
        onModelReady: (model) {
          model.setContext(context);
          model.init();
        });
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 3,
      shadowColor: context.lightPink,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back)),
      title: Text(
        'Contacts',
        style: context.headline3
            .copyWith(fontSize: (context.width + context.height) / .7),
      ),
    );
  }

  Widget body(BuildContext context, ContactsViewModel _model) {
    return _model.phones.isEmpty
        ? Center(
            child: CircularProgressIndicator(
            color: context.primaryColor,
          ))
        : Padding(
            padding: EdgeInsets.only(top: context.height * 2),
            child: ListView.builder(
              itemCount: _model.phones.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => listTileOnTap(context, _model, index),
                  leading: _listTileLeading(context, _model, index),
                  title: Text(_model.phones[index]['name'] ?? 'bos'),
                  subtitle: Text(
                    _model.phones[index]['phone_number'] ?? 'bos',
                    style: context.softText,
                  ),
                );
              },
            ),
          );
  }

  Future<void> listTileOnTap(
      BuildContext context, ContactsViewModel _model, int index) async {
    await _model.setReceiverUser(
        _model.phones[index]['user_id'],
        _model.phones[index]['name'],
        _model.phones[index]['photo_url'],
        _model.phones[index]['phone_number']);
    await _model.per.cameraAndMicrophonePermissionsGranted()
        ? CallUtils()
            .dial(from: _model.sender!, to: _model.receiver!, context: context)
        : null;
  }

  SizedBox _listTileLeading(
      BuildContext context, ContactsViewModel _model, int index) {
    return SizedBox(
      width: context.width * 14,
      height: context.height * 10,
      child: ClipOval(
          child: FadeInImage.assetNetwork(
        placeholder: 'assets/gifs/loading.gif',
        image: _model.phones[index]['photo_url'],
        fit: BoxFit.cover,
      )),
    );
  }
}
