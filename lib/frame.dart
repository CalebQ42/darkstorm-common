import 'package:darkstorm_common/nav.dart';
import 'package:darkstorm_common/top_resources.dart';
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
  ScrollController scrol = ScrollController();
  double _verticalTranslation = 0;

  bool _expanded = false;
  bool get expanded => _expanded;
  set expanded(bool e) {
    if(e == _expanded) return;
    if(!e && scrol.hasClients){
      scrol.animateTo(0, duration: TopResources.of(context).globalDuration, curve: Curves.linear);
    }
    setState(() => _expanded = e);
    updateItems();
  }

  bool _vertical = false;
  bool get vertical => _vertical;
  set vertical(bool v){
    if(_vertical != v){
      _vertical = v;
      updateItems();
    }
  }

  bool dialogShown = false;

  String _selection = "";
  String get selection => _selection;
  set selection(String sel) =>
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(sel == "BottomDialog"){
        setState(() {
          dialogShown = true;
          expanded = false;
        });
        return;
      }else if(dialogShown){
        setState(() => dialogShown = false);
      }
      if(sel == _selection || sel == "") return;
      setState(() => _selection = sel);
      updateItems();
    });

  String _title = "";
  set title(String t) {
    if(!widget.routeTitle) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _title = t);
    });
  }

  bool get hidden => _selection == "" ? true : widget.hideBar != null ? widget.hideBar!(_selection) : false;

  void updateItems(){
      for(var i in widget.navItems){
        (i.key! as GlobalKey<NavState>).currentState?.setState(() {});
      }
      for(var i in widget.bottomNavItems){
        (i.key! as GlobalKey<NavState>).currentState?.setState(() {});
      }
      if(widget.floatingItem != null){
        (widget.floatingItem!.key! as GlobalKey<FloatingNavState>).currentState?.setState((){});
      }
  }

  Future<bool> handleBackpress() async{
    if(_expanded){
      expanded = false;
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
    vertical ? Matrix4.translationValues(0, _verticalTranslation, 0) :
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
    if(vertical && media.size.width > 550) vertical = false;
    _verticalTranslation = (media.size.height / 2) - 50;
    var ti = TopResources.of(context);
    var navHeight = 50 + (widget.navItems.length * 50) + (widget.bottomNavItems.length * 50);
    if(!vertical && widget.floatingItem != null) navHeight += 50;
    var navExpand = 0.0;
    var verticalPadding = media.padding.top + media.padding.bottom + media.viewInsets.top + media.viewInsets.bottom;
    var horizontalPadding = media.padding.left + media.padding.right + media.viewInsets.left + media.viewInsets.right;
    if(vertical){
      navExpand = media.size.height/2 - navHeight - verticalPadding;
    }else{
      navExpand = media.size.height - navHeight - verticalPadding;
    }
    navExpand /= 2;
    if(navExpand < 0) navExpand = 0;
    var navItems = [
      topNav(ti),
      AnimatedContainer(
        duration: ti.transitionDuration,
        height: navExpand
      ),
      ...widget.navItems,
      AnimatedContainer(
        duration: ti.transitionDuration,
        height: navExpand
      ),
      if(widget.floatingItem != null && !vertical) widget.floatingItem!,
      ...widget.bottomNavItems
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            //Navigation
            Stack(
              children: [
                AnimatedContainer(
                  duration: ti.transitionDuration,
                  width: (vertical ? media.size.width : 270) - horizontalPadding,
                  height: (vertical ? (media.size.height / 2) : media.size.height) - verticalPadding,
                  child: ListView(
                    controller: scrol,
                    physics: (vertical && expanded) || !vertical ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                    children: navItems,
                  ),
                ),
                AnimatedSwitcher(
                  duration: ti.transitionDuration,
                  child: dialogShown ? GestureDetector(
                    onTap: () =>
                      ti.nav.pop(),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ) : null,
                )
              ]
            ),
            //Content
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
            ),
          ],
        )
      )
    );
  }

  Widget topNav(TopResources ti) {
    Widget inner = AnimatedContainer(
      duration: ti.globalDuration,
      margin: (){
        EdgeInsets margin = ti.frame.vertical ? EdgeInsets.zero : const EdgeInsets.only(right: 20);
        if(ti.frame.vertical && !ti.frame.expanded){
          margin += const EdgeInsets.only(bottom: 20);
        }
        return margin;
      }(),
      child: AnimatedAlign(
        duration: ti.globalDuration,
        alignment: ti.frame.expanded ? Alignment.center : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox.square(
              dimension: 50,
              child: Center(
                child: Icon(Icons.menu),
              )
            ),
            Text(_title == "" ? widget.appName : _title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ]
        )
      )
    );
    if(widget.floatingItem != null){
      inner = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: inner
          ),
          if(vertical) AnimatedSwitcher(
            duration: ti.globalDuration,
            transitionBuilder: (child, anim) =>
              SizeTransition(
                sizeFactor: anim,
                axis: Axis.horizontal,
                axisAlignment: -1.0,
                child: child
              ),
            child: !ti.frame.expanded ?
              widget.floatingItem : null
          )
        ],
      );
    }
    return SizedOverflowBox(
      alignment: Alignment.topLeft,
      size: const Size.fromHeight(50),
      child: InkResponse(
        highlightShape: BoxShape.rectangle,
        containedInkWell: true,
        onTap: () => expanded = !_expanded,
        child: inner,
      )
    );
  }
}