import 'package:flutter/material.dart';

import '../../create_helper_viewmodel.dart';

typedef HelperLoader = Future<List<HelperSelectionViewModel>> Function();

class SelectHelperPage extends StatelessWidget {

  final HelperLoader helperLoader;

  SelectHelperPage(this.helperLoader);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose a group")),
      body: FutureBuilder<List<HelperSelectionViewModel>>(
        future: helperLoader(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.done
          ? !snapshot.hasData || snapshot.data.length == 0 ? _buildEmptyList () : _buildItems(snapshot.data)
          : _buildLoading(),
      ),
      // body: ,
    );
  }

  _buildLoading() => Center(child: CircularProgressIndicator());

  _buildEmptyList() => Center(child: Text("No helper group found on this page"));

  _buildItems(List<HelperSelectionViewModel> data) => ListView.builder(
    itemBuilder: (context, index) => ListTile(
      title: Text(data[index].title),
    ),
    itemCount: data.length,
  );

}
