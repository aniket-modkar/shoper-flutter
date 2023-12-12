import 'dart:convert';
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:shoper/api_service.dart';

class FetchedData {
  final String message;
  final String responseCode;
  final Map<String, dynamic> result;
  final int totalCounts;
  final int statusCode;

  FetchedData({
    required this.message,
    required this.responseCode,
    required this.result,
    required this.totalCounts,
    required this.statusCode,
  });

  factory FetchedData.fromJson(Map<String, dynamic> json) {
    return FetchedData(
      message: json['message'] ?? '',
      responseCode: json['responseCode'] ?? '',
      result: json['result'] ?? {},
      totalCounts: json['totalCounts'] ?? 0,
      statusCode: json['statusCode'] ?? 0,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  FetchedData fetchedData = FetchedData(
    message: '',
    responseCode: '',
    result: {},
    totalCounts: 0,
    statusCode: 0,
  );

  Future<void> fetchData() async {
    try {
      final response =
          await _apiService.fetchData('api/v1/cms/fetch?type=PRIVACY');
      if (response.statusCode == 200) {
        setState(() {
          fetchedData = FetchedData.fromJson(json.decode(response.body));
        });
      } else {
        setState(() {
          fetchedData = FetchedData(
            message:
                'Failed to fetch data. Status code: ${response.statusCode}',
            responseCode: '',
            result: {},
            totalCounts: 0,
            statusCode: response.statusCode,
          );
        });
      }
    } catch (error) {
      setState(() {
        fetchedData = FetchedData(
          message: 'Error: $error',
          responseCode: '',
          result: {},
          totalCounts: 0,
          statusCode: 0,
        );
      });
    }
  }

  Widget buildDataTable() {
    List<DataRow> dataRows = [];

    fetchedData.result.forEach((key, value) {
      dataRows.add(DataRow(
        cells: [
          DataCell(Text(key)),
          DataCell(Text('$value')),
        ],
      ));
    });

    return DataTable(
      columns: [
        DataColumn(label: Text('Key')),
        DataColumn(label: Text('Value')),
      ],
      rows: dataRows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home Page!'),
            SizedBox(height: 16),
            Text('Fetched Data:'),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: buildDataTable(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        tooltip: 'Fetch Data',
        child: Icon(Icons.cloud_download),
      ),
    );
  }
}
