import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/init/extensions/extension_shelf.dart';
import '../../../core/base/base_view.dart';
import '../../../core/constants/navigation/string_constants.dart';
import '../../../core/helper/call.utilities.dart';
import '../../../core/init/extensions/context/responsive_extension.dart';
import '../../../core/init/extensions/context/theme_extension.dart';
import '../../../core/model/user.dart';
import '../../../core/provider/call_provider.dart';
import '../../../core/provider/message_provider.dart';
import '../../../core/provider/scroll_provider.dart';
import '../../../core/provider/socket_provider.dart';
import '../../../core/provider/user_provider.dart';
import '../call/pickup/pickup_layout.dart';
import 'chat_view_model.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ChatViewModel>(
        viewModel: ChatViewModel(),
        // ignore: unnecessary_lambdas
        onPageBuilder: (BuildContext context, ChatViewModel _model) =>
            PickupLayout(scaffold: _body(context, _model)),
        onModelReady: (model) {
          model.setContext(context);
          model.init();
        });
  }

  Scaffold _body(BuildContext context, ChatViewModel _model) {
    var userList =
        Provider.of<MessageProvider>(context, listen: false).userList;
    return Scaffold(
        appBar: _appBar(context, _model),
        body: Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                background(context),
                userList.isEmpty
                    ? _emptyWidgets(context, _model)
                    : _messagesList(context, _model),
              ],
            )),
            _bottomBar(context, _model)
          ],
        ));
  }

  AppBar _appBar(BuildContext context, ChatViewModel _model) {
    return AppBar(
      titleSpacing: 0,
      centerTitle: false,
      leading: _backButton(context, _model),
      title: _appBarTitle(context, _model),
      actions: [_videoCallButton(context, _model)],
    );
  }

  Widget _backButton(BuildContext context, ChatViewModel _model) {
    return Consumer<MessageProvider>(
      builder: (context, provider, child) {
        return IconButton(
            onPressed: () async {
              _model.isFirstMessage
                  ? await setFirstRecentlyUser(context, _model, provider)
                  : await setRecentlyMessages(context, _model);
            },
            icon: const Icon(Icons.arrow_back_ios));
      },
    );
  }

  Future<void> setRecentlyMessages(
      BuildContext context, ChatViewModel _model) async {
    await Provider.of<MessageProvider>(context, listen: false)
        .onlyMessageClear();
    var sender = Provider.of<UserProvider>(context, listen: false).user;
    log('user id${sender!.userId!}');
    var userList =
        Provider.of<MessageProvider>(context, listen: false).messagesUserList;

    for (var j = 0; j < userList.length; j++) {
      log(userList.length.toString());
      log(j.toString());
      await _model.databaseProvider
          .getMessages(userList[j], sender.userId!)
          .then((value) async {
        for (var i = 0; i < value.length; i++) {
          await Provider.of<MessageProvider>(context, listen: false)
              .setGetOnlyMessage(value[i].message ?? 'null');
          await _model.service
              .getUserDetails(userId: userList[i])
              .then((value) {
            Provider.of<MessageProvider>(context, listen: false)
                .setUser(User.fromJson(value.data()!));
          });
        }
      });
      log(Provider.of<MessageProvider>(context, listen: false)
          .getOnlyMessage
          .toString());
    }
    Navigator.pop(context);
  }

  setFirstRecentlyUser(BuildContext context, ChatViewModel _model,
      MessageProvider provider) async {
    await provider.onlyMessageClear();
    await provider.onlyMessageUserClear();
    await provider.userClear();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.refreshUser().then((value) async {
      log(userProvider.user!.userId!);
      await _model.databaseProvider
          .getUsers(userProvider.user!.userId!)
          .then((value) async {
        for (var i = 0; i < value.length; i++) {
          await provider.setMessagesUserList(value[i]);
        }
        var userList = provider.messagesUserList;

        for (var i = 0; i < userList.length; i++) {
          log(userList.length.toString());
          await _model.service
              .getUserDetails(userId: userList[i])
              .then((value) async {
            await provider.setUser(User.fromJson(value.data()!));
          });
          await _model.databaseProvider
              .getMessages(userList[i], userProvider.user!.userId!)
              .then((value) async {
            await provider.setGetOnlyMessage(value[0].message ?? 'null');
          });
        }
      });
    });
    Navigator.pop(context);
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

  Row _appBarTitle(BuildContext context, ChatViewModel _model) {
    var provider = Provider.of<CallProvider>(context, listen: false);
    return Row(
      children: [
        _avatar(context, provider, _model),
        const SizedBox(width: 10),
        Text(
          provider.userName ?? '',
          style: context.headline5,
        )
      ],
    );
  }

  Widget _avatar(
      BuildContext context, CallProvider provider, ChatViewModel _model) {
    var receiver = Provider.of<CallProvider>(context, listen: false).receiver;
    return ClipOval(
      child: Container(
        height: 50,
        width: 50,
        color: Provider.of<SocketProvider>(context)
                    .userList!
                    .contains(receiver!.userId) ==
                false
            ? Colors.grey
            : Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
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
        ),
      ),
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

  Widget _emptyWidgets(BuildContext context, ChatViewModel _model) {
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

  Widget _messagesList(BuildContext context, ChatViewModel _model) {
    var userList =
        Provider.of<MessageProvider>(context, listen: false).userList;
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: const Color(0xfff5a7a3),
      child: ListView(
        controller:
            Provider.of<ScrollProvider>(context, listen: false).controller,
        shrinkWrap: true,
        children: List.generate(userList.length,
            (int index) => _messageBox(context, _model, index)),
      ),
    );
  }

  Widget _messageBox(BuildContext context, ChatViewModel _model, int index) {
    var isMe = Provider.of<MessageProvider>(context, listen: false)
            .userList[index]
            .sender ==
        Provider.of<UserProvider>(context, listen: false).user!.userId;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: context.height * 11,
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(
            context.width * (isMe ? 20 : 5),
            context.height * 3,
            context.width * (isMe ? 5 : 20),
            context.height * 3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isMe
                ? [
                    const Color(0xff8785C0),
                    const Color(0xff97BFF6),
                  ]
                : [
                    context.primaryColor,
                    context.lightPink,
                  ],
          ),
          borderRadius: BorderRadius.only(
              bottomRight: const Radius.circular(20),
              bottomLeft: const Radius.circular(20),
              topRight: Radius.circular(isMe ? 0 : 20),
              topLeft: Radius.circular(isMe ? 20 : 0)),
        ),
        child: _messageText(context, _model, index, isMe),
      ),
    );
  }

  Widget _messageText(
      BuildContext context, ChatViewModel _model, int index, bool isMe) {
    return Consumer<MessageProvider>(
      builder: (context, value, child) {
        return Padding(
          padding: EdgeInsets.fromLTRB(context.width * 4, context.height * 2,
              context.width * 2, context.height),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: AutoSizeText(
                  value.userList[index].message ?? 'bos',
                  minFontSize: 20,
                  textAlign: TextAlign.left,
                  style: context.headline6.copyWith(
                      color: isMe ? Colors.white : context.primaryLightColor),
                ),
              ),
              const SizedBox(height: 5),
              _clock(context, _model, index)
            ],
          ),
        );
      },
    );
  }

  Widget _clock(BuildContext context, ChatViewModel _model, int index) {
    var userList =
        Provider.of<MessageProvider>(context, listen: false).userList;
    return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(userList[index].time ?? 'bos'),
        ));
  }

  Material _bottomBar(BuildContext context, ChatViewModel _model) {
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
                  child: _textFormField(context, _model),
                ),
              ),
              const SizedBox(width: 15),
              _sendButton(context, _model),
              const SizedBox(width: 15)
            ],
          )),
    );
  }

  TextFormField _textFormField(BuildContext context, ChatViewModel _model) {
    return TextFormField(
      onTap: () {
        Provider.of<ScrollProvider>(context, listen: false).scrollToBottom(300);
      },
      controller: _model.controller,
      cursorColor: context.primaryDarkColor,
      autofocus: false,
      style: TextStyle(
          fontWeight: FontWeight.normal, color: context.primaryDarkColor),
      decoration: InputDecoration(
          hintText: 'Messages...',
          hintStyle:
              TextStyle(color: context.primaryDarkColor.withOpacity(.4))),
    );
  }

  ElevatedButton _sendButton(BuildContext context, ChatViewModel _model) {
    var sender = Provider.of<UserProvider>(context, listen: false).user;
    var receiver = Provider.of<CallProvider>(context, listen: false).receiver;
    return ElevatedButton(
      onPressed: Provider.of<SocketProvider>(context)
                  .userList!
                  .contains(receiver!.userId) ==
              true
          ? () async {
              var now = DateTime.now();
              var time = DateFormat.Hm().format(now);
              _model.chatModel.sender = sender!.userId;
              _model.chatModel.receiver = receiver.userId;
              _model.chatModel.message = _model.controller.text.trim();
              _model.chatModel.time = time.toString();
              _model.saveModel().then((value) async {
                await Provider.of<SocketProvider>(context, listen: false)
                    .sendMessage(receiver.userId!, sender.userId!,
                        _model.controller.text);
                await Provider.of<MessageProvider>(context, listen: false)
                    .setMessage(receiver.userId!, sender.userId!);
                _model.controller.clear();
              });
            }
          : () async {
              showAlert(context);
            },
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

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: const Text("Gönderim izni yok."),
              content: const Text(
                "Güvenlik nedeni ile karşı taraf online olmadığı sürece gönderim yapılamaz.",
              ),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }
}
