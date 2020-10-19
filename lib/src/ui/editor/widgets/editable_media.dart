import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/shared/widgets/circle_button.dart';

class EditableMedia extends StatelessWidget {
  final double mediaSize;
  final String url;
  final Function onEdit;
  final String editKey;

  EditableMedia({
    Key key,
    this.url,
    this.mediaSize = 200.0,
    this.onEdit,
    @required this.editKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: [6, 3],
      color: Colors.white.withAlpha(80),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            (url != null && url.length > 0)
                ? CachedNetworkImage(
                    imageUrl: url,
                    width: mediaSize,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(Icons.error),
                    ),
                  )
                : Icon(
                    Icons.image,
                    size: mediaSize,
                    color: Colors.white.withAlpha(80),
                  ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: CircleIconButton(
                key: ValueKey(editKey),
                icon: Icon(Icons.edit),
                backgroundColor: PalTheme.of(context).colors.light,
                onTapCallback: () {
                  if (onEdit != null) {
                    HapticFeedback.selectionClick();
                    onEdit();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
