import 'package:darkstorm_common/frame_content.dart';
import 'package:darkstorm_common/top_inherit.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  final List<IntroPage Function(BuildContext)> pages;
  final VoidCallback onDone;

  const IntroScreen({
    super.key,
    required this.pages,
    required this.onDone
  });

  @override
  State<IntroScreen> createState() => _IntroState();
}

class _IntroState extends State<IntroScreen> {
  int screen = 0;

  @override
  Widget build(BuildContext context) {
    var tr = TopResources.of(context);
    return FrameContent(
      child: WillPopScope(
        onWillPop: () async{
          if(screen != 0) setState(() => screen -= 1);
          return false;
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedSwitcher(
              duration: tr.globalDuration,
              child: SizedBox(
                key: ValueKey(screen),
                width: 600,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: widget.pages[screen](context),
                  )
                )
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: AnimatedSwitcher(
                duration: tr.globalDuration,
                transitionBuilder: (child, animation) =>
                  ScaleTransition(
                    scale: animation,
                    child: child
                  ),
                child: screen != 0 ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: FloatingActionButton(
                    heroTag: null,
                    child: const Icon(Icons.arrow_back),
                    onPressed: () =>
                      setState(() => screen--),
                  ),
                ) : null
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: FloatingActionButton(
                  child: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    if(screen >= widget.pages.length-1){
                      widget.onDone();
                    }else{
                      setState(() => screen++);
                    }
                  },
                ),
              ),
            )
          ],
        )
      )
    );
  }
}

class IntroPage extends StatefulWidget {
  final Widget title;
  final Widget? subtext;
  final List<Widget> Function(BuildContext)? items;
  final Widget Function(BuildContext)? body;

  const IntroPage({
    super.key,
    required this.title,
    this.subtext,
    this.items,
    this.body
  });

  @override
  IntroPageState createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  void update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    print("built");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DefaultTextStyle(
          style: Theme.of(context).textTheme.headlineLarge ?? const TextStyle(),
          child: widget.title
        ),
        if(widget.subtext != null) Container(height: 10),
        if(widget.subtext != null) DefaultTextStyle(
          style: Theme.of(context).textTheme.titleMedium ?? const TextStyle(),
          textAlign: TextAlign.justify,
          child: widget.subtext!
        ),
        if(widget.body != null || widget.items != null) Container(height: 20),
        if(widget.body != null) widget.body!(context),
        if(widget.items != null) ...widget.items!(context),
        Container(height: 60)
      ],
    );
  }
}