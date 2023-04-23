import 'package:darkstorm_common/top_inherit.dart';
import 'package:flutter/material.dart';

class Frame extends StatefulWidget{
  
  final Widget child;
  final bool beveled;
  final String appName;
  final List<Widget> navItems;
  final List<Widget> bottomNavItems;
  final Nav? floatingItem; 

  const Frame({
    super.key,
    required this.beveled,
    required this.appName,
    required this.navItems,
    required this.bottomNavItems,
    required this.child,
    this.floatingItem
  });

  @override
  State<StatefulWidget> createState() => FrameState();

  static FrameState of(BuildContext context) => context.findAncestorStateOfType<FrameState>()!;
}

class FrameState extends State<Frame> {

  bool vertical = false;
  bool expanded = false;
  bool hidden = true;
  double verticalTranslation = 0;

  String _selection = "";

  String get selection => _selection;
  set selection(String sel) =>
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        hidden =  sel.startsWith("/intro") || sel == "/loading";
        _selection = sel;
      });
    });

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
    var ti = TopInherited.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: ti.globalDuration,
              width: vertical ? media.size.width : 270,
              height: vertical ? (media.size.height / 2) : media.size.height,
              child: Column(
                children: [
                  Nav(
                    name: widget.appName,
                    icon: const Icon(Icons.menu),
                    onTap: () => setState(() => expanded = !expanded),
                    vertical: vertical,
                    expanded: expanded,
                    topItem: true,
                  ),
                  const Spacer(),
                  ...widget.navItems, //TODO: scroll
                  const Spacer(),
                  ...widget.bottomNavItems
                ],
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
  final Function() onTap;
  final bool vertical;
  final bool lastItem;
  final bool topItem;
  final bool expanded;
  final bool selected;

  const Nav({super.key,
      required this.icon,
      required this.name,
      required this.onTap,
      required this.vertical,
      required this.expanded,
      this.topItem = false,
      this.lastItem = false,
      this.selected = false});
  
  @override
  Widget build(BuildContext context) {
    var ti = TopInherited.of(context);
    var inner = AnimatedContainer(
      duration: ti.globalDuration,
      margin: (){
        EdgeInsets margin = vertical ? EdgeInsets.zero : const EdgeInsets.only(right: 20);
        if(vertical && (topItem && !expanded) || lastItem){
          margin = margin += const EdgeInsets.only(bottom: 20);
        }
        return margin;
      }(),
      // margin: vertical && ((topItem && !expanded) || lastItem) ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero,
      child: AnimatedAlign(
        duration: ti.globalDuration,
        alignment: expanded ? Alignment.center : Alignment.centerLeft,
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
                    margin: selected ? const EdgeInsets.symmetric(vertical: 3) : EdgeInsets.zero,
                    height: selected ? 2 : 0,
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
        onTap: onTap,
        child: inner,
      )
    );
  }
}