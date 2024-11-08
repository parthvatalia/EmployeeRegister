import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'logic/cubit/employee_cubit.dart';
import 'repository/employee_repository.dart';
import 'ui/screens/employee_list_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:employeeregister/utils/app_strings.dart';
import 'package:employeeregister/utils/app_colors.dart';

void main() {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final EmployeeRepository _repository = EmployeeRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => EmployeeCubit(_repository)..fetchEmployees()),
      ],
      child: ScreenUtilInit(
          designSize: const Size(428, 926),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return MaterialApp(
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(primarySwatch: AppColors.blue),
              home: const EmployeeListScreen(),
            );
          }),
    );
  }
}
