import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/employee.dart';
import '../../logic/cubit/employee_cubit.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../ui/widgets/custom_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:employeeregister/utils/app_strings.dart';
import 'package:employeeregister/utils/app_colors.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee;

  EmployeeFormScreen({this.employee});

  @override
  _EmployeeFormScreenState createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _positionController;
  late TextEditingController _joiningController;
  late TextEditingController _leavingController;
  DateTime _joiningDate = DateTime.now();
  DateTime? _leavingDate;
  bool _isSelectingJoiningDate = true;
  String selectedRole = AppStrings.selectRoleHint;
  List<String> roles = [
    AppStrings.productDesigner,
    AppStrings.flutterDeveloper,
    AppStrings.QATester,
    AppStrings.productOwner
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _positionController =
        TextEditingController(text: widget.employee?.position ?? '');
    _joiningController = TextEditingController(
        text: widget.employee?.joiningDate.toString() ?? AppStrings.today);
    _leavingController = TextEditingController(
        text: widget.employee?.leavingDate.toString() ?? '');
    _joiningDate = widget.employee?.joiningDate ?? DateTime.now();
    _leavingDate = widget.employee?.leavingDate;
    _joiningController = TextEditingController(
      text: widget.employee?.joiningDate != null
          ? DateFormat('dd MMM yyyy').format(widget.employee!.joiningDate)
          : AppStrings.today,
    );
    _leavingController = TextEditingController(
      text: widget.employee?.leavingDate != null
          ? DateFormat('dd MMM yyyy').format(widget.employee!.leavingDate!)
          : '',
    );
  }

  void _showRolePicker(BuildContext context, Function(String) onRoleSelected) {
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      builder: (BuildContext context) {
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          itemCount: roles.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              minTileHeight: 52,
              title: Text(
                roles[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryTextColor,
                ),
              ),
              onTap: () {
                onRoleSelected(roles[index]);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _openCustomDatePicker() {
    showDialog(
      context: context,
      builder: (context) => CustomDatePicker(
        joiningDate: _isSelectingJoiningDate ? null : _joiningDate,
        initialDate: _isSelectingJoiningDate ? _joiningDate : _leavingDate,
        onDateSelected: (selectedDate) {
          setState(() {
            if (_isSelectingJoiningDate) {
              _joiningDate = selectedDate!;
              _joiningController.text =
                  DateFormat('dd MMM yyyy').format(selectedDate);
            } else {
              _leavingDate = selectedDate;
              _leavingController.text = selectedDate != null
                  ? DateFormat('dd MMM yyyy').format(selectedDate)
                  : '';
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        actions: [
          if (widget.employee?.id != null)
            IconButton(
              onPressed: () {
                context
                    .read<EmployeeCubit>()
                    .deleteEmployee(widget.employee!.id!);
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.delete,
                color: AppColors.white,
              ),
            )
        ],
        centerTitle: false,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.statusBarColor,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: AppColors.appColor,
        title: Text(
          widget.employee == null
              ? AppStrings.addEmployeeDetails
              : AppStrings.editEmployeeDetails,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Center(
                    child: TextFormField(
                      controller: _nameController,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10).r,
                        hintText: AppStrings.employeeNameHint,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryTextColor,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outlined,
                          color: AppColors.blue,
                          size: 24,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.borderColor, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.borderColor, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
                23.verticalSpace,
                Container(
                  height: 40,
                  child: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primaryTextColor,
                    ),
                    onTap: () {
                      _showRolePicker(context, (role) {
                        _positionController.text = role;
                      });
                    },
                    controller: _positionController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10).r,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryTextColor,
                      ),
                      hintText: AppStrings.selectRoleHint,
                      prefixIcon: Icon(
                        Icons.work_outline,
                        color: AppColors.blue,
                      ),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: AppColors.blue,
                        size: 40,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.borderColor, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.borderColor, width: 1.0),
                      ),
                    ),
                  ),
                ),
                23.verticalSpace,
                Container(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryTextColor,
                          ),
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _isSelectingJoiningDate = true;
                            _openCustomDatePicker();
                            ;
                          },
                          controller: _joiningController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 0)
                                .r,
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondaryTextColor,
                            ),
                            prefixIcon: Icon(
                              Icons.event,
                              color: AppColors.blue,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.borderColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.borderColor, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10).r,
                        child: Icon(
                          Icons.arrow_right_alt_rounded,
                          color: AppColors.blue,
                          size: 28,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryTextColor,
                          ),
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            _isSelectingJoiningDate = false;
                            _openCustomDatePicker();
                          },
                          controller: _leavingController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 0)
                                .r,
                            hintText: AppStrings.joiningDateHint,
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondaryTextColor,
                            ),
                            prefixIcon: Icon(
                              Icons.event,
                              color: AppColors.blue,
                              size: 24,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.borderColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.borderColor, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8).r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 12, horizontal: 15).r),
                      backgroundColor: MaterialStateProperty.all(
                          AppColors.buttonBackgroundColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.cancelButton,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.appColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: 12, horizontal: 21).r),
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.appColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ))),
                  onPressed: () {
                    if (_nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppStrings.emptyNameError)),
                      );
                      return;
                    }

                    if (_positionController.text.isEmpty ||
                        _positionController.text == "Select Role") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppStrings.selectRoleError)),
                      );
                      return;
                    }

                    if (_joiningDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(AppStrings.selectJoiningDateError)),
                      );
                      return;
                    }

                    final employee = Employee(
                      id: widget.employee?.id,
                      name: _nameController.text,
                      position: _positionController.text,
                      joiningDate: _joiningDate,
                      leavingDate: _leavingDate != null ? _leavingDate : null,
                    );

                    if (widget.employee == null) {
                      context.read<EmployeeCubit>().addEmployee(employee);
                    } else {
                      context.read<EmployeeCubit>().updateEmployee(employee);
                    }

                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppStrings.saveButton,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
