// ignore_for_file: must_be_immutable, camel_case_types

import 'package:flutter/material.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'items.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({
    Key? key,
    required this.items,
  }) : super(key: key);
  List<DataItems> items;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<DataItems> localItems = [];

  void handleDeleteItem(String id) async {
    widget.items.removeWhere((item) => item.id == id);

    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();

    // remove old value
    await prefs.remove('localItems');

    // Encode and store data in SharedPreferences
    final String encodedData = DataItems.encode(widget.items);
    await prefs.setString('localItems', encodedData);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lịch sử'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(14),
          child: widget.items.isEmpty
              ? const Center(
                  child: Text("Chưa có dữ liệu nào",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                )
              : ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return card_history(
                        item: widget.items[index],
                        handleDeleteItem: handleDeleteItem);
                  },
                ),
        ),
      ),
    );
  }
}

class card_history extends StatelessWidget {
  card_history({
    super.key,
    required this.item,
    required this.handleDeleteItem,
  });
  DataItems item;
  Function handleDeleteItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 1,
                spreadRadius: 0,
                offset: Offset(0, 4))
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${item.ho} ${item.tenDem} ${item.ten}",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 5),
                Wrap(children: [
                  const Icon(Icons.subdirectory_arrow_right),
                  Text("${item.firstName} ${item.middleName} ${item.lastName}",
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w300)),
                ]),
              ],
            ),
            InkWell(
              onTap: () async {
                if (await confirm(context,
                    title: const Text("Xóa lịch sử"),
                    content: const Text("Xác nhận xóa?"),
                    textCancel: const Text("Hủy"))) {
                  handleDeleteItem(item.id);
                }
                return;
              },
              child: const Icon(Icons.delete, color: Colors.red, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
