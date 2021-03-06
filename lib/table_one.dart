import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  void resetStreamWithNameFilter() {
    setState(() {
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
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xff323435),
                  ),
                  elevation: 5,
                  constraints: const BoxConstraints.tightFor(
                    width: 56.0,
                    height: 56.0,
                  ),
                  onPressed: () {},
                  shape: const CircleBorder(),
                ),
                const Text(
                  '?????????????? 1',
                  style: TextStyle(
                      color: Color(0xff323435),
                      fontSize: 21,
                      fontWeight: FontWeight.bold),
                ),
                RawMaterialButton(
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xff323435),
                  ),
                  elevation: 5,
                  constraints: const BoxConstraints.tightFor(
                    width: 56.0,
                    height: 56.0,
                  ),
                  onPressed: () {},
                  shape: const CircleBorder(),
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
                child: const Text('???????????????? ?? ????')),
            StreamBuilder<QuerySnapshot>(
              stream: filterStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int i = 0;
                  final messages = snapshot.data?.docs;
                  List<DataRow> messageWidgets = [];
                  for (var message in messages!) {
                    final cena = message['cena'];
                    final dataTS = message['data'];
                    final kodPostav = message['kod_postav'];
                    final nomerDog = message['nomer_dog'];
                    final srokPostTS = message['srok_post'];
                    final tipProd = message['tip_prod'];
                    final idOf = snapshot.data?.docs[i].id;

                    DateTime data = dataTS.toDate();
                    DateTime srokPost = srokPostTS.toDate();
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(data);
                    String formattedSrok =
                        DateFormat('yyyy-MM-dd').format(srokPost);

                    final messageWidget = DataRow(selected: true, cells: [
                      DataCell(Text(
                        '${i + 1}',
                        style: const TextStyle(color: Colors.black),
                      )),
                      DataCell(Text('$nomerDog',
                          style: const TextStyle(color: Colors.black))),
                      DataCell(Text(formattedDate,
                          style: const TextStyle(color: Colors.black))),
                      DataCell(Text(formattedSrok,
                          style: const TextStyle(color: Colors.black))),
                      DataCell(Text('$cena',
                          style: const TextStyle(color: Colors.black))),
                      DataCell(Text('$kodPostav',
                          style: const TextStyle(color: Colors.black))),
                      DataCell(Text('$tipProd',
                          style: const TextStyle(color: Colors.black))),
                      DataCell(const Text('??????????????'), onTap: () async {
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
                        const DataColumn(label: Text('???')),
                        const DataColumn(
                          label: Text(
                            '?????????? ????????????????',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const DataColumn(
                            label: Text('????????',
                                style: TextStyle(color: Colors.black))),
                        const DataColumn(
                            label: Text('???????? ????????????????',
                                style: TextStyle(color: Colors.black))),
                        DataColumn(
                            label: const Text('????????',
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
                        const DataColumn(
                            label: Text('?????? ????????????????????',
                                style: TextStyle(color: Colors.black))),
                        const DataColumn(
                            label: Text('?????? ??????????????????',
                                style: TextStyle(color: Colors.black))),
                        const DataColumn(label: Text('??????????????')),
                      ],
                      rows: messageWidgets,
                    ),
                  ));
                } else {
                  return const Text('No dATA');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
