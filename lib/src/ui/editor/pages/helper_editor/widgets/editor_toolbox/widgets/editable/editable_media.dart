import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox_viewmodel.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';

class EditableMedia extends StatelessWidget {
  final double mediaSize;
  final String url;
  final Function onEdit;
  final String editKey;
  final ValueNotifier<CurrentEditableItem> currentEditableItemNotifier;

  EditableMedia({
    Key key,
    this.url,
    this.mediaSize = 200.0,
    this.onEdit,
    @required this.currentEditableItemNotifier,
    @required this.editKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onTap: () {
        this.currentEditableItemNotifier.value = CurrentEditableItem.media;
        this.onEdit?.call();
      },
      child: DottedBorder(
        dashPattern: [6, 3],
        color: Colors.white.withAlpha(80),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (url != null && url.length > 0)
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
        ),
      ),
    );
  }
}
