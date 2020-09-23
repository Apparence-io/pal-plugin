import 'package:flutter/material.dart';
import 'package:palplugin/src/ui/client/helper_client_models.dart';

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

class _UserUpdateHelperWidgetState extends State<UserUpdateHelperWidget> {
  double helperOpacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() => helperOpacity = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      opacity: helperOpacity,
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Container(
              color: Colors.green,
              child: Column(
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Image.asset(
                          'packages/palplugin/assets/images/create_helper.png',
                          key: ValueKey('palCreateHelperImage'),
                          // height: 282.0,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New title',
                            style: TextStyle(
                              fontSize: 31,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Version / 20',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        color: Colors.yellow,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              Text(
                                '- My first awesome feature',
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '- My second app awesome feature',
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '- My last app awesome feature I wanna be sure you are aware of',
                                textAlign: TextAlign.center,
                              ), 
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 10.0,
                      ),
                      child: RaisedButton(
                        onPressed: () {},
                        child: Text('Thank you!', style: TextStyle(
                          fontSize: 14,
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
