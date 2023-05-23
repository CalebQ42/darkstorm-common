import 'package:darkstorm_common/top_inherit.dart';
import 'package:flutter/material.dart';

class Bottom extends StatefulWidget{

  final List<Widget> Function(BuildContext)? buttons;
  final Widget? bottom;
  final Color? background;
  final Widget Function(BuildContext)? child;
  final List<Widget> Function(BuildContext)? children;
  final Widget Function(BuildContext, int, Animation<double>)? itemBuilder;
  final int itemBuilderCount;
  final bool padding;
  final bool dismissible;
  final bool safeArea;

  final GlobalKey<_ButtonState> _butKey = GlobalKey();
  final GlobalKey<AnimatedListState> listKey = GlobalKey();


  Bottom({
    this.buttons,
    this.bottom,
    this.background,
    this.child,
    this.children,
    this.itemBuilder,
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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
        maxWidth: 600
      )
    );
}

class BottomState extends State<Bottom> {
  void update() => setState((){});

  @override
  Widget build(BuildContext context) {
    List<Widget>? children;
    if(widget.children != null) children = widget.children!(context);
    var child = Padding(
      padding: widget.padding ? const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
        bottom: 15
      ) : EdgeInsets.zero,
      child: widget.child != null ? widget.child!(context) : AnimatedList(
          key: widget.listKey,
          initialItemCount: widget.itemBuilder != null ? widget.itemBuilderCount : children!.length,
          shrinkWrap: true,
          itemBuilder: widget.itemBuilder ?? (context, i, anim) =>
            children![i]
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

  const _BottomButtons({required this.builder, Key? key}) : super(key: key);

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