import 'dart:convert';

import 'package:cuco_reminders/screens/home_screen/model/reminder_model.dart';
import 'package:cuco_reminders/screens/home_screen/widgets/modal_add_widget.dart';
import 'package:cuco_reminders/screens/home_screen/widgets/reminders_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List> reminders;
  final _formKey = GlobalKey<FormState>();

  final _adicionarTitulo = TextEditingController();
  final _adicionarDescricao = TextEditingController();

  final _editarTitulo = TextEditingController();
  final _editarDescricao = TextEditingController();

  @override
  void initState() {
    super.initState();
    reminders = fetchReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xffE38929),
                Color(0xffFFAB00),
              ],
            ),
          ),
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => Form(
              key: _formKey,
              child: const ModalAddWidget(),
            ),
            barrierColor: Colors.black.withOpacity(0.5),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
          );
        },
      ),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[
                  Color(0xff194429),
                  Color(0xff188534),
                ]),
          ),
        ),
        toolbarHeight: 80,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Reminders',
          style: TextStyle(
            color: Color(0xffF3A42C),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: <Color>[
                Color(0xff194429),
                Color(0xff188534),
              ],
            ),
          ),
          height: 50,
        ),
      ),
      body: FutureBuilder<List>(
        future: fetchReminders(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return RemindersWidget(
                  reminder: Reminder(
                      titulo: snapshot.data![index]['titulo'],
                      legenda: snapshot.data![index]['mensagem'],
                      dataVencimento: snapshot.data![index]['dataVencimento'],
                      prioridade: snapshot.data![index]['prioridade']),
                );

                // return ListTile(
                //   leading: IconButton(
                //     onPressed: () {
                //       showModalBottomSheet(
                //         context: context,
                //         builder: (context) => Form(
                //           child: Container(
                //             color: Colors.yellow,
                //             child: Column(
                //               children: [
                //                 TextFormField(),
                //                 TextFormField(),
                //                 TextFormField(),
                //                 MaterialButton(
                //                   onPressed: () {},
                //                   child: const Text('Salvar'),
                //                 )
                //               ],
                //             ),
                //           ),
                //         ),
                //         barrierColor: Colors.black.withOpacity(0.5),
                //         shape: const RoundedRectangleBorder(
                //           borderRadius: BorderRadius.only(
                //             topLeft: Radius.circular(40),
                //             topRight: Radius.circular(40),
                //           ),
                //         ),
                //       );
                //     },
                //     icon: const Icon(Icons.edit),
                //   ),
                //   title: Text(snapshot.data![index]['titulo']),
                //   subtitle: Text(
                //     snapshot.data![index]['mensagem'],
                //   ),
                //   trailing: IconButton(
                //     onPressed: () {
                //       deleteReminders(
                //         snapshot.data![index]['id'].toString(),
                //       );
                //     },
                //     icon: const Icon(Icons.delete),
                //   ),
                // );
              },
            );
          } else if (snapshot.hasError) {}
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }
}

Future<List> fetchReminders() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  var url = Uri.parse(
      'https://46f4-2804-7f7-a58a-4d7d-15f9-d08d-4a0d-f07f.sa.ngrok.io/cucoreminder/lembretes');
  var response = await http.get(
    url,
    headers: {
      'Authorization': sharedPreferences.getString('Authorization')!,
    },
  );
  if (response.statusCode == 200) {
    return json.decode(response.body).map((reminder) => reminder).toList();
  } else {
    throw Exception('Error get reminders');
  }
}

deleteReminders(String id) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  var url = Uri.parse(
      'https://46f4-2804-7f7-a58a-4d7d-15f9-d08d-4a0d-f07f.sa.ngrok.io/cucoreminder/lembretes/deletar/$id');
  var response = await http.delete(
    url,
    headers: {
      'Authorization': sharedPreferences.getString('Authorization')!,
    },
  );
  print(
    response.body.toString(),
  );
  print(response.statusCode);
}

adicionarReminders() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  var url = Uri.parse(
      'https://46f4-2804-7f7-a58a-4d7d-15f9-d08d-4a0d-f07f.sa.ngrok.io/cucoreminder/lembretes/salvar');
  var response = await http.delete(url, headers: {
    'Authorization': sharedPreferences.getString('Authorization')!,
  }, body: {
    'titulo': '(String) titulo',
    'mensagem': '(String) msg',
    'dataVencimento':
        ' (String) dataVencimento [dia+"/"+mes+"/"+ano+" "+hora+":"+minuto+":"+segundo;]',
  });
  print(
    response.body.toString(),
  );
  print(response.statusCode);
}
