import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/database/repository/editor/helper_editor_repository.dart';
import 'package:palplugin/src/services/editor/helper/helper_editor_models.dart';

abstract class EditorHelperService {
  factory EditorHelperService.build(EditorHelperRepository helperRepository) =>
      _EditorHelperHttpService(helperRepository);

  Future<Pageable<HelperEntity>> getPage(
      final String route, final int page, final int pageSize);

  Future<HelperEntity> createSimpleHelper(
      final String pageId, final CreateSimpleHelper createArgs);

  Future<HelperEntity> createFullScreenHelper(
      final String pageId, final CreateFullScreenHelper createArgs);

  Future<HelperEntity> createUpdateHelper(
      final String pageId, final CreateUpdateHelper createArgs);

  Future<void> updateHelperPriority(
    final String pageId,
    final Map<String, int> priority,
  );

  Future<void> deleteHelper(String pageId, String helperId);
}

class _EditorHelperHttpService implements EditorHelperService {
  final EditorHelperRepository _editorHelperRepository;

  _EditorHelperHttpService(this._editorHelperRepository);

  Future<HelperEntity> createSimpleHelper(
      final String pageId, final CreateSimpleHelper createArgs) {
    return _editorHelperRepository.createHelper(
      pageId,
      HelperEntity(
        name: createArgs.config.name,
        type: HelperType.SIMPLE_HELPER,
        triggerType: createArgs.config.triggerType,
        priority: createArgs.config.priority,
        versionMinId: createArgs.config.versionMinId,
        versionMaxId: createArgs.config.versionMaxId,
        pageId: pageId,
        helperTexts: [
          HelperTextEntity(
            fontColor: createArgs.fontColor,
            fontWeight: createArgs.fontWeight,
            fontSize: createArgs.fontSize,
            value: createArgs.title,
            fontFamily: createArgs.fontFamily,
            key: SimpleHelperKeys.CONTENT_KEY,
          )
        ],
        helperBoxes: [
          HelperBoxEntity(
            key: SimpleHelperKeys.BACKGROUND_KEY,
            backgroundColor: createArgs.backgroundColor,
          )
        ],
      ),
    );
  }

  @override
  Future<HelperEntity> createFullScreenHelper(
      String pageId, CreateFullScreenHelper createArgs) {
    if (createArgs.title == null || createArgs.description == null)
      throw "TITLE_AND_DESCRIPTION_REQUIRED";

    // Texts
    var helperTexts = [
      createArgs.title,
      createArgs.description,
      createArgs.positivButton,
      createArgs.negativButton
    ]
        .map((element) => element?.text != null
            ? HelperTextEntity(
                fontColor: element.fontColor,
                fontWeight: element.fontWeight,
                fontSize: element.fontSize,
                value: element.text,
                fontFamily: element.fontFamily,
              )
            : null)
        .toList();
    helperTexts[0].key = FullscreenHelperKeys.TITLE_KEY;
    helperTexts[1].key = FullscreenHelperKeys.DESCRIPTION_KEY;
    if (helperTexts[2] != null)
      helperTexts[2].key = FullscreenHelperKeys.POSITIV_KEY;
    if (helperTexts[3] != null)
      helperTexts[3].key = FullscreenHelperKeys.NEGATIV_KEY;
    helperTexts.removeWhere((element) => element == null);

    // Images
    var helperImages = [createArgs.topImageUrl]
        .map((mediaUrl) => (mediaUrl != null && mediaUrl.length > 0)
            ? HelperImageEntity(url: mediaUrl)
            : null)
        .toList();
    if (helperImages[0] != null)
      helperImages[0].key = FullscreenHelperKeys.IMAGE_KEY;
    helperImages.removeWhere((element) => element == null);

    return _editorHelperRepository.createHelper(
      pageId,
      HelperEntity(
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
            key: FullscreenHelperKeys.BACKGROUND_KEY,
            backgroundColor: createArgs.backgroundColor,
          )
        ],
        helperImages: helperImages,
      ),
    );
  }

  @override
  Future<HelperEntity> createUpdateHelper(
      String pageId, CreateUpdateHelper createArgs) {
    if (createArgs.title == null || createArgs.lines == null)
      throw "TITLE_AND_LINES_REQUIRED";
    var helperTexts =
        [createArgs.title, createArgs.positivButton, createArgs.negativButton]
            .map((element) => element?.text != null
                ? HelperTextEntity(
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
      helperTexts.add(HelperTextEntity(
          fontColor: element.fontColor,
          fontWeight: element.fontWeight,
          fontSize: element.fontSize,
          value: element.text,
          fontFamily: element.fontFamily,
          key:
              "${UpdatescreenHelperKeys.LINES_KEY}:${createArgs.lines.indexOf(element)}"));
    }

    // Images
    // TODO: Create function
    var helperImages = [createArgs.topImageUrl]
        .map((mediaUrl) => (mediaUrl != null && mediaUrl.length > 0)
            ? HelperImageEntity(url: mediaUrl)
            : null)
        .toList();
    if (helperImages[0] != null)
      helperImages[0].key = UpdatescreenHelperKeys.IMAGE_KEY;
    helperImages.removeWhere((element) => element == null);

    return _editorHelperRepository.createHelper(
      pageId,
      HelperEntity(
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
            key: UpdatescreenHelperKeys.BACKGROUND_KEY,
            backgroundColor: createArgs.backgroundColor,
          )
        ],
        helperImages: helperImages,
      ),
    );
  }

  @override
  Future<Pageable<HelperEntity>> getPage(
      String pageId, int page, int pageSize) {
    return this._editorHelperRepository.getPage(pageId, page, pageSize);
  }

  @override
  Future<void> updateHelperPriority(String pageId, Map<String, int> priority) {
    return this._editorHelperRepository.updateHelperPriority(pageId, priority);
  }

  @override
  Future<void> deleteHelper(String pageId, String helperId) {
    return this._editorHelperRepository.deleteHelper(pageId, helperId);
  }

  Future<HelperEntity> _createHelper(String pageId, HelperEntity createHelper) {
    //TODO: Get page Id
    // Create page Id if null
    // TODO: Get min version Id
    // Create max version Id if null
    // Create Helper with page Id & min version Id
    return _editorHelperRepository.createHelper(
      pageId,
      createHelper,
    );
  }
}
