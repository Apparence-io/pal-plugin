import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_loader.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal_viewmodel.dart';

class HelpersListModalPresenter
    extends Presenter<HelpersListModalModel, HelpersListModalView> {
  final HelpersListModalLoader loader;

  HelpersListModalPresenter(
    HelpersListModalView viewInterface, {
    @required this.loader,
  }) : super(HelpersListModalModel(), viewInterface);

  @override
  Future onInit() async {
    this.viewModel.isLoading = true;
    this.refreshView();

    this.loader.load().then((HelpersListModalModel res) {
      viewModel = res;
      this.viewModel.isLoading = false;
      this.refreshView();
    });
  }

  setImage(ByteData byteData) {
    this.viewModel.imageBs = byteData.buffer.asUint8List();
    this.refreshView();
  }
}
