import 'dart:typed_data';

abstract class ProjectEditorService {

  factory ProjectEditorService.build() => ProjectEditorHttpService();

  Future sendAppIcon(Uint8List icon) => throw "not implemented yet";
}

class ProjectEditorHttpService implements ProjectEditorService {

  ProjectEditorHttpService();

  @override
  Future sendAppIcon(Uint8List icon) async {
    // TODO: Send icon to back using multipartImage
    List<int> data = icon.toList();
    print(data);
  }

}