import 'package:darkstorm_common/top_inherit.dart';
import 'package:flutter/material.dart';

class Frame extends StatefulWidget{
  
  final Widget child;
  final bool beveled;
  //Set the selected Nav's name to the title when tapped.
  final bool routeTitle;
  final String appName;
  final List<Nav> navItems;
  final List<Nav> bottomNavItems;
  final FloatingNav? floatingItem; 
  //Checks the route name to know to hide the nav bar.
  final bool Function(String route)? hideBar;

  const Frame({
    super.key,
    required this.beveled,
    required this.appName,
    required this.navItems,
    required this.bottomNavItems,
    required this.child,
    this.hideBar,
    this.routeTitle = true,
    this.floatingItem
  });

  @override
  State<StatefulWidget> createState() => FrameState();

  static FrameState of(BuildContext context) => context.findAncestorStateOfType<FrameState>()!;
}

class FrameState extends State<Frame> {

  bool vertical = false;
  bool expanded = false;
  double verticalTranslation = 0;

  String _selection = "";
  String _title = "";

  String get selection => _selection;
  set selection(String sel) =>
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selection = sel;
      });
    });
  set title(String t) =>
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _title = t);
    });
  bool get hidden => widget.hideBar != null ? widget.hideBar!(_selection) : false;

  Future<bool> handleBackpress() async{
    if(expanded){
      setState(() => expanded = !expanded);
      return false;
    }
    return true;
  }

  ShapeBorder getBorder([BorderRadius br = BorderRadius.zero]){
    if(widget.beveled){
      return BeveledRectangleBorder(borderRadius: br);
    }
    return RoundedRectangleBorder(borderRadius: br);
  }

  ShapeBorder get shape =>
    hidden ? getBorder() :
    vertical ? getBorder(const BorderRadius.vertical(top: Radius.circular(20.0))) :
        getBorder(const BorderRadius.horizontal(left: Radius.circular(20.0)));
  EdgeInsets get contentMargin =>
    hidden ? EdgeInsets.zero : vertical ? const EdgeInsets.only(top: 50) :
        const EdgeInsets.only(left: 50);
  Matrix4? get transform => !expanded ? Matrix4.translationValues(0, 0, 0) :
    vertical ? Matrix4.translationValues(0, verticalTranslation, 0) :
        Matrix4.translationValues(200, 0, 0);
  ShapeBorder get topItemShape =>
    hidden ? getBorder() :
    vertical ? getBorder(const BorderRadius.vertical(top: Radius.circular(20.0))) :
        getBorder(const BorderRadius.only(topLeft: Radius.circular(20.0)));
  EdgeInsets get topItemMargin =>
    hidden ? EdgeInsets.zero : vertical ? const EdgeInsets.symmetric(horizontal: 20) :
        const EdgeInsets.only(left: 20);

  @override
  Widget build(BuildContext context){
    var media = MediaQuery.of(context);
    vertical = media.size.height > media.size.width;
    verticalTranslation = (media.size.height / 2) - 50;
    var ti = TopResources.of(context);
    var navHeight = 50 + (widget.navItems.length * 50) + (widget.bottomNavItems.length * 50);
    if(!vertical && widget.floatingItem != null) navHeight += 50;
    var navExpand = false;
    if(vertical){
      navExpand = navHeight < media.size.height/2;
    }else{
      navExpand = navHeight < media.size.height;
    }
    var navItems = [
      InkResponse(
        onTap: () => setState(() => expanded = !expanded),
        highlightShape: BoxShape.rectangle,
        containedInkWell: true,
        child: SizedOverflowBox(
          size: const Size.fromHeight(50),
          child: AnimatedContainer(
            duration: ti.globalDuration,
            margin: vertical && !expanded ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero,
            child: Row(
              children: [
                const SizedBox.square(
                  dimension: 50,
                  child: Center(
                    child: Icon(Icons.menu)
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: ti.globalDuration,
                    child: Text(
                      _title == "" ? widget.appName : _title,
                      key: ValueKey(_title == "" ? widget.appName : _title),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: ti.globalDuration,
                  transitionBuilder: (child, anim) =>
                    SizeTransition(
                      axis: Axis.horizontal,
                      axisAlignment: -1.0,
                      sizeFactor: anim,
                      child: child,
                    ),
                  child: widget.floatingItem != null && vertical ?
                    widget.floatingItem! : null
                )
              ],
            ),
          )
        )
      ),
      if(navExpand) const Spacer(),
      ...widget.navItems,
      if(navExpand) const Spacer(),
      if(widget.floatingItem != null && !vertical) widget.floatingItem!,
      ...widget.bottomNavItems
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: ti.globalDuration,
              width: vertical ? media.size.width : 270,
              height: vertical ? (media.size.height / 2) : media.size.height,
              child: navExpand ? Column(
                children: navItems,
              ) : ListView(
                children: navItems,
              ),
            ),
            AnimatedContainer(
              transform: transform,
              duration: ti.globalDuration,
              margin: contentMargin,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                shape: shape
              ),
              curve: Curves.easeIn,
              child: Stack(
                children:[
                  widget.child,
                  AnimatedSwitcher(
                    duration: ti.globalDuration,
                    child: expanded ? GestureDetector(
                      onTap: () => setState(() => expanded = false),
                      child: Container(
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ) : null,
                  ),
                ]
              )
            )
          ],
        )
      )
    );
  }
}

class Nav extends StatelessWidget{
  final Widget icon;
  final String name;
  final String routeName;
  //Only set to true if item is the last item in Frame.bottomNavItems
  final bool lastItem;

  const Nav({super.key,
      required this.icon,
      required this.name,
      required this.routeName,
      this.lastItem = false});
  
  @override
  Widget build(BuildContext context) {
    var ti = TopResources.of(context);
    var inner = AnimatedContainer(
      duration: ti.globalDuration,
      margin: (){
        EdgeInsets margin = ti.frame.vertical ? EdgeInsets.zero : const EdgeInsets.only(right: 20);
        if(ti.frame.vertical && lastItem){
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
                  icon,
                  AnimatedContainer(
                    duration: ti.globalDuration,
                    margin: ti.frame.selection == routeName ? const EdgeInsets.symmetric(vertical: 3) : EdgeInsets.zero,
                    height: ti.frame.selection == routeName ? 2 : 0,
                    width: 5,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
                      color: Colors.white
                    ),
                  )
                ]
              )
            ),
            Text(name,
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
        onTap: () => ti.nav.popAndPushNamed(routeName),
        child: inner,
      )
    );
  }
}

class FloatingNav extends StatelessWidget{
  final String title;
  final Widget icon;
  final void Function() onTap;

  const FloatingNav({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    var ti = TopResources.of(context);
    Widget child;
    if(ti.frame.vertical){
      child = SizedBox.square(
        dimension: 50,
        child: Center(
          child: icon
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
                child: icon
              )
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        )
      );
    }
    return InkResponse(
      onTap: onTap,
      containedInkWell: true,
      highlightShape: BoxShape.rectangle,
      child: child,
    );
  }
}