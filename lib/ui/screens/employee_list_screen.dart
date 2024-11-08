import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/employee.dart';
import '../../logic/cubit/employee_cubit.dart';
import '../screens/employee_form_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:employeeregister/utils/app_strings.dart';
import 'package:employeeregister/utils/app_colors.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late final EmployeeCubit _employeeCubit;
  Employee? _deletedEmployee;

  @override
  void initState() {
    super.initState();
    _employeeCubit = context.read<EmployeeCubit>();
  }

  void _handleUndo() {
    if (_deletedEmployee != null) {
      _employeeCubit.addEmployee(_deletedEmployee!);
      _deletedEmployee = null;
    }
  }

  void _handleDelete(Employee employee) {
    _deletedEmployee = employee;
    _employeeCubit.deleteEmployee(employee.id!);

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(AppStrings.deleteMessage),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: AppStrings.undoLabel,
            textColor: AppColors.blue,
            onPressed: _handleUndo,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.statusBarColor,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: AppColors.appColor,
        title: Text(
          AppStrings.employeeListTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
      ),
      body: BlocBuilder<EmployeeCubit, List<Employee>>(
        builder: (context, employees) {
          final currentEmployees = _employeeCubit.currentEmployees;
          final previousEmployees = _employeeCubit.previousEmployees;

          if (employees.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/svg/noRecordsFound.svg"),
                  const Text(
                    AppStrings.noRecordsMessage,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            children: [
              if (currentEmployees.isNotEmpty) ...[
                _buildEmployeeSectionTitle(AppStrings.currentEmployees),
                _buildEmployeeList(currentEmployees),
              ],
              if (previousEmployees.isNotEmpty) ...[
                _buildEmployeeSectionTitle(AppStrings.previousEmployees),
                _buildEmployeeList(previousEmployees),
              ],
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12).r,
                child: Text(
                  AppStrings.swipeDeleteMessage,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryTextColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.appColor,
        foregroundColor: AppColors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>  EmployeeFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmployeeSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.all(16).r,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.appColor,
        ),
      ),
    );
  }

  Widget _buildEmployeeList(List<Employee> employees) {
    return Container(
      color: AppColors.white,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 2).r,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return Dismissible(
            key: ValueKey(employee.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: AppColors.deleteBackgroundColor,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20).r,
              child: const Icon(Icons.delete, color: AppColors.white),
            ),
            onDismissed: (direction) => _handleDelete(employee),
            child: ListTile(
              title: Text(
                employee.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.position,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  Text(
                    employee.leavingDate != null
                        ? "${employee.formattedJoiningDate} - ${employee.formattedLeaveDate}"
                        : "From ${employee.formattedJoiningDate}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EmployeeFormScreen(employee: employee),
                  ),
                );
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
            color: AppColors.backgroundColor,
          );
        },
      ),
    );
  }
}
