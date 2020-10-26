import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';

class HelperEntityMatcher extends Matcher {
  final HelperEntity expected;

  final bool testId;

  const HelperEntityMatcher({@required this.expected, this.testId = true}) : assert(expected != null);

  @override
  bool matches(dynamic actual, Map<dynamic, dynamic> matchState) {
    if (actual is HelperEntity) {
      if(testId && expected.id != actual.id) {
        matchState.putIfAbsent("id", () => "bad id");
        return false;
      }
      if(!checkTexts(actual, matchState))
        return false;
      if(!checkBoxes(actual, matchState))
        return false;
      return
        expected.creationDate == actual.creationDate &&
          expected.lastUpdateDate == actual.lastUpdateDate &&
          expected.name == actual.name &&
          expected.pageId == actual.pageId &&
          expected.priority == actual.priority &&
          expected.type == actual.type &&
          expected.triggerType == actual.triggerType &&
          expected.versionMinId == actual.versionMinId &&
          expected.versionMin == actual.versionMin &&
          expected.versionMaxId == actual.versionMaxId &&
          expected.versionMax == actual.versionMax;
    }
    return false;
  }

  bool checkTexts(HelperEntity other, Map<dynamic, dynamic> matchState) {
    print("first helper has ${expected.helperTexts.length} texts");
    print("second helper has ${other.helperTexts.length} texts");
    if(other.helperTexts == null && expected.helperTexts == null)
      return true;
    if(other.helperTexts.length != expected.helperTexts.length) {
      matchState.putIfAbsent("helperBoxes", () => "not same number of items");
      return false;
    }
    for(int i = 0; i < other.helperTexts.length; i++) {
      HelperTextEntity second = expected.helperTexts.elementAt(i);
      HelperTextEntity first = other.helperTexts.elementAt(i);
      print("[compare] '${first.value}' with '${second.value}' =>> ${first.value == second.value}");
      if(testId && first.id != second.id) {
        print("   ... not same id");
        return false;
      }
      if(first.fontSize != second.fontSize) {
        print("not same font size on element $i, ${first.fontSize} ${second.fontSize}");
        return false;
      }
      var isSame = first.fontColor == second.fontColor &&
        first.fontFamily == second.fontFamily &&
        first.fontWeight == second.fontWeight &&
        first.key == second.key &&
        first.value == second.value;
      if(!isSame) {
        print("   ... not same values");
        return false;
      }
    }
    return true;
  }

  bool checkBoxes(HelperEntity other, Map<dynamic, dynamic> matchState) {
    if(other.helperBoxes == null && expected.helperBoxes == null)
      return true;
    if(other.helperBoxes.length != expected.helperBoxes.length)
      return false;
    for(int i = 0; i< other.helperBoxes.length; i++) {
      HelperBoxEntity second = expected.helperBoxes.elementAt(i);
      HelperBoxEntity first = other.helperBoxes.elementAt(i);
      if(testId && first.id != second.id) {
        return false;
      }
      var isSame = first.backgroundColor == second.backgroundColor &&
        first.key == second.key;
      if(!isSame)
        return false;
    }
    return true;
  }

  @override
  Description describe(Description description) => description.add('matches HelperEntity $expected');
}