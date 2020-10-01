import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/services/pal/pal_state_service.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_loader.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_modal.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_modal_viewmodel.dart';

class HelpersListModalPresenter
    extends Presenter<HelpersListModalModel, HelpersListModalView> {
  final HelpersListModalLoader loader;
  final PalEditModeStateService palEditModeStateService;

  HelpersListModalPresenter(
    HelpersListModalView viewInterface, {
    @required this.loader,
    @required this.palEditModeStateService,
  }) : super(HelpersListModalModel(), viewInterface);

  @override
  Future onInit() async {
    this.viewModel.isLoading = true;
    this.viewModel.noMore = false;
    this.viewModel.loadingMore = false;

    this.loader.load().then((HelpersListModalModel res) {
      this.viewModel.helpers = res.helpers;
      this.viewModel.pageId = res.pageId;
      this.viewModel.isLoading = false;
      this.refreshView();
    });
  }

  void loadMore() {
    if (!this.viewModel.noMore && !this.viewModel.loadingMore) {
      this.viewModel.loadingMore = true;
      this.refreshView();

      this.loader.loadMore(this.viewModel.pageId).then((value) {
        if (value.isEmpty) {
          this.viewModel.noMore = true;
        } else {
          this.viewModel.helpers.addAll(value);
        }
        this.viewModel.loadingMore = false;
        this.refreshView();
      });
    }
  }

  setImage(ByteData byteData) {
    this.viewModel.imageBs = byteData.buffer.asUint8List();
    this.refreshView();
  }

  onClickAdd() async {
    showEditorBubble(false);
    this.viewInterface.openHelperCreationPage(this.viewModel.pageId);
    // showEditorBubble(true);
  }

  onClickSettings() async {
    showEditorBubble(false);
    this.viewInterface.openAppSettingsPage();
    // showEditorBubble(true);
  }

  showEditorBubble(bool visible) {
    this.palEditModeStateService.showEditorBubble.value = visible;
  }
}
