import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/injectors/user_app/user_app_injector.dart';
import 'package:pal/src/services/finder/finder_service.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';
import 'package:pal/src/ui/shared/utilities/element_finder.dart';

import 'anchored_helper_model.dart';

class AnchoredHelper extends StatefulWidget {
  final String anchorKey;
  final bool isTestingMode;

  final FinderService finderService;

  final Function onPositivButtonTap, onNegativButtonTap, onError;

  // ATTRIBUTES MODELS
  final HelperTextViewModel titleLabel;
  final HelperTextViewModel descriptionLabel;
  final HelperTextViewModel positivButtonLabel;
  final HelperTextViewModel negativButtonLabel;
  final HelperBoxViewModel helperBoxViewModel;

  factory AnchoredHelper.fromEntity({
    FinderService finderService,
    String anchorKey,
    @required HelperTextViewModel titleLabel,
    @required HelperTextViewModel descriptionLabel,
    @required HelperTextViewModel positivButtonLabel,
    @required HelperTextViewModel negativButtonLabel,
    @required HelperBoxViewModel helperBoxViewModel,
    Function onPositivButtonTap,
    Function onNegativButtonTap,
    Function onError,
    bool isTestingMode = false,
  }) =>
      AnchoredHelper(
          finderService,
          anchorKey,
          titleLabel,
          descriptionLabel,
          positivButtonLabel,
          negativButtonLabel,
          helperBoxViewModel,
          onPositivButtonTap,
          onNegativButtonTap,
          onError,
          isTestingMode);

  AnchoredHelper(
    this.finderService,
    this.anchorKey,
    this.titleLabel,
    this.descriptionLabel,
    this.positivButtonLabel,
    this.negativButtonLabel,
    this.helperBoxViewModel,
    this.onPositivButtonTap,
    this.onNegativButtonTap,
    this.onError,
    this.isTestingMode,
  );

  @override
  _AnchoredHelperState createState() => _AnchoredHelperState();
}

class _AnchoredHelperState extends State<AnchoredHelper>
    with TickerProviderStateMixin {
  Offset currentPos;

  Size anchorSize;

  Rect writeArea;

  FinderService finderService;

  AnimationController anchorAnimationController, fadeAnimController;

  Animation<double> backgroundAnimation;
  Animation<double> titleOpacityAnimation, titleSizeAnimation;
  Animation<double> descriptionOpacityAnimation, descriptionSizeAnimation;
  Animation<double> btnOpacityAnimation, btnSizeAnimation;

  @override
  void initState() {
    super.initState();
    anchorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..repeat(reverse: true);
    fadeAnimController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    backgroundAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(0, .4, curve: Curves.easeIn),
    );
    titleOpacityAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(.4, .5, curve: Curves.easeIn),
    );
    titleSizeAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(.4, .6, curve: Curves.easeInOutBack),
    );
    descriptionOpacityAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(.5, .6, curve: Curves.easeIn),
    );
    descriptionSizeAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(.5, .7, curve: Curves.easeInOutBack),
    );
    btnOpacityAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(.8, .9, curve: Curves.easeIn),
    );
    btnSizeAnimation = CurvedAnimation(
      parent: fadeAnimController,
      curve: Interval(.8, 1, curve: Curves.easeInOutBack),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void didChangeDependencies() {
    finderService =
        widget.finderService ?? UserInjector.of(context).finderService;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    anchorAnimationController.dispose();
    fadeAnimController.dispose();
    super.dispose();
  }

  Future init() async {
    // FIXME: Check a way to return an element on test environment
    // currently, searchChildElement() return an element with all null params inside
    // we use a testing mode bool to bypass this issue temporaly :/
    if (widget.isTestingMode == true) {
      anchorSize = Size(200, 200);
      currentPos = Offset.zero;
      writeArea = Rect.largest;
    } else {
      var element = await finderService.searchChildElement(widget.anchorKey);
      if (element == null || element.bounds == null) {
        widget.onError();
        return;
      }
      anchorSize = element.bounds.size;
      currentPos = element.offset;
      writeArea = await finderService.getLargestAvailableSpace(element);
    }

    setState(() {
      fadeAnimController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
              child: FadeTransition(
                  opacity: backgroundAnimation, child: _buildAnchorWidget())),
          Positioned.fromRect(
            rect: writeArea ?? Rect.largest,
            child: Center(
              child: SingleChildScrollView(
                // padding: const EdgeInsets.only(bottom: 50.0, top: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildAnimItem(
                          opacityAnim: titleOpacityAnimation,
                          sizeAnim: titleSizeAnimation,
                          child: _buildText(widget.titleLabel,
                              ValueKey('pal_AnchoredHelperTitleLabel'))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildAnimItem(
                          opacityAnim: descriptionOpacityAnimation,
                          sizeAnim: descriptionSizeAnimation,
                          child: _buildText(widget.descriptionLabel,
                              ValueKey('pal_AnchoredHelperDescriptionLabel'))),
                    ),
                    SizedBox(height: 24),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildAnimItem(
                              opacityAnim: btnOpacityAnimation,
                              sizeAnim: btnSizeAnimation,
                              child: _buildNegativFeedback()),
                          SizedBox(width: 16),
                          _buildAnimItem(
                              opacityAnim: btnOpacityAnimation,
                              sizeAnim: btnSizeAnimation,
                              child: _buildPositivFeedback()),
                        ])
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnchorWidget() => currentPos != null
      ? AnimatedAnchoredFullscreenCircle(
          currentPos: currentPos,
          anchorSize: anchorSize,
          bgColor: widget.helperBoxViewModel.backgroundColor,
          padding: 8,
          listenable: anchorAnimationController)
      : Container();

  Widget _buildText(HelperTextViewModel text, Key key) => Text(
        text.text,
        key: key,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: text.fontSize,
          fontWeight: text.fontWeight,
          color: text.fontColor,
          fontFamily: text.fontFamily,
        ),
      );

  Widget _buildNegativFeedback() {
    return OutlineButton(
      key: ValueKey("negativeFeedback"),
      borderSide: BorderSide(color: widget.negativButtonLabel.fontColor),
      onPressed: () async {
        await fadeAnimController.reverse();
        widget.onNegativButtonTap();
      },
      child: _buildText(widget.negativButtonLabel,
          ValueKey('pal_AnchoredHelperNegativFeedbackLabel')),
      // onTap: this.widget.onTrigger,
    );
  }

  Widget _buildPositivFeedback() {
    return OutlineButton(
      key: ValueKey("positiveFeedback"),
      borderSide: BorderSide(color: widget.positivButtonLabel.fontColor),
      onPressed: () async {
        await fadeAnimController.reverse();
        widget.onPositivButtonTap();
      },
      child: _buildText(widget.positivButtonLabel,
          ValueKey('pal_AnchoredHelperPositivFeedbackLabel')),
      // onTap: this.widget.onTrigger,
    );
  }

  Widget _buildAnimItem(
          {Animation<double> sizeAnim,
          Animation<double> opacityAnim,
          Widget child}) =>
      AnimatedBuilder(
        animation: fadeAnimController,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, -100 + ((sizeAnim?.value ?? 0) * 100)),
          child: Transform.scale(
            scale: sizeAnim?.value ?? 0,
            child: Opacity(
              opacity: opacityAnim?.value ?? 0,
              child: child,
            ),
          ),
        ),
        child: child,
      );
}

class AnimatedAnchoredFullscreenCircle extends AnimatedWidget {
  final Offset currentPos;
  final double padding;
  final Size anchorSize;
  final Color bgColor;

  final Animation<double> _stroke1Animation, _stroke2Animation;

  Animation<double> get _progress => this.listenable;

  AnimatedAnchoredFullscreenCircle(
      {@required this.currentPos,
      @required this.padding,
      @required this.bgColor,
      @required this.anchorSize,
      @required Listenable listenable})
      : _stroke1Animation =
            new CurvedAnimation(parent: listenable, curve: Curves.ease),
        _stroke2Animation = CurvedAnimation(
          parent: listenable,
          curve: Interval(0, .8, curve: Curves.ease),
        ),
        super(listenable: listenable);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: CustomPaint(
            painter: AnchoredFullscreenPainter(
      currentPos: currentPos,
      anchorSize: anchorSize,
      padding: padding,
      bgColor: bgColor,
      circle1Width: _stroke1Animation.value * 88,
      circle2Width: _stroke2Animation.value * 140,
    )));
  }
}

class AnchoredFullscreenPainter extends CustomPainter {
  final Offset currentPos;

  final double padding;

  final Size anchorSize;

  final double area = 24.0 * 24.0;

  final Color bgColor;

  double circle1Width, circle2Width;

  AnchoredFullscreenPainter({
    this.currentPos,
    this.anchorSize,
    this.padding = 0,
    this.bgColor,
    this.circle1Width = 64,
    this.circle2Width = 100,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint clearPainter = Paint()
      ..blendMode = BlendMode.clear
      ..isAntiAlias = true;
    Paint bgPainter = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    Paint circle1Painter = Paint()
      ..color = Colors.white.withOpacity(.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = circle1Width
      ..isAntiAlias = true;
    Paint circle2Painter = Paint()
      ..color = Colors.white.withOpacity(.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = circle2Width
      ..isAntiAlias = true;
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPainter);
    // canvas.drawCircle(currentPos, radius, clearPainter);
    // canvas.drawRect(currentPos & anchorSize, clearPainter);
    var radius = sqrt(pow(anchorSize.width, 2) + pow(anchorSize.height, 2)) / 2;
    var center =
        currentPos.translate(anchorSize.width / 2, anchorSize.height / 2);
    canvas.drawCircle(center, radius + padding, circle1Painter);
    canvas.drawCircle(center, radius + padding, circle2Painter);
    canvas.drawCircle(center, radius + padding, clearPainter);
    canvas.restore();
  }

  @override
  bool shouldRepaint(AnchoredFullscreenPainter oldDelegate) {
    return oldDelegate.currentPos != currentPos ||
        oldDelegate.circle1Width != circle1Width ||
        oldDelegate.circle2Width != circle2Width ||
        oldDelegate.bgColor != bgColor;
  }

  @override
  bool hitTest(Offset position) {
    if (currentPos == null) return false;
    var distance = (position - currentPos).distanceSquared;
    if (distance <= area) {
      return true;
    }
    return false;
  }
}
