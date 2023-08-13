import 'package:convert_vietnamese_name_to_english/history.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'items.dart';
import 'second_page.dart'; // Đảm bảo bạn đã tạo file second_page.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DataItems> items = [];

  final TextEditingController _hoController = TextEditingController();
  final TextEditingController _tenDemController = TextEditingController();
  final TextEditingController _tenController = TextEditingController();

  bool _validateHo = false;
  bool _validateTenDem = false;
  bool _validateTen = false;

  void nhaplai() {
    _hoController.clear();
    _tenDemController.clear();
    _tenController.clear();

    setState(() {
      _validateHo = false;
      _validateTenDem = false;
      _validateTen = false;
    });
  }

  Future checkData() async {
    if (_hoController.text != '' &&
        _tenDemController.text != '' &&
        _tenController.text != '') {
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondPage(
            ho: _hoController.text,
            tenDem: _tenDemController.text,
            ten: _tenController.text,
            items: items,
          ),
        ),
      );
    }

    if (_hoController.text == '') {
      setState(() {
        _validateHo = true;
      });
    } else {
      setState(() {
        _validateHo = false;
      });
    }

    if (_tenDemController.text == '') {
      setState(() {
        _validateTenDem = true;
      });
    } else {
      setState(() {
        _validateTenDem = false;
      });
    }

    if (_tenController.text == '') {
      setState(() {
        _validateTen = true;
      });
    } else {
      setState(() {
        _validateTen = false;
      });
    }
  }

  void loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Fetch and decode data
      final String itemsString = prefs.getString('localItems') ?? '';
      List<DataItems> localItems = DataItems.decode(itemsString);
      // print(localItems);

      if (localItems.isNotEmpty) {
        items = localItems;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nhập thông tin'),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryPage(items: items),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.history_rounded, size: 40),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _hoController,
                onChanged: (value) {
                  setState(() {
                    _validateHo = false;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Họ',
                    errorText: _validateHo ? 'Vui lòng nhập họ' : null),
                autofocus: false,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _tenDemController,
                onChanged: (value) {
                  setState(() {
                    _validateTenDem = false;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Tên đệm',
                    errorText:
                        _validateTenDem ? 'Vui lòng nhập tên đệm' : null),
                autofocus: false,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _tenController,
                onChanged: (value) {
                  setState(() {
                    _validateTen = false;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Tên',
                    errorText: _validateTen ? 'Vui lòng nhập tên' : null),
                autofocus: false,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: checkData,
                child: const Text('Dịch'),
              ),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)),
                onPressed: nhaplai,
                child: const Text('Nhập lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
