import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';

class EditableMedia extends StatelessWidget {
  final EditableMediaFormData data;
  final double size;
  final Function(String) onTap;

  EditableMedia({
    Key key,
    this.size = 200.0,
    this.onTap,
    @required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onTap: () => this.onTap?.call(this.data.key),
      child: DottedBorder(
        dashPattern: [6, 3],
        color: Colors.white.withAlpha(80),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (this.data?.url != null && this.data.url.length > 0)
              ? CachedNetworkImage(
                  imageUrl: this.data?.url,
                  width: this.size,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(Icons.error),
                  ),
                )
              : Icon(
                  Icons.image,
                  size: this.size,
                  color: Colors.white.withAlpha(80),
                ),
        ),
      ),
    );
  }
}
