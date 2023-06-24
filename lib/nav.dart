import 'package:darkstorm_common/frame.dart';
import 'package:darkstorm_common/top_resources.dart';
import 'package:flutter/material.dart';

class Nav extends StatefulWidget{
  final Widget icon;
  final String name;
  final String routeName;
  //Only set to true if item is the last item in Frame.bottomNavItems
  final bool lastItem;

  Nav({
    required this.icon,
    required this.name,
    required this.routeName,
    this.lastItem = false
  }) : super(key: GlobalKey<NavState>());

  @override
  State<Nav> createState() => NavState();
}

class NavState extends State<Nav> {
  @override
  Widget build(BuildContext context) {
    var ti = TopResources.of(context);
    var inner = AnimatedContainer(
      duration: ti.globalDuration,
      margin: (){
        EdgeInsets margin = ti.frame.vertical ? EdgeInsets.zero : const EdgeInsets.only(right: 20);
        if(ti.frame.vertical && widget.lastItem){
          margin = margin += const EdgeInsets.only(bottom: 20);
        }
        return margin;
      }(),
      child: AnimatedAlign(
        duration: ti.globalDuration,
        alignment: ti.frame.expanded ? Alignment.center : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.icon,
                  AnimatedContainer(
                    duration: ti.globalDuration,
                    margin: ti.frame.selection == widget.routeName ? const EdgeInsets.symmetric(vertical: 3) : EdgeInsets.zero,
                    height: ti.frame.selection == widget.routeName ? 2 : 0,
                    width: 5,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
                      color: Colors.white
                    ),
                  )
                ]
              )
            ),
            Text(widget.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ]
        )
      )
    );
    return SizedOverflowBox(
      alignment: Alignment.topLeft,
      size: const Size.fromHeight(50),
      child: InkResponse(
        highlightShape: BoxShape.rectangle,
        containedInkWell: true,
        onTap: () {
          if(ti.observatory.currentRoute() == widget.routeName){
            return;
          }
          ti.nav.pushNamed(widget.routeName);
          Frame.of(context).title = widget.name;
          Frame.of(context).expanded = false;
        },
        child: inner,
      )
    );
  }
}

class FloatingNav extends StatefulWidget{
  final String title;
  final Widget icon;
  final void Function() onTap;

  FloatingNav({
    required this.title,
    required this.icon,
    required this.onTap
  }) : super(key: GlobalKey<FloatingNavState>());

  @override
  State<FloatingNav> createState() => FloatingNavState();
}

class FloatingNavState extends State<FloatingNav> {
  @override
  Widget build(BuildContext context) {
    var ti = TopResources.of(context);
    Widget child;
    if(ti.frame.vertical){
      child = SizedBox.square(
        dimension: 50,
        child: Center(
          child: widget.icon
        )
      );
    }else{
      child = AnimatedAlign(
        duration: ti.globalDuration,
        alignment: ti.frame.expanded ? Alignment.center : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 50,
              child: Center(
                child: widget.icon
              )
            ),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        )
      );
    }
    return InkResponse(
      onTap: widget.onTap,
      containedInkWell: true,
      highlightShape: BoxShape.rectangle,
      child: child,
    );
  }
}