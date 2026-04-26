import 'package:alhakim/core/base_classes/base_list_response.dart';
import 'package:alhakim/features/settings/domain/entity/common_question_entity.dart';

class CommonQuestionsRespModel extends BaseListResponse {
  const CommonQuestionsRespModel({super.success, super.data});
  factory CommonQuestionsRespModel.fromJson(Map<String, dynamic> json) {
    return CommonQuestionsRespModel(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => CommonQuestionModel.fromJson(e))
                .toList()
          : [],
    );
  }
}

class CommonQuestionModel extends CommonQuestionEntity {
  const CommonQuestionModel({super.id, super.question, super.answer});
  factory CommonQuestionModel.fromJson(Map<String, dynamic> json) {
    return CommonQuestionModel(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}
