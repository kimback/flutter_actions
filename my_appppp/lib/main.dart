import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var repo = CalculatorRepository();
    var service = CalculatorService(repo);

    return MaterialApp(
      home: CalculatorScreen(service),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final CalculatorService service;

  CalculatorScreen(this.service);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {

  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();
  int? _result;

  @override
  void initState() {
    super.initState();
  }

  void _calculate() {

    final int num1 = int.tryParse(_num1Controller.text) ?? 0;
    final int num2 = int.tryParse(_num2Controller.text) ?? 0;

    var result = widget.service.saveResult(num1, num2);

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _num1Controller,
              decoration: InputDecoration(labelText: 'Enter first number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _num2Controller,
              decoration: InputDecoration(labelText: 'Enter second number'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _calculate,
              child: Text('Calculate'),
            ),
            if (_result != null)
              Text(
                '$_result',
                style: TextStyle(fontSize: 24),
              ),
          ],
        ),
      ),
    );
  }
}




class CalculatorService {
  CalculatorRepository repository;

  CalculatorService(this.repository);

  int saveResult(int a, int b){
    var result = add(a, b);
    repository.saveResult(result);
    return result;
  }

  int add(int a, int b){
    return a+b;
  }
}

class CalculatorRepository { //간단한 저장소 역할
  List<int> calculationHistory = [];

  void saveResult(int result) {
    calculationHistory.add(result);
  }

  List<int> getHistory() {
    return calculationHistory;
  }
}

