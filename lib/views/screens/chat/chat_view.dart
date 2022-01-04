import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/base_view.dart';
import '../../../core/constants/navigation/string_constants.dart';
import '../../../core/helper/call.utilities.dart';
import '../../../core/init/extensions/context/responsive_extension.dart';
import '../../../core/init/extensions/context/theme_extension.dart';
import '../../../core/provider/call_provider.dart';
import '../../../core/provider/user_provider.dart';
import 'chat_view_model.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ChatViewModel>(
        viewModel: ChatViewModel(),
        // ignore: unnecessary_lambdas
        onPageBuilder: (BuildContext context, ChatViewModel _model) =>
            _body(context, _model),
        onModelReady: (model) {
          model.setContext(context);
          model.init();
        });
  }

  Scaffold _body(BuildContext context, ChatViewModel _model) {
    return Scaffold(
        appBar: _appBar(context, _model),
        body: Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                background(context),
                1 == 1 ? _emptyWidgets(context) : _messagesList(context),
              ],
            )),
            _bottomBar(context)
          ],
        ));
  }

  AppBar _appBar(BuildContext context, ChatViewModel _model) {
    return AppBar(
      titleSpacing: 0,
      centerTitle: false,
      leading: _backButton(context),
      title: _appBarTitle(context),
      actions: [_videoCallButton(context, _model)],
    );
  }

  IconButton _backButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  IconButton _videoCallButton(BuildContext context, ChatViewModel _model) {
    var sender = Provider.of<UserProvider>(context, listen: false).user;
    var receiver = Provider.of<CallProvider>(context, listen: false).receiver;
    return IconButton(
      onPressed: () async {
        await _model.per.cameraAndMicrophonePermissionsGranted()
            ? CallUtils().dial(from: sender!, to: receiver!, context: context)
            : null;
      },
      icon: const Icon(Icons.videocam),
      splashColor: context.primaryColor,
      splashRadius: 25,
    );
  }

  Row _appBarTitle(BuildContext context) {
    var provider = Provider.of<CallProvider>(context, listen: false);
    return Row(
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: ClipOval(
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/gifs/loading.gif',
              image: provider.photoUrl ?? defaultUserPhoto,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          provider.userName ?? '',
          style: context.headline5,
        )
      ],
    );
  }

  Material background(BuildContext context) {
    return Material(
        color: context.backgroundLight,
        child: Image(
          image: const AssetImage('assets/png/chatbg.png'),
          width: context.width * 100,
          height: context.height * 100,
          fit: BoxFit.fill,
        ));
  }

  Widget _emptyWidgets(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: context.height * 20),
        Text(
          'No messages yet... \nSend a message and start talking !',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: (context.width + context.height) / .7),
        ),
        Image.asset(
          'assets/gifs/emptyChatScreen.gif',
          width: 350,
          height: 300,
        )
      ],
    );
  }

  Widget _messagesList(BuildContext context) {
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: const Color(0xfff5a7a3),
      child: ListView(
        shrinkWrap: true,
        children: List.generate(10, (int index) => _messageBox(context)),
      ),
    );
  }

  Widget _messageBox(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: context.height * 11,
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(context.width * 5, context.height * 3,
            context.width * 20, context.height * 3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.primaryColor,
              context.lightPink,
            ],
          ),
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              topRight: Radius.circular(20)),
        ),
        child: _messageText(context),
      ),
    );
  }

  Padding _messageText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.width * 4, context.height * 2,
          context.width * 2, context.height),
      child: Column(
        children: [
          const AutoSizeText(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sed dictum dui, consequat tincidunt ante. Mauris in efficitur orci. Nam in sollicitudin leo. Mauris maximus ipsum leo, finibus pretium tortor molestie id. Curabitur vel mattis velit, sit amet volutpat libero. Aliquam in molestie ligula, vel volutpat mauris. Quisque euismod ultricies dolor ac pharetra. Duis nec iaculis nisi. Nunc laoreet venenatis diam, et porttitor urna venenatis at.',
            minFontSize: 20,
          ),
          const SizedBox(height: 5),
          _clock()
        ],
      ),
    );
  }

  Widget _clock() {
    return const Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(right: 5),
          child: Text('16:30'),
        ));
  }

  Material _bottomBar(BuildContext context) {
    return Material(
      elevation: 10,
      shadowColor: context.lightPink,
      child: Container(
          height: 78,
          color: Colors.white,
          child: Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: _textFormField(context),
                ),
              ),
              const SizedBox(width: 15),
              _sendButton(context),
              const SizedBox(width: 15)
            ],
          )),
    );
  }

  TextFormField _textFormField(BuildContext context) {
    return TextFormField(
      cursorColor: context.primaryDarkColor,
      autofocus: false,
      style: TextStyle(
          fontWeight: FontWeight.normal, color: context.primaryDarkColor),
      decoration: InputDecoration(
          hintText: 'Message...',
          hintStyle:
              TextStyle(color: context.primaryDarkColor.withOpacity(.4))),
    );
  }

  ElevatedButton _sendButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Icon(Icons.send, color: context.primaryDarkColor),
      ),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
        primary: context.canvasColor, // <-- Button color
        onPrimary: context.primaryColor, // <-- Splash color
      ),
    );
  }
}
