import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/base/base_view.dart';
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
      leading: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
      title: Text(
        'Contacts',
        style: context.headline3
            .copyWith(fontSize: (context.width + context.height) / .7),
      ),
    );
  }

  Widget body(BuildContext context, ContactsViewModel _model) {
    return _model.phones.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: EdgeInsets.only(top: context.height * 2),
            child: ListView.builder(
              itemCount: _model.phones.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: SizedBox(
                    width: context.width * 15,
                    height: context.height * 10,
                    child: ClipOval(
                        child: FadeInImage.assetNetwork(
                      placeholder: 'assets/gifs/loading.gif',
                      image: _model.phones[index]['photo_url'],
                      fit: BoxFit.cover,
                    )),
                  ),
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
}
