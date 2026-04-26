import 'package:equatable/equatable.dart';

class CommonQuestionEntity extends Equatable {
  final int? id;
  final String? question;
  final String? answer;

  const CommonQuestionEntity({required this.id, required this.question, required this.answer});
  @override
  List<Object?> get props => [];
}
