// ignore_for_file: must_be_immutable, await_only_futures

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiengviet/tiengviet.dart';

import 'items.dart';

class SecondPage extends StatefulWidget {
  final String ho;
  final String tenDem;
  final String ten;
  List<DataItems> items;

  SecondPage(
      {super.key,
      required this.ho,
      required this.tenDem,
      required this.ten,
      required this.items});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    void loadHistory() async {
      final prefs = await SharedPreferences.getInstance();

      // Fetch and decode data
      final String itemsString = prefs.getString('localItems') ?? '';
      List<DataItems> localItems = await DataItems.decode(itemsString);
      // print(localItems);

      if (localItems.isNotEmpty) {
        setState(() {
          widget.items = localItems;
        });
      }
    }

    void handleAddItem(String ho, tenDem, ten, lastName, middleName, firstName) async {
      loadHistory();

      final newItem = DataItems(
          id: DateTime.now().toString(),
          ho: ho,
          tenDem: tenDem,
          ten: ten,
          lastName: lastName,
          middleName: middleName,
          firstName: firstName);
      widget.items.add(newItem);

      final prefs = await SharedPreferences.getInstance();

      // remove old value
      await prefs.remove('localItems');

      // Encode and store data in SharedPreferences
      final String encodedData = DataItems.encode(widget.items);
      await prefs.setString('localItems', encodedData);
    }

    final String firstName = TiengViet.parse(widget.ten);
    final String middleName = TiengViet.parse(widget.tenDem);
    final String lastName = TiengViet.parse(widget.ho);
    handleAddItem(widget.ho, widget.tenDem, widget.ten, lastName, middleName, firstName);
    // print(items);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text("${widget.ho} ${widget.tenDem} ${widget.ten}",
                    style: const TextStyle(fontSize: 25, color: Colors.red)),
              ),
              Container(
                width: double.infinity,
                height: 70,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 2))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("First name: ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      Text(firstName,
                          style:
                              const TextStyle(fontSize: 20, color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 70,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 2))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Middle name: ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      Text(middleName,
                          style:
                              const TextStyle(fontSize: 20, color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 70,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 2))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Last name: ",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      Text(lastName,
                          style:
                              const TextStyle(fontSize: 20, color: Colors.red)),
                    ],
                  ),
                ),
              ),
              const Text("Tên tiếng Anh của bạn là: ",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              Text("$firstName $middleName $lastName",
                  style: const TextStyle(fontSize: 25, color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
