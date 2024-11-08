import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee {
  int? id;
  String name;
  String position;
  DateTime joiningDate;
  DateTime? leavingDate;

  Employee(
      {this.id,
      required this.name,
      required this.position,
      required this.joiningDate,
      this.leavingDate});

  bool get isCurrentEmployee => leavingDate == null;

  String get formattedJoiningDate =>
      DateFormat('d MMM yyyy').format(joiningDate);

  String? get formattedLeaveDate => leavingDate != null
      ? DateFormat('d MMM yyyy').format(leavingDate!)
      : null;

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
