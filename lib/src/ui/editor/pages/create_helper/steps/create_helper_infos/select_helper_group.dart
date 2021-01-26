import 'package:flutter/material.dart';

import '../../create_helper_viewmodel.dart';

typedef HelperGroupLoader = Future<List<HelperGroupViewModel>> Function();

class SelectHelperGroupPage extends StatelessWidget {

  final HelperGroupLoader helperGroupLoader;

  SelectHelperGroupPage(this.helperGroupLoader);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose a group")),
      body: FutureBuilder<List<HelperGroupViewModel>>(
        future: helperGroupLoader(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.done
          ? !snapshot.hasData || snapshot.data.length == 0 ? _buildEmptyList () : _buildItems(snapshot.data)
          : _buildLoading(),
      ),
      // body: ,
    );
  }

  _buildLoading() => Center(child: CircularProgressIndicator());

  _buildEmptyList() => Center(child: Text("No helper group found on this page"));

  _buildItems(List<HelperGroupViewModel> data) => ListView.builder(
    itemBuilder: (context, index) => ListTile(
      title: Text(data[index].title),
    ),
    itemCount: data.length,
  );

}
