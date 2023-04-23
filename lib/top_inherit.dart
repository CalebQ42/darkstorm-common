import 'dart:io';

import 'package:darkstorm_common/frame.dart';
import 'package:darkstorm_common/observatory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin TopInherited on InheritedWidget{
  final Duration globalDuration = const Duration(milliseconds: 300);

  late final Observatory _observatory = Observatory(this);
  final GlobalKey<FrameState> _frameKey = GlobalKey();
  final GlobalKey<NavigatorState> _navKey = GlobalKey();

  FrameState get frame => _frameKey.currentState!;
  NavigatorState get nav => _navKey.currentState!;
  GlobalKey<NavigatorState> get navKey => _navKey;
  Observatory get observatory => _observatory;

  bool get isMobile {
    if(kIsWeb){
      return false;
    }
    return Platform.isAndroid || Platform.isIOS;
  }

  static TopInherited of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<TopInherited>()!;
}