import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../../core/init/extensions/extension_shelf.dart';
import '../../../core/base/base_view.dart';
import '../../../core/init/extensions/context/responsive_extension.dart';
import '../../../core/init/extensions/context/theme_extension.dart';
import '../../../core/provider/call_provider.dart';
import '../../widgets/custom_list_tile.dart';
import '../call/pickup/pickup_layout.dart';
import 'contacts_view_model.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ContactsViewModel>(
        viewModel: ContactsViewModel(),
        onPageBuilder: (BuildContext context, ContactsViewModel _model) =>
            Observer(builder: (_) {
              return PickupLayout(
                  scaffold: Scaffold(
                appBar: appBar(context),
                body: body(context, _model),
              ));
            }),
        onModelReady: (model) {
          model.setContext(context);
          model.init();
        });
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios)),
      title: Text(
        'contacts'.translate,
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
                return CustomListTile(
                  onTap: () => listTileOnTap(context, _model, index),
                  image: _model.phones[index]['photo_url'],
                  title: _model.phones[index]['name'] ?? 'bos',
                  subTitle: _model.phones[index]['phone_number'] ?? 'bos',
                );
              },
            ),
          );
  }

  Future<void> listTileOnTap(
      BuildContext context, ContactsViewModel _model, int index) async {
    var provider = Provider.of<CallProvider>(context, listen: false);
    await provider.setReceiverUser(
        _model.phones[index]['user_id'],
        _model.phones[index]['name'],
        _model.phones[index]['photo_url'],
        _model.phones[index]['phone_number']);
    await provider.setUserName(_model.phones[index]['name']);
    await provider.setphotoUrl(_model.phones[index]['photo_url']);
    _model.navigateChatScreen();
  }
}
