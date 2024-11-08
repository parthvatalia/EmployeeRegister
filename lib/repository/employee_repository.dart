import '../data/models/employee.dart';
import '../data/local/employee_database.dart';

class EmployeeRepository {
  final EmployeeDatabase _database = EmployeeDatabase.instance;

  Future<List<Employee>> getEmployees() async =>
      await _database.fetchEmployees();

  Future<int> addEmployee(Employee employee) async =>
      await _database.addEmployee(employee);

  Future<int> updateEmployee(Employee employee) async =>
      await _database.updateEmployee(employee);

  Future<int> deleteEmployee(int id) async =>
      await _database.deleteEmployee(id);
}
