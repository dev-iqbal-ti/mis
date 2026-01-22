class MoneyRecord {
  final String id, projectName, amount, mode, remark, date;
  final String? imagePath;

  MoneyRecord({
    required this.id,
    required this.projectName,
    required this.amount,
    required this.mode,
    required this.remark,
    required this.date,
    this.imagePath,
  });
}
