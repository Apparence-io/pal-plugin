import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/database/entity/pageable.dart';
import 'package:pal/src/database/repository/editor/helper_editor_repository.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';

abstract class EditorHelperService {
  
  factory EditorHelperService.build(EditorHelperRepository helperRepository) =>
      _EditorHelperHttpService(helperRepository);

  Future<Pageable<HelperEntity>> getPage(final String route, final int page, final int pageSize);

  /// saves a simple helper to our api
  /// providing [args.config.id] will makes an update
  Future<HelperEntity> saveSimpleHelper(final String pageId, final CreateSimpleHelper args);

  /// saves a fullscreen helper to our api
  /// providing [args.config.id] will makes an update
  Future<HelperEntity> saveFullScreenHelper(final String pageId, final CreateFullScreenHelper createArgs);

  /// saves an update helper to our api
  /// providing [args.config.id] will makes an update
  Future<HelperEntity> saveUpdateHelper(final String pageId, final CreateUpdateHelper createArgs);


  Future<void> updateHelperPriority(final String pageId, final Map<String, int> priority);

  Future<void> deleteHelper(String pageId, String helperId);
}

class _EditorHelperHttpService implements EditorHelperService {
  final EditorHelperRepository _editorHelperRepository;

  _EditorHelperHttpService(this._editorHelperRepository);

  // TODO: Move all _parse funcs into a factory ?
  HelperEntity _parseSimpleHelper(String pageId, CreateSimpleHelper createArgs) {
    return HelperEntity(
      id: createArgs.config.id,
      name: createArgs.config.name,
      type: HelperType.SIMPLE_HELPER,
      triggerType: createArgs.config.triggerType,
      priority: createArgs.config.priority,
      versionMinId: createArgs.config.versionMinId,
      versionMaxId: createArgs.config.versionMaxId,
      pageId: pageId,
      helperTexts: [
        HelperTextEntity(
          fontColor: createArgs.titleText?.fontColor,
          fontWeight: createArgs.titleText.fontWeight,
          fontSize: createArgs.titleText.fontSize,
          value: createArgs.titleText.text,
          fontFamily: createArgs.titleText.fontFamily,
          key: SimpleHelperKeys.CONTENT_KEY,
        )
      ],
      helperBoxes: [
        HelperBoxEntity(
          id: createArgs.boxConfig?.id,
          key: SimpleHelperKeys.BACKGROUND_KEY,
          backgroundColor: createArgs.boxConfig?.color,
        )
      ],
    );
  }

  HelperEntity _parseUpdateHelper(
    String pageId,
    CreateUpdateHelper createArgs,
  ) {
    if (createArgs.title == null || createArgs.lines == null)
      throw "TITLE_AND_LINES_REQUIRED";
    var helperTexts =
        [createArgs.title, createArgs.positivButton, createArgs.negativButton]
            .map((element) => element?.text != null
                ? HelperTextEntity(
                    id: element?.id,
                    fontColor: element.fontColor,
                    fontWeight: element.fontWeight,
                    fontSize: element.fontSize,
                    value: element.text,
                    fontFamily: element.fontFamily,
                  )
                : null)
            .toList();
    helperTexts[0].key = UpdatescreenHelperKeys.TITLE_KEY;
    if (helperTexts[1] != null)
      helperTexts[1].key = UpdatescreenHelperKeys.POSITIV_KEY;
    helperTexts.removeWhere((element) => element == null);
    for (var element in createArgs.lines) {
      helperTexts.add(
        HelperTextEntity(
          id: element?.id,
          fontColor: element.fontColor,
          fontWeight: element.fontWeight,
          fontSize: element.fontSize,
          value: element.text,
          fontFamily: element.fontFamily,
          key:
              "${UpdatescreenHelperKeys.LINES_KEY}:${createArgs.lines.indexOf(element)}",
        ),
      );
    }

    // Images
    // TODO: Create function
    var helperImages = [createArgs.headerMedia]
        .map((media) => (media?.url != null && media.url.length > 0)
            ? HelperImageEntity(
                id: media.id,
                url: media.url,
              )
            : null)
        .toList();
    if (helperImages[0] != null)
      helperImages[0].key = UpdatescreenHelperKeys.IMAGE_KEY;
    helperImages.removeWhere((element) => element == null);

    return HelperEntity(
      id: createArgs.config.id,
      name: createArgs.config.name,
      type: HelperType.UPDATE_HELPER,
      triggerType: createArgs.config.triggerType,
      priority: createArgs.config.priority,
      versionMinId: createArgs.config.versionMinId,
      versionMaxId: createArgs.config.versionMaxId,
      pageId: pageId,
      helperTexts: helperTexts,
      helperBoxes: [
        HelperBoxEntity(
          id: createArgs.bodyBox?.id,
          key: UpdatescreenHelperKeys.BACKGROUND_KEY,
          backgroundColor: createArgs.bodyBox.color,
        )
      ],
      helperImages: helperImages,
    );
  }

