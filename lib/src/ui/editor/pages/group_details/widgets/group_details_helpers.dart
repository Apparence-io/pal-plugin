import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/group_details/group_details_model.dart';

typedef void OnEdit(String id, HelperType type);
typedef void OnPreview(String id);
typedef Future OnDelete(String id);

class GroupDetailsHelpersList extends StatelessWidget {
  // CORE ATTRIBUTES
  final ValueNotifier<List<HelperModel>> helpersList;
  final OnPreview onPreview;
  final OnEdit onEdit;
  final OnDelete onDelete;

  // STATE
  final bool loading;

  final ValueNotifier<int> expandedTile = ValueNotifier(null);

  GroupDetailsHelpersList({
    Key key,
    this.helpersList,
    @required this.onPreview,
    @required this.onEdit,
    @required this.onDelete,
    this.loading = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<HelperModel>>(
      valueListenable: this.helpersList,
      builder: (context, value, child) {
        if (value == null) {
          return Container(
            child: Center(
                child: CircularProgressIndicator(
              value: null,
            )),
          );
        } else {
          return value == null || value.length == 0 || loading
              ? Center(
                  child: Text('No helpers found.'),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return GroupDetailsHelperTile(
                      model: value[index],
                      index: ++index,
                      onDelete: this.onDelete,
                      onEdit: this.onEdit,
                      onPreview: this.onPreview,
                      expandedTile: this.expandedTile,
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                  ),
                  itemCount: value.length,
                );
        }
      },
    );
  }
}

// DRAGGABLE HELPER TILE

const double actionWidth = 50;
const double containerHeight = 85;
const double animationLowerBound = -actionWidth * 3;

class GroupDetailsHelperTile extends StatefulWidget {
  final OnPreview onPreview;
  final OnEdit onEdit;
  final OnDelete onDelete;

  final HelperModel model;

  final int index;

  final ValueNotifier<int> expandedTile;

  const GroupDetailsHelperTile(
      {Key key,
      this.onPreview,
      this.onEdit,
      this.onDelete,
      this.model,
      this.index,
      this.expandedTile})
      : super(key: key);

  @override
  _GroupDetailsHelperTileState createState() => _GroupDetailsHelperTileState();
}

class _GroupDetailsHelperTileState extends State<GroupDetailsHelperTile>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  bool deleting;

  @override
  void initState() {
    super.initState();

    this.deleting = false;

    this.controller = AnimationController(
        vsync: this, value: 0, lowerBound: animationLowerBound, upperBound: 0);

    widget.expandedTile.addListener(() {
      if (widget.expandedTile.value != widget.index)
        this.controller.animateTo(0,
            curve: Curves.easeOut, duration: Duration(milliseconds: 250));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _ActionWidget(
              key: ValueKey('PreviewHelperButton${widget.model.helperId}'),
              color: Color(0xFF3EB4D9),
              icon: Icons.play_arrow,
              text: 'Preview',
              onTap: () => widget.onPreview(widget.model.helperId),
            ),
            _ActionWidget(
              key: ValueKey('EditHelperButton${widget.model.helperId}'),
              color: Color(0xFF90E0EF),
              icon: Icons.edit,
              text: 'Edit',
              onTap: () =>
                  widget.onEdit(widget.model.helperId, widget.model.type),
            ),
            _ActionWidget(
              key: ValueKey('DeleteHelperButton${widget.model.helperId}'),
              color: Color(0xFFEB5160),
              icon: Icons.delete,
              text: 'Delete',
              onTap: () => this.setState(() {
                widget.onDelete(widget.model.helperId).catchError((onError) {
                  this.setState(() {
                    this.deleting = false;
                  });
                });
              }),
            ),
          ],
        ),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            this.controller.value = this.controller.value + details.delta.dx;
          },
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity > 0 ||
                this.controller.value > animationLowerBound / 2) {
              this.controller.animateTo(0,
                  curve: Curves.easeOutBack,
                  duration: Duration(milliseconds: 250));
            } else {
              this.controller.animateTo(this.controller.lowerBound,
                  curve: Curves.easeOutBack,
                  duration: Duration(milliseconds: 250));
              widget.expandedTile.value = widget.index;
            }
          },
          child: SizedBox(
            height: containerHeight + 1,
            child: AnimatedBuilder(
              animation: this.controller,
              builder: (context, child) => Card(
                margin: EdgeInsets.only(right: -this.controller.value),
                elevation: 8,
                shape: Border(),
                child: child,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                child: Row(
                  children: [
                    Image.asset(
                      "packages/pal/assets/images/create_helper/types/${helperTypeToAsset(widget.model.type)}",
                      height: containerHeight,
                    ),
                    VerticalDivider(
                      width: 40,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.model.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Divider(
                            height: 4,
                          ),
                          Text(
                            getHelperTypeDescription(widget.model.type),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 10),
                          ),
                          Divider(
                            height: 16,
                          ),
                          Text(
                            'Created on ${widget.model.creationDate.day} / ${widget.model.creationDate.month} / ${widget.model.creationDate.year}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w100, fontSize: 6),
                          )
                        ],
                      ),
                    ),
                    Text(widget.index.toString())
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Function onTap;

  const _ActionWidget({Key key, this.icon, this.text, this.color, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: actionWidth,
      height: containerHeight,
      color: this.color,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: this.onTap,
          splashColor: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                this.icon,
                size: 32,
              ),
              Divider(
                height: 14,
              ),
              Text(
                this.text,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// DRAGGABLE HELPER TILE
