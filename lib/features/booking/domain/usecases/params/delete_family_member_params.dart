class DeleteFamilyMemberParams {
  final String id;

  const DeleteFamilyMemberParams({required this.id});

  DeleteFamilyMemberParams copyWith({String? id}) {
    return DeleteFamilyMemberParams(id: id ?? this.id);
  }
}
