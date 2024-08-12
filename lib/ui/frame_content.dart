import 'package:darkstorm_common/ui/frame.dart';
import 'package:darkstorm_common/ui/speed_dial.dart';
import 'package:darkstorm_common/util/top_resources.dart';
import 'package:flutter/material.dart';

class FrameContent extends StatefulWidget{

  final Widget? child;
  final bool allowPop;
  final Widget? fab;
  final GlobalKey<SpeedDialState>? speedDialKey;

  const FrameContent({
    super.key,
    this.child,
    this.allowPop = true,
    this.fab,
    this.speedDialKey
  });

  @override
  State<FrameContent> createState() => FrameContentState();

  static FrameContentState of(BuildContext context) => context.findAncestorStateOfType<FrameContentState>()!;
}

class FrameContentState extends State<FrameContent> {

  bool _fabExpanded = false;
  set fabExtended(bool b) {
    setState(() => _fabExpanded = b);
  }

  @override
  Widget build(BuildContext context) =>
    PopScope(
      canPop: widget.allowPop && !(widget.speedDialKey?.currentState?.expanded ?? false) && Frame.of(context).shouldPop,
      onPopInvokedWithResult: (b, res){
        if(b) return;
        if(!widget.allowPop) return;
        if(widget.speedDialKey?.currentState?.expanded ?? false){
          widget.speedDialKey?.currentState?.expanded = false;
        }else{
          Frame.of(context).handlePop();
        }
      },
      child: Material(
        elevation: 50.0,
        color: Theme.of(context).canvasColor,
        child: Stack(
          children: [
            widget.child ?? Container(),
            AnimatedSwitcher(
              duration: TopResources.of(context).globalDuration,
              transitionBuilder: (child, animation) =>
                FadeTransition(
                  opacity: animation,
                  child: child
                ),
              child: _fabExpanded ?
                GestureDetector(
                  onTap: () {
                    widget.speedDialKey?.currentState?.expanded = false;
                    fabExtended = false;
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(.25),
                  )
                ) : null,
            ),
            if(widget.fab != null) Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: widget.fab
              ),
            ),
          ]
        ),
      )
    );
}