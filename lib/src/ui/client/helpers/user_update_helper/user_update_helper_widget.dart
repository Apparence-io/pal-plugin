import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/client/helper_client_models.dart';
import 'package:palplugin/src/ui/client/helpers/user_update_helper/widgets/release_note_tile.dart';

class UserUpdateHelperWidget extends StatefulWidget {
  final Color backgroundColor;
  final CustomLabel titleLabel;
  final List<CustomLabel> changelogLabels;
  final CustomLabel thanksButtonLabel;

  UserUpdateHelperWidget({
    Key key,
    @required this.backgroundColor,
    @required this.titleLabel,
    @required this.changelogLabels,
    this.thanksButtonLabel,
  })  : assert(backgroundColor != null),
        assert(titleLabel != null),
        assert(changelogLabels != null),
        super(key: key);

  @override
  _UserUpdateHelperWidgetState createState() => _UserUpdateHelperWidgetState();
}

class _UserUpdateHelperWidgetState extends State<UserUpdateHelperWidget>
    with SingleTickerProviderStateMixin {
  double helperOpacity = 0;
  String appVersion = '--';
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _readAppInfo();
    
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _controller.addStatusListener((status) {
      setState(() {});
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() => helperOpacity = 1);
      Future.delayed(Duration(milliseconds: 350), () {
        startAnimation();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future startAnimation() {
    return _controller.forward();
  }

  _readAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    this.appVersion = packageInfo?.version;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      opacity: helperOpacity,
      child: Scaffold(
        key: ValueKey('pal_UserUpdateHelperWidget_Scaffold'),
        backgroundColor: widget.backgroundColor,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Container(
              child: Column(
                children: [
                  Flexible(
                    key: ValueKey('pal_UserUpdateHelperWidget_Icon'),
                    flex: 4,
                    child: buildIcon(),
                  ),
                  Flexible(
                    key: ValueKey('pal_UserUpdateHelperWidget_AppSummary'),
                    flex: 2,
                    child: buildAppSummary(),
                  ),
                  Expanded(
                    key: ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes'),
                    flex: 5,
                    child: _buildReleaseNotes(),
                  ),
                  buildThanksButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildIcon() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Image.asset(
          'packages/palplugin/assets/images/create_helper.png',
          key: ValueKey('pal_UserUpdateHelperWidget_Icon_Image'),
          // height: 282.0,
        ),
      ),
    );
  }

  Container buildAppSummary() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.titleLabel?.text ?? 'New application update',
            key: ValueKey('pal_UserUpdateHelperWidget_AppSummary_Title'),
            style: TextStyle(
              fontSize: widget.titleLabel?.fontSize ?? 27.0,
              fontWeight: FontWeight.bold,
              color: widget.titleLabel?.fontColor ??
                  PalTheme.of(context).colors.light,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Version $appVersion',
            key: ValueKey('pal_UserUpdateHelperWidget_AppSummary_Version'),
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildThanksButton() {
    return SizedBox(
      key: ValueKey('pal_UserUpdateHelperWidget_ThanksButton'),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 15.0,
        ),
        child: RaisedButton(
          key: ValueKey('pal_UserUpdateHelperWidget_ThanksButton_Raised'),
          color: PalTheme.of(context).colors.dark,
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              widget.thanksButtonLabel?.text ?? 'Thank you !',
              style: TextStyle(
                fontSize: widget.thanksButtonLabel?.fontSize ?? 18.0,
                color: widget.thanksButtonLabel?.fontColor ?? Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView _buildReleaseNotes() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27.0),
          child: Column(
            key: ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List'),
            children: _buildReleaseNotesLabels(),
            // children: _buildReleaseNotesLabels(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildReleaseNotesLabels() {
    List<Widget> labels = [];
    int index = 0;
    for (CustomLabel label in widget.changelogLabels) {
      var stepTime = 1.0 / widget.changelogLabels.length;
      var animationStart = stepTime * index;
      var animationEnd = stepTime + animationStart;
      // var label = widget.changelogLabels[index];
      Widget textLabel = Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ReleaseNoteTile(
          index: index++,
          text: label?.text,
          fontColor: label?.fontColor,
          fontSize: label?.fontSize,
          animationController: _controller,
          animationStart: animationStart,
          animationEnd: animationEnd,
        ),
      );
      labels.add(textLabel);
    }
    return labels;
  }

  Widget _buildReleaseNoteLabel(
    CustomLabel label,
    int index,
  ) {
    Color fontColor = label?.fontColor ?? Colors.white;
    double fontSize = label?.fontSize ?? 15.0;

    return RichText(
      key: ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List_$index'),
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '•  ',
        style: TextStyle(
          color: fontColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
        ),
        children: <TextSpan>[
          TextSpan(
            text: label?.text,
            style: TextStyle(
              color: fontColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
