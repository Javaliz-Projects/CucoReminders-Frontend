import 'package:cuco_reminders/screens/home_screen/model/reminder_model.dart';
import 'package:cuco_reminders/screens/home_screen/widgets/modal_edit_widget.dart';
import 'package:flutter/material.dart';

class RemindersWidget extends StatelessWidget {
  const RemindersWidget({
    Key? key,
    required this.reminder,
  }) : super(key: key);

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => const ModalEditWidget(),
          barrierColor: Colors.black.withOpacity(0.5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
        );
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          height: 125,
          width: 500,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: <Color>[
                Color(0xffE38929),
                Color(0xffFFAB00),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reminder.titulo,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              Text(
                reminder.legenda,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    'Faltam 5 dias',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
