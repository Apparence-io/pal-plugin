import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelperTileWidget extends StatelessWidget {
  final String name;
  final String trigger;
  final String versionMin;
  final String versionMax;
  final bool isDisabled;
  final Function onTapCallback;

  const HelperTileWidget({
    Key key,
    @required this.name,
    this.trigger,
    this.versionMax,
    this.versionMin,
    this.isDisabled,
    this.onTapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderRadius = 8.0;

    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2C77B6).withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      key: ValueKey('helperTileWidget'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              
              if (onTapCallback != null) {
                onTapCallback();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildEnabledIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                      ),
                      child: _buildInfos(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildVersions(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnabledIndicator() {
    return Container(
      width: 6.0,
      decoration: BoxDecoration(
        color: isDisabled ? Color(0xFFEB5160) : Color(0xFF3EB4D9),
      ),
    );
  }

  Widget _buildInfos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 13.0,
          ),
        ),
        SizedBox(
          height: 3.0,
        ),
        Text(
          trigger,
          style: TextStyle(
            fontSize: 9.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildVersions(
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Versions',
          style: TextStyle(
            fontSize: 9.0,
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 1.0,
        ),
        Text(
          '${versionMin ?? 'first'} - ${versionMax ?? 'last'}',
          style: TextStyle(
            fontSize: 9.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
