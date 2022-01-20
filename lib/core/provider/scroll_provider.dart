import 'dart:async';

import 'package:flutter/material.dart';

class ScrollProvider extends ChangeNotifier {
  ScrollController _controller = ScrollController();
  ScrollController get controller => _controller;

  scrollToBottom(int time) {
    Timer(Duration(milliseconds: time), () {
      _controller.hasClients
          ? _controller.jumpTo(controller.positions.last.maxScrollExtent)
          : null;
    });
    notifyListeners();
  }

  disposeScroll() {
    _controller.dispose();
    notifyListeners();
  }
}
