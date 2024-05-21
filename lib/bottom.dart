import 'package:darkstorm_common/top_resources.dart';
import 'package:flutter/material.dart';

class Bottom extends StatefulWidget{

  final List<Widget> Function(BuildContext)? buttons;
  final Widget? bottom;
  final Color? background;
  final Widget Function(BuildContext)? child;
  final List<Widget> Function(BuildContext)? children;
  final Widget Function(BuildContext, int, Animation<double>)? itemBuilder;
  final Alignment childAlignment;
  final int itemBuilderCount;
  final bool padding;
  final bool dismissible;
  final bool safeArea;

  final GlobalKey<_ButtonState> _butKey = GlobalKey();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  GlobalKey<AnimatedListState> get listKey => _listKey;


  Bottom({
    this.buttons,
    this.bottom,
    this.background,
    this.child,
    this.children,
    this.itemBuilder,
    this.childAlignment = Alignment.center,
    this.itemBuilderCount = 0,
    this.padding = true,
    this.dismissible = true,
    this.safeArea = false,
    super.key
  }){
    if(children == null && itemBuilder == null && child == null) throw Exception("Either child, children, or itemBuilder must be provided");
  }

  @override
  State<Bottom> createState() => BottomState();

  static BottomState? of(BuildContext context) => context.findAncestorStateOfType<BottomState>();

  void updateButtons() => _butKey.currentState?.refresh();
  
  void show(BuildContext context) =>
    showModalBottomSheet(
      routeSettings: const RouteSettings(name: "BottomDialog"),
      context: TopResources.of(context).nav.context,
      builder: (c) => this,
      backgroundColor: background,
      isScrollControlled: true,
      isDismissible: dismissible,
      useSafeArea: safeArea,
    );
}

class BottomState extends State<Bottom> {
  void update() {
    var oldLen = children?.length ?? 0;
    var netChange = updateChildren();
    if(netChange == 0){
      setState((){});
      return;
    }
    if(netChange < 0){
      for(var i = 0; i > netChange; i--){
        widget.listKey.currentState?.removeItem(oldLen-1+i, (context, animation) => SizeTransition(sizeFactor: animation), duration: Duration.zero);
      }
    }
    if(netChange > 0){
      for(var i = 0; i < netChange; i++){
        widget.listKey.currentState?.insertItem(children!.length+i-1, duration: Duration.zero);
      }
    }
  }
  List<Widget>? children;

  int updateChildren(){
    if(widget.itemBuilder != null) return 0;
    var oldLen = children?.length ?? 0;
    if(widget.children != null){
      children = widget.children!(context);
    }else if(widget.child != null){
      children = [widget.child!(context)];
    }
    return children!.length - oldLen;
  }

  @override
  Widget build(BuildContext context) {
    if(children == null) updateChildren();
    var child = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      child: Padding(
        padding: widget.padding ? const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: 15
        ) : EdgeInsets.zero,
        child: AnimatedList(
          key: widget.listKey,
          initialItemCount: widget.itemBuilder != null ? widget.itemBuilderCount : children!.length,
          shrinkWrap: true,
          itemBuilder: widget.itemBuilder ?? (context, i, anim) =>
            SizeTransition(
              sizeFactor: anim,
              child: Align(
                alignment: widget.childAlignment,
                child: children![i]
              )
            ),
        )
      )
    );
    return Wrap(
      children: [
        child,
        if(widget.buttons != null) _BottomButtons(
          key: widget._butKey,
          builder: widget.buttons!,
        ),
        if(widget.bottom != null) widget.bottom!,
      ],
    );
  }
}

class _BottomButtons extends StatefulWidget{
  final List<Widget> Function(BuildContext) builder;

  const _BottomButtons({required this.builder, super.key});

  @override
  State<StatefulWidget> createState() => _ButtonState();
}

class _ButtonState extends State<_BottomButtons>{

  void refresh() => setState((){});

  @override
  Widget build(BuildContext context) =>
    ButtonBar(
      alignment: MainAxisAlignment.end,
      children: widget.builder(context)
    );
}