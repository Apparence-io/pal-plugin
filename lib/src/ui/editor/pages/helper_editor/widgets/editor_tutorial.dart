import 'package:flutter/material.dart';

class EditorTutorialOverlay extends StatefulWidget {

  final String title;
  final String content;
  final Function onPressDismiss;

  const EditorTutorialOverlay({Key key, 
    @required this.title, 
    @required this.content, 
    @required this.onPressDismiss}): super(key: key);
  
  @override
  _EditorTutorialOverlayState createState() => _EditorTutorialOverlayState();
}

class _EditorTutorialOverlayState extends State<EditorTutorialOverlay> with SingleTickerProviderStateMixin {

  AnimationController fadeAnimController;
  Animation<double> backgroundSizeAnimation;
  Animation<double> titleOpacityAnimation, titleSizeAnimation;
  Animation<double> contentOpacityAnimation, contentSizeAnimation;
  Animation<double> buttonOpacityAnimation, buttonSizeAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    fadeAnimController = AnimationController(
      vsync: this, 
      duration: Duration(seconds: 2)
    );
    backgroundSizeAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(0, .2, curve: Curves.easeIn),
    );
    titleOpacityAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(.2, .4, curve: Curves.easeIn),
    );
    titleSizeAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(.2, .8, curve: Curves.elasticOut),
    );
    contentOpacityAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(.4, .6, curve: Curves.easeIn),
    );
    contentSizeAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(.4, .8, curve: Curves.elasticOut),
    );
    buttonOpacityAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(.6, 1, curve: Curves.easeInOut),
    );
    buttonSizeAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(.8, 1, curve: Curves.elasticOut),
    );
    super.initState();
    fadeAnimController.forward();
  }

  @override
  void dispose() {
    fadeAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: backgroundSizeAnimation,
        builder: (context, child) => 
          Transform.translate(
            offset: Offset(0, 300 - (300 * backgroundSizeAnimation.value)),
            child: FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: 1/3,
              widthFactor: 1,
              child: child,
            ),
          ),
          child:  _buildInnerContainer(),
      ),
    );
  }

  Widget _buildInnerContainer() 
  => Container(
    decoration: BoxDecoration(
      color: Colors.black,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(),
              SizedBox(width: 24),
              Expanded(child: _buildTitle())
            ],
          ),
        ),
        _buildContent(),
        _buildButton(),
      ],
    ),
  );

  Widget _buildIcon() => AnimatedBuilder(
    animation: fadeAnimController, 
    builder: (context, child) => 
      Transform.scale(
        scale: titleSizeAnimation?.value ?? 0,
        child: Opacity(
          opacity: titleOpacityAnimation?.value ?? 0,
          child: child,
      ),
    ),
    child: Transform.translate(
      offset: Offset(0, -24),
      child: Image.asset(
        'assets/images/logo.png',
        height: 64.0,
        package: 'pal',
      ),
    ),
  ); 

  Widget _buildTitle() => AnimatedBuilder(
    animation: fadeAnimController, 
    builder: (context, child) => 
      Transform.scale(
        scale: titleSizeAnimation?.value ?? 0,
        child: Opacity(
          opacity: titleOpacityAnimation?.value ?? 0,
          child: child,
      ),
    ),
    child: Text(
      widget.title,
      style: TextStyle(
        color: Colors.white, 
        fontSize: 31,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat'
      ),
    ),
  );

  Widget _buildContent() 
    => Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
        child: AnimatedBuilder(
          animation: fadeAnimController,
          builder: (context, child) => 
            Transform.scale(
              scale: contentSizeAnimation?.value ?? 0,
              child: Opacity(
                opacity: contentOpacityAnimation?.value ?? 0,
                child: child,
            ),
          ),
          child: Text(
            widget.content,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat'
            ),
          ),
        ),
      ),
    );

  Widget _buildButton() 
    => Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: AnimatedBuilder(
        animation: fadeAnimController,
        builder: (context, child) => 
            Transform.scale(
              scale: buttonSizeAnimation?.value ?? 0,
              child: Opacity(
                opacity: buttonOpacityAnimation?.value ?? 0,
                child: child,
            ),
          ),
        child: OutlineButton(
          key: ValueKey("tutorialBtnDiss"),
          borderSide: BorderSide(color: Colors.white),
          onPressed: widget.onPressDismiss, 
          child: Text(
            "Ok",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat'
            ),
          )
        ),
      ),
    ); 
}