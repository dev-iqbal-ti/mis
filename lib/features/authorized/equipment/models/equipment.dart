class Equipment {
  final String id;
  final String name;
  final bool isAssigned;
  final String? assignedTo;
  final String? assignedDate;
  final String? projectName;
  final String? remark;
  final String? photoUrl;

  Equipment({
    required this.id,
    required this.name,
    this.isAssigned = false,
    this.assignedTo,
    this.assignedDate,
    this.projectName,
    this.remark,
    this.photoUrl,
  });

  Equipment copyWith({
    String? id,
    String? name,
    bool? isAssigned,
    String? assignedTo,
    String? assignedDate,
    String? projectName,
    String? remark,
    String? photoUrl,
  }) {
    return Equipment(
      id: id ?? this.id,
      name: name ?? this.name,
      isAssigned: isAssigned ?? this.isAssigned,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedDate: assignedDate ?? this.assignedDate,
      projectName: projectName ?? this.projectName,
      remark: remark ?? this.remark,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
