import 'package:darkstorm_common/ui/frame_content.dart';
import 'package:darkstorm_common/util/top_resources.dart';
import 'package:flutter/material.dart';

class SpeedDial extends StatefulWidget{

  final List<SpeedDialIcons> children;
  final Widget fabChild;

  const SpeedDial(
    {required super.key,
    required this.children,
    this.fabChild = const Icon(Icons.add),
  });

  @override
  State<StatefulWidget> createState() => SpeedDialState();
}

class SpeedDialState extends State<SpeedDial> with SingleTickerProviderStateMixin{
  bool _expanded = false;
  bool get expanded => _expanded;
  set expanded(bool b) {
    _expanded = b;
    if(_expanded){
      anim?.animateTo(1.0,
        duration: TopResources.of(context).globalDuration,
      );
    }else{
      anim?.animateBack(0,
        duration: TopResources.of(context).globalDuration,
      );
    }
    setState(() {});
  }

  AnimationController? anim;

  @override
  Widget build(BuildContext context) {
    anim ??= AnimationController(vsync: this);
    var ti = TopResources.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ...List.generate(
            widget.children.length,
            (i) => AnimatedPositioned(
              duration: ti.globalDuration,
              bottom: _expanded ? (50*(i+1)) + 18 : 8,
              right: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if(widget.children[i].label != null) AnimatedSwitcher(
                    duration: ti.globalDuration,
                    transitionBuilder: (child, animation) =>
                      SizeTransition(
                        axis: Axis.horizontal,
                        sizeFactor: animation,
                        child: child,
                      ),
                    child: _expanded ? Card(
                      color: Theme.of(context).canvasColor,
                      elevation: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.children[i].label!,
                        )
                      )
                    ) : null
                  ),
                  if(widget.children[i].label != null) AnimatedContainer(
                    duration: ti.globalDuration,
                    width: _expanded ? 10 : 0,
                  ),
                  widget.children[i],
                ]
              )
            )
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              expanded = !expanded;
              FrameContent.of(context).fabExtended = expanded;
            },
            child: RotationTransition(
              turns: Tween<double>(begin: 0, end: .375).animate(anim!),
              child: widget.fabChild,
            ),
          ),
        ],
      )
    );
  }
}

class SpeedDialIcons extends StatelessWidget{
  final String? label;
  final Widget? child;
  final Function() onPressed;

  const SpeedDialIcons({super.key, this.label, this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) =>
    FloatingActionButton.small(
      onPressed: (){
        onPressed();
        context.findAncestorStateOfType<SpeedDialState>()?.expanded = false;
        FrameContent.of(context).fabExtended = false;
      },
      heroTag: null,
      child: child,
    );
}