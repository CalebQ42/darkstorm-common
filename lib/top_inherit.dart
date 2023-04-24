import 'dart:io';

import 'package:darkstorm_common/frame.dart';
import 'package:darkstorm_common/observatory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin TopResources{
  Duration globalDuration = const Duration(milliseconds: 300);

  late final Observatory _observatory = Observatory(this);
  final GlobalKey<FrameState> _frameKey = GlobalKey();
  final GlobalKey<NavigatorState> _navKey = GlobalKey();

  FrameState get frame => _frameKey.currentState!;
  NavigatorState get nav => _navKey.currentState!;
  GlobalKey<NavigatorState> get navKey => _navKey;
  GlobalKey<FrameState> get frameKey => _frameKey;
  Observatory get observatory => _observatory;

  bool get isMobile {
    if(kIsWeb){
      return false;
    }
    return Platform.isAndroid || Platform.isIOS;
  }

  static TopResources of(BuildContext context) => context.getInheritedWidgetOfExactType<TopInherit>()!.resources;
}

class TopInherit extends InheritedWidget{
  final TopResources resources;

  const TopInherit({super.key, required this.resources, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}