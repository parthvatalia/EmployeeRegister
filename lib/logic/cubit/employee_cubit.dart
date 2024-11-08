import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/employee.dart';
import '../../repository/employee_repository.dart';

class EmployeeCubit extends Cubit<List<Employee>> {
  final EmployeeRepository _repository;

  EmployeeCubit(this._repository) : super([]);

  Future<void> fetchEmployees() async {
    emit(await _repository.getEmployees());
  }

  List<Employee> get currentEmployees =>
      state.where((employee) => employee.isCurrentEmployee).toList();

  List<Employee> get previousEmployees =>
      state.where((employee) => !employee.isCurrentEmployee).toList();

  Future<void> addEmployee(Employee employee) async {
    await _repository.addEmployee(employee);
    fetchEmployees();
  }

  Future<void> updateEmployee(Employee employee) async {
    await _repository.updateEmployee(employee);
    fetchEmployees();
  }

  Future<void> deleteEmployee(int id) async {
    await _repository.deleteEmployee(id);
    fetchEmployees();
  }
}
