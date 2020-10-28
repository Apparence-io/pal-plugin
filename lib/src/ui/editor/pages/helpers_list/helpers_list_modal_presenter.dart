import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/services/editor/helper/helper_editor_service.dart';
import 'package:palplugin/src/services/pal/pal_state_service.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_loader.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_modal.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_modal_viewmodel.dart';

class HelpersListModalPresenter
    extends Presenter<HelpersListModalModel, HelpersListModalView> {
  final EditorHelperService helperService;
  final HelpersListModalLoader loader;
  final PalEditModeStateService palEditModeStateService;

  HelpersListModalPresenter(
    HelpersListModalView viewInterface, {
    @required this.loader,
    @required this.palEditModeStateService,
    @required this.helperService,
  }) : super(HelpersListModalModel(), viewInterface);

  @override
  Future onInit() async {
    this.load();
  }

  void load() {
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

  backupHelpersList() {
    this.viewModel.backupHelpers = List.from(this.viewModel.helpers);
  }

  removeHelper(final HelperEntity helper) {
    this.viewModel.helpers.remove(helper);
    this.refreshView();
  }

  sendNewHelpersOrder(
    int oldIndex,
    int newIndex,
  ) async {
    Map<String, int> priority = {};
    List<HelperEntity> modifiedHelpers;

    if (newIndex < oldIndex) {
      modifiedHelpers = this.viewModel.helpers.sublist(
            newIndex,
            oldIndex + 1,
          );
    } else {
      if (newIndex < this.viewModel.helpers.length) {
        newIndex++;
      }
      modifiedHelpers = this.viewModel.helpers.sublist(
            oldIndex,
            newIndex,
          );
    }
    for (var helper in modifiedHelpers) {
      priority.putIfAbsent(
        helper.id,
        () => this.viewModel.helpers.indexOf(helper),
      );
    }

    // Check if changing was succeded or not
    try {
      await this.helperService.updateHelperPriority(
            this.viewModel.pageId,
            priority,
          );
    } catch (error) {
      // There is an error, revert change
      this.viewModel.helpers = this.viewModel.backupHelpers;
      this.refreshView();
    }
  }
}
