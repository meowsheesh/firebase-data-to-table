import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// константа стилей для Поля с заполнением

const kTextField = InputDecoration(
  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
);

class TableOne extends StatefulWidget {
  const TableOne({Key? key}) : super(key: key);

  static String id = 'table_one';

  @override
  State<TableOne> createState() => _TableOneState();
}

class _TableOneState extends State<TableOne> {
  // подключение к бд и переменные

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  CollectionReference tableOne =
      FirebaseFirestore.instance.collection('tableone');

  Stream<QuerySnapshot>? filterStream;
  String? filterValue = '';

  String addedNomDog = '';
  String addedData = '';
  String addedSrokPost = '';
  String addedCena = '';
  String addedKodPostav = '';
  String addedTipProd = '';

  // функция для сортировки - смена фильтра получения данных с БД и сортировкой по цене

  void resetStreamWithNameFilter() {
    setState(() {
      // return all products if your filter is empty
      if (filterValue == '') {
        filterStream = _firestore.collection('tableone').snapshots();
        return;
      } else if (filterValue == 'cena_true') {
        filterStream = _firestore
            .collection('tableone')
            .orderBy('cena', descending: true)
            .snapshots();
      } else if (filterValue == 'cena_false') {
        filterStream = _firestore
            .collection('tableone')
            .orderBy('cena', descending: false)
            .snapshots();
      }
    });
  }

  // UI

  @override
  Widget build(BuildContext context) {
    resetStreamWithNameFilter();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RawMaterialButton(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xff323435),
                  ),
                  elevation: 5,
                  constraints: BoxConstraints.tightFor(
                    width: 56.0,
                    height: 56.0,
                  ),
                  onPressed: () {},
                  shape: CircleBorder(),
                ),
                Text(
                  'Таблица 1',
                  style: TextStyle(
                      color: Color(0xff323435),
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
                RawMaterialButton(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xff323435),
                  ),
                  elevation: 5,
                  constraints: BoxConstraints.tightFor(
                    width: 56.0,
                    height: 56.0,
                  ),
                  onPressed: () {},
                  shape: CircleBorder(),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                    child: TextField(
                  decoration: kTextField,
                  onChanged: (value) {
                    addedNomDog = value;
                  },
                )),
                Flexible(
                    child: TextField(
                  decoration: kTextField,
                  onChanged: (value) {
                    addedData = value;
                  },
                )),
                Flexible(
                    child: TextField(
                  decoration: kTextField,
                  onChanged: (value) {
                    addedSrokPost = value;
                  },
                )),
                Flexible(
                    child: TextField(
                  decoration: kTextField,
                  onChanged: (value) {
                    addedCena = value;
                  },
                )),
                Flexible(
                    child: TextField(
                  decoration: kTextField,
                  onChanged: (value) {
                    addedKodPostav = value;
                  },
                )),
                Flexible(
                    child: TextField(
                  decoration: kTextField,
                  onChanged: (value) {
                    addedTipProd = value;
                  },
                )),
              ],
            ),

            // кнопка передаёт и переводит значения в int и timestamp и передаёт в БД

            ElevatedButton(
                onPressed: () async {
                  await tableOne.add({
                    'cena': int.parse(addedCena),
                    'kod_postav': int.parse(addedKodPostav),
                    'nomer_dog': int.parse(addedNomDog),
                    'tip_prod': addedTipProd,
                    'data': DateTime.parse(addedData),
                    'srok_post': DateTime.parse(addedSrokPost),
                  });
                },
                child: Text('Добавить в БД')),

            // построение таблицы с данными из БД

            StreamBuilder<QuerySnapshot>(
              stream: filterStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int i = 0;
                  final messages = snapshot.data?.docs;
                  List<DataRow> messageWidgets = [];

                  // цикл для построения и вывода данных DataTable

                  for (var message in messages!) {
                    final cena = message['cena'];
                    final dataTS = message['data'];
                    final kod_postav = message['kod_postav'];
                    final nomer_dog = message['nomer_dog'];
                    final srok_postTS = message['srok_post'];
                    final tip_prod = message['tip_prod'];
                    final idOf = snapshot.data?.docs[i].id;

                    DateTime data = dataTS.toDate();
                    DateTime srok_post = srok_postTS.toDate();
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(data);
                    String formattedSrok =
                        DateFormat('yyyy-MM-dd').format(srok_post);

                    final messageWidget = DataRow(selected: true, cells: [
                      DataCell(Text(
                        '${i + 1}',
                        style: TextStyle(color: Colors.black),
                      )),
                      DataCell(Text('$nomer_dog',
                          style: TextStyle(color: Colors.black))),
                      DataCell(Text('$formattedDate',
                          style: TextStyle(color: Colors.black))),
                      DataCell(Text('$formattedSrok',
                          style: TextStyle(color: Colors.black))),
                      DataCell(
                          Text('$cena', style: TextStyle(color: Colors.black))),
                      DataCell(Text('$kod_postav',
                          style: TextStyle(color: Colors.black))),
                      DataCell(Text('$tip_prod',
                          style: TextStyle(color: Colors.black))),
                      DataCell(Text('УДАЛИТЬ'), onTap: () async {
                        await FirebaseFirestore.instance
                            .collection('tableone')
                            .doc(idOf)
                            .delete();
                      }),
                    ]);
                    messageWidgets.add(messageWidget);
                    i++;
                  }
                  return Expanded(
                      child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('№')),
                        DataColumn(
                          label: Text(
                            'Номер договора',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        DataColumn(
                            label: Text('Дата',
                                style: TextStyle(color: Colors.black))),
                        DataColumn(
                            label: Text('Срок поставки',
                                style: TextStyle(color: Colors.black))),
                        DataColumn(
                            label: Text('Цена',
                                style: TextStyle(color: Colors.black)),
                            onSort: (columnIndex, ascending) {
                              setState(() {
                                if (filterValue == 'cena_true') {
                                  filterValue = 'cena_false';
                                } else if (filterValue == 'cena_false') {
                                  filterValue = 'cena_true';
                                } else {
                                  filterValue = 'cena_false';
                                }
                              });
                            }),
                        DataColumn(
                            label: Text('Код Поставщика',
                                style: TextStyle(color: Colors.black))),
                        DataColumn(
                            label: Text('Тип продукции',
                                style: TextStyle(color: Colors.black))),
                        DataColumn(label: Text('УДАЛИТЬ')),
                      ],
                      rows: messageWidgets,
                    ),
                  ));
                } else {
                  return Text('No dATA');
                }
                //,style: TextStyle(color: Colors.black),
              },
            )
          ],
        ),
      ),
    );
  }
}