  HelperEntity _parseFullScreenHelper(
    String pageId,
    CreateFullScreenHelper createArgs,
  ) {
    if (createArgs.title == null || createArgs.description == null)
      throw "TITLE_AND_DESCRIPTION_REQUIRED";

    // Texts
    var helperTexts = [
      createArgs.title,
      createArgs.description,
      createArgs.positivButton,
      createArgs.negativButton
    ].map((element) => element?.text != null ? HelperTextEntity(
        id: element?.id,
        fontColor: element.fontColor,
        fontWeight: element.fontWeight,
        fontSize: element.fontSize,
        value: element.text,
        fontFamily: element.fontFamily,
      ) : null).toList();
    helperTexts[0].key = FullscreenHelperKeys.TITLE_KEY;
    helperTexts[1].key = FullscreenHelperKeys.DESCRIPTION_KEY;
    if (helperTexts[2] != null)
      helperTexts[2].key = FullscreenHelperKeys.POSITIV_KEY;
    if (helperTexts[3] != null)
      helperTexts[3].key = FullscreenHelperKeys.NEGATIV_KEY;
    helperTexts.removeWhere((element) => element == null);

    // Images
    var helperImages = [createArgs.mediaHeader]
        .map((media) => (media?.url != null && media.url.length > 0)
            ? HelperImageEntity(
                id: media.id,
                url: media.url,
              )
            : null)
        .toList();
    if (helperImages[0] != null)
      helperImages[0].key = FullscreenHelperKeys.IMAGE_KEY;
    helperImages.removeWhere((element) => element == null);

    return HelperEntity(
      id: createArgs.config.id,
      name: createArgs.config.name,
      type: HelperType.HELPER_FULL_SCREEN,
      triggerType: createArgs.config.triggerType,
      priority: createArgs.config.priority,
      versionMinId: createArgs.config.versionMinId,
      versionMaxId: createArgs.config.versionMaxId,
      pageId: pageId,
      helperTexts: helperTexts,
      helperBoxes: [
        HelperBoxEntity(
          id: createArgs.bodyBox?.id,
          key: FullscreenHelperKeys.BACKGROUND_KEY,
          backgroundColor: createArgs.bodyBox.color,
        )
      ],
      helperImages: helperImages,
    );
  }

  @override
  Future<HelperEntity> saveSimpleHelper(final String pageId, final CreateSimpleHelper createArgs)
    => createArgs.config.id != null
      ? _editorHelperRepository.updateHelper(pageId, _parseSimpleHelper(pageId, createArgs))
      : _editorHelperRepository.createHelper(pageId, _parseSimpleHelper(pageId, createArgs));


  @override
  Future<HelperEntity> saveFullScreenHelper(String pageId, CreateFullScreenHelper createArgs)
    => createArgs.config.id != null
      ? _editorHelperRepository.updateHelper(pageId, _parseFullScreenHelper(pageId, createArgs))
      : _editorHelperRepository.createHelper(pageId, _parseFullScreenHelper(pageId, createArgs));

  @override
  Future<HelperEntity> saveUpdateHelper(String pageId, CreateUpdateHelper createArgs)
    => createArgs.config.id != null
      ? _editorHelperRepository.updateHelper(pageId, _parseUpdateHelper(pageId, createArgs))
      : _editorHelperRepository.createHelper(pageId, _parseUpdateHelper(pageId, createArgs));

  @override
  Future<Pageable<HelperEntity>> getPage(String pageId, int page, int pageSize)
    => this._editorHelperRepository.getPage(pageId, page, pageSize);

  @override
  Future<void> updateHelperPriority(String pageId, Map<String, int> priority)
    => this._editorHelperRepository.updateHelperPriority(pageId, priority);

  @override
  Future<void> deleteHelper(String pageId, String helperId)
    => this._editorHelperRepository.deleteHelper(pageId, helperId);
}
