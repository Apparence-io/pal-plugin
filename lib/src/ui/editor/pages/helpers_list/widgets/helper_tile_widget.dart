import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelperTileWidget extends StatelessWidget {
  final String name;
  final String trigger;
  final String versionMin;
  final String versionMax;
  final bool isDisabled;
  final Function onTapCallback;
  final String type;

  const HelperTileWidget({
    Key key,
    @required this.name,
    this.type,
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
      height: 56.0,
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
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          children: [
            Text(
              type,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              '- ',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              trigger,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
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
          'Available versions',
          style: TextStyle(
            fontSize: 10.0,
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          children: [
            Text(
              '${versionMin ?? 'first'} ',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            Icon(
              Icons.arrow_forward,
              size: 10.0,
            ),
            Text(
              ' ${versionMax ?? 'last'}',
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
