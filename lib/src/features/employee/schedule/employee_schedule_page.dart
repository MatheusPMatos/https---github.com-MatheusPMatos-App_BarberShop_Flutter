import 'dart:developer';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/core/ui/widgets/constants.dart';
import 'package:dw_barbershop/src/features/employee/schedule/appointmente_ds.dart';
import 'package:dw_barbershop/src/features/employee/schedule/employee_schedule_vm.dart';
import 'package:dw_barbershop/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EmployeeSchedulePage extends ConsumerStatefulWidget {
  const EmployeeSchedulePage({super.key});

  @override
  ConsumerState<EmployeeSchedulePage> createState() =>
      _EmployeeSchedulePageState();
}

class _EmployeeSchedulePageState extends ConsumerState<EmployeeSchedulePage> {
  late DateTime dateSelected;
  var ingnoreFirstLoad = true;

  @override
  void initState() {
    final DateTime(:year, :month, :day) = DateTime.now();
    dateSelected = DateTime(year, month, day, 0, 0, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel(id: userId, :name) =
        ModalRoute.of(context)!.settings.arguments as UserModel;
    final scheduleAsync =
        ref.watch(EmployeeScheduleVmProvider(userId, dateSelected));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 44,
          ),
          scheduleAsync.when(
            error: (error, stackTrace) {
              log('Erro ao carregar agendamentos',
                  error: error, stackTrace: stackTrace);
              return const Center(
                child: Text('Erro ao carregar pagina'),
              );
            },
            loading: () => const BarbershopLoader(),
            data: (schedules) {
              return Expanded(
                  child: SfCalendar(
                allowViewNavigation: true,
                timeSlotViewSettings:const TimeSlotViewSettings(
                  timeFormat: 'hh:mm',
                  startHour: 07,
                  endHour: 22
                ),
                view: CalendarView.day,
                showNavigationArrow: true,
                todayHighlightColor: ColorsConstants.brow,
                showDatePickerButton: true,
                showTodayButton: true,
                dataSource: AppointmenteDs(schedules: schedules),
                onViewChanged: (viewChangedDetails) {
                  if (ingnoreFirstLoad) {
                    ingnoreFirstLoad = false;
                    return;
                  }
                  ref
                      .read(employeeScheduleVmProvider(userId, dateSelected)
                          .notifier)
                      .changeDate(
                          userId, viewChangedDetails.visibleDates.first);
                },
                onTap: (calendarTapDetails) {
                  if (calendarTapDetails.appointments != null &&
                      calendarTapDetails.appointments!.isNotEmpty) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        final DateFormat dateFormat = DateFormat('dd/MM HH:mm');
                        return SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                    'Client: ${calendarTapDetails.appointments?.first.subject}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    'Horário: ${dateFormat.format(calendarTapDetails.date ?? DateTime.now())}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
