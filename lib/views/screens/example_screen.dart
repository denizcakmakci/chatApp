import 'dart:async';
import 'dart:developer';
import 'dart:io';

// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/init/extensions/extension_shelf.dart';
import '../../core/constants/navigation/navigation_constants.dart';
import '../../core/enums/local_manager_keys.dart';
import '../../core/helper/premissions.dart';
import '../../core/init/cache/locale_manager.dart';
import '../../core/init/language/lang_manager.dart';
import '../../core/init/navigation/navigation_service.dart';
import '../../core/model/chat.dart';
import '../../core/model/user.dart';
import '../../core/provider/call_provider.dart';
import '../../core/provider/message_provider.dart';
import '../../core/provider/scroll_provider.dart';
import '../../core/provider/socket_provider.dart';
import '../../core/provider/user_provider.dart';
import '../../core/services/firebase/database_service.dart';
import '../../core/services/sqflite/chat_database_provider.dart';
import '../widgets/custom_list_tile.dart';
import 'call/pickup/pickup_layout.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  var model = ChatModel();
  var databaseProvider = ChatDatabaseProvider();
  DatabaseService service = DatabaseService();

  @override
  void dispose() {
    Provider.of<ScrollProvider>(context, listen: false).disposeScroll();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser().then((value) async {
        log(userProvider.user!.userId!);
        await Provider.of<SocketProvider>(context, listen: false)
            .registerUser(userProvider.user!.userId!);

        databaseProvider
            .getUsers(userProvider.user!.userId!)
            .then((value) async {
          for (var i = 0; i < value.length; i++) {
            await Provider.of<MessageProvider>(context, listen: false)
                .setMessagesUserList(value[i]);
          }
          var userList = Provider.of<MessageProvider>(context, listen: false)
              .messagesUserList;

          for (var i = 0; i < userList.length; i++) {
            await service
                .getUserDetails(userId: userList[i])
                .then((value) async {
              await Provider.of<MessageProvider>(context, listen: false)
                  .setUser(User.fromJson(value.data()!));
            });
            await databaseProvider
                .getMessages(userList[i], userProvider.user!.userId!)
                .then((value) async {
              await Provider.of<MessageProvider>(context, listen: false)
                  .setGetOnlyMessage(value[0].message ?? 'null');
            });
          }
        });
      });
      Provider.of<SocketProvider>(context, listen: false).onSocket();
      await getMessageAddDatabase();
    });
  }

  getMessageAddDatabase() {
    Provider.of<SocketProvider>(context, listen: false)
        .socket
        .on('receiveMessage', (data) async {
      var now = DateTime.now();
      var time = DateFormat.Hm().format(now);
      var sender = Provider.of<UserProvider>(context, listen: false).user;
      var receiver = Provider.of<CallProvider>(context, listen: false).receiver;
      log(data.toString());
      model.receiver = data['receiverId'];
      model.sender = data['senderId'];
      model.message = data['message'];
      model.time = time;
      databaseProvider.insertItem(model);
      log('added database');
      await Provider.of<MessageProvider>(context, listen: false)
          .setMessage(receiver!.userId!, sender!.userId!);
      await Provider.of<ScrollProvider>(context, listen: false)
          .scrollToBottom(300);
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
  //     var userProvider = Provider.of<UserProvider>(context, listen: false);
  //     userProvider.refreshUser().then((value) async {
  //       log(userProvider.user!.userId!);
  //       await Provider.of<SocketProvider>(context, listen: false)
  //           .registerUser(userProvider.user!.userId!);
  //       databaseProvider
  //           .getUsers(userProvider.user!.userId!)
  //           .then((value) async {
  //         for (var i = 0; i < value.length; i++) {
  //           await Provider.of<MessageProvider>(context, listen: false)
  //               .setMessagesUserList(value[i]);
  //         }
  //         log('user id${userProvider.user!.userId!}');
  //         var userList = Provider.of<MessageProvider>(context, listen: false)
  //             .messagesUserList;

  //         for (var j = 0; j < userList.length; j++) {
  //           await databaseProvider
  //               .getMessages(userList[j], userProvider.user!.userId!)
  //               .then((value) async {
  //             for (var i = 0; i < value.length; i++) {
  //               log(value.length.toString());
  //               await Provider.of<MessageProvider>(context, listen: false)
  //                   .setGetOnlyMessage(value[i].message ?? 'null');
  //               log(i.toString());
  //               await service
  //                   .getUserDetails(userId: userList[i])
  //                   .then((value) async {
  //                 await Provider.of<MessageProvider>(context, listen: false)
  //                     .setUser(User.fromJson(value.data()!));
  //               });
  //             }
  //           });
  //           log(Provider.of<MessageProvider>(context, listen: false)
  //               .getOnlyMessage
  //               .toString());
  //         }
  //       });
  //     });
  //     Provider.of<SocketProvider>(context, listen: false).onSocket();
  //     await getMessageAddDatabase();
  //   });
  // }

  navigateChatScreen() {
    navigation.navigateToPage(path: NavigationConstants.chat);
  }

  NavigationService navigation = NavigationService.instance;
  Permissions per = Permissions();

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: WillPopScope(
            onWillPop: () async => exit(0),
            child: Scaffold(
                appBar: _appBar(),
                floatingActionButton: _floatingActionButton(context),
                body:
                    Provider.of<MessageProvider>(context).getOnlyMessage.isEmpty
                        ? _emptyWidget(context)
                        : ListView.builder(
                            itemCount: Provider.of<MessageProvider>(context)
                                .getOnlyMessage
                                .length,
                            itemBuilder: recentlyMessages,
                          ))));
  }

  ListView _emptyWidget(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: context.height * 5),
        Image.asset(
          'assets/gifs/noMessage.gif',
          width: 300,
          height: 300,
        ),
        SizedBox(height: context.height * 2),
        Text(
          'No messages yet... \nSend a message and start talking !',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: (context.width + context.height) / .7),
        ),
      ],
    );
  }

  Widget recentlyMessages(BuildContext context, int index) {
    return Column(
      children: [
        SizedBox(height: context.height),
        CustomListTile(
          title: Provider.of<MessageProvider>(
                context,
              ).user[index].name ??
              '',
          subTitle: Provider.of<MessageProvider>(context).getOnlyMessage[index],
          image: Provider.of<MessageProvider>(context, listen: false)
              .user[index]
              .photoUrl,
          onTap: () async {
            var provider = Provider.of<CallProvider>(context, listen: false);
            var receiverUser =
                Provider.of<MessageProvider>(context, listen: false)
                    .user[index];
            provider.setReceiverUser(
                receiverUser.userId ?? '',
                receiverUser.name ?? '',
                receiverUser.photoUrl ?? '',
                receiverUser.phoneNumber ?? '');
            await provider.setUserName(receiverUser.name ?? '');
            await provider.setphotoUrl(receiverUser.photoUrl ?? '');
            navigateChatScreen();
          },
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          'Secret',
          style: context.headline3.copyWith(
              fontSize: (context.width + context.height) / .5,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
      ),
      actions: [_langChangeButton()],
      automaticallyImplyLeading: false,
    );
  }

  TextButton _langChangeButton() {
    return TextButton(
        onPressed: () {
          context.locale.languageCode == 'en'
              ? context.setLocale(LanguageManager.instance.trLocale)
              : context.setLocale(LanguageManager.instance.enLocale);
          LocaleManager.instance.setStringValue(
              LocalManagerKeys.lang, context.locale.languageCode);
          log(context.locale.languageCode);
        },
        child: Text(
          context.locale.languageCode.translate,
          style: TextStyle(
              color: context.primaryDarkColor,
              fontWeight: FontWeight.w500,
              fontSize: (context.width + context.height) / .7),
        ));
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: _floatButtonOnPressed,
      child: _buttonIcon(context),
      backgroundColor: context.primaryColor,
    );
  }

  Icon _buttonIcon(BuildContext context) {
    return Icon(
      Icons.group_sharp,
      color: context.primaryDarkColor,
    );
  }

  Future<void> _floatButtonOnPressed() async {
    {
      await per.contactPermissionsGranted()
          ? navigation.navigateToPage(path: NavigationConstants.contacts)
          : null;
    }
  }
}
