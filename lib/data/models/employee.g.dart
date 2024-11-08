// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      position: json['position'] as String,
      joiningDate: DateTime.parse(json['joiningDate'] as String),
      leavingDate: json['leavingDate'] == null
          ? null
          : DateTime.parse(json['leavingDate'] as String),
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': instance.position,
      'joiningDate': instance.joiningDate.toIso8601String(),
      'leavingDate': instance.leavingDate?.toIso8601String(),
    };
