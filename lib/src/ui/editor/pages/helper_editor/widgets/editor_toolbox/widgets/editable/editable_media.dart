import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox_viewmodel.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';

class EditableMedia extends StatefulWidget {
  final MediaNotifier mediaNotifier;
  final double mediaSize;
  final String url;
  final Function onEdit;
  final String editKey;
  final ValueNotifier<FormFieldNotifier> currentEditableItemNotifier;

  EditableMedia({
    Key key,
    this.url,
    this.mediaSize = 200.0,
    this.onEdit,
    this.mediaNotifier,
    @required this.currentEditableItemNotifier,
    @required this.editKey,
  }) : super(key: key);

  @override
  _EditableMediaState createState() => _EditableMediaState();
}

class _EditableMediaState extends State<EditableMedia> {
  @override
  void initState() {
    // TODO: Refacto en un seul TextStyle listener
    super.initState();
    widget.mediaNotifier.url.addListener(refreshView);
  }

  @override
  void dispose() {
    widget.mediaNotifier.url.removeListener(refreshView);

    super.dispose();
  }

  void refreshView() {
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onTap: () {
        this.widget.currentEditableItemNotifier.value =
            this.widget.mediaNotifier;
        // this.onEdit?.call();
      },
      child: DottedBorder(
        dashPattern: [6, 3],
        color: Colors.white.withAlpha(80),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (widget.mediaNotifier?.url?.value != null &&
                  widget.mediaNotifier.url.value.length > 0)
              ? CachedNetworkImage(
                  imageUrl: widget.mediaNotifier?.url?.value,
                  width: widget.mediaSize,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(Icons.error),
                  ),
                )
              : Icon(
                  Icons.image,
                  size: widget.mediaSize,
                  color: Colors.white.withAlpha(80),
                ),
        ),
      ),
    );
  }
}
