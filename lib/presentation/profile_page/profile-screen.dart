import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/service/api_service.dart';

class FetchedData {
  final String message;
  final String responseCode;
  final List<Map<String, dynamic>> result; // Specify List<Map<String, dynamic>>
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
      result:
          (json['result'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
              [], // Explicitly cast to List<Map<String, dynamic>>
      totalCounts: json['totalCounts'] ?? 0,
      statusCode: json['statusCode'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'FetchedData { message: $message, responseCode: $responseCode, result: $result, totalCounts: $totalCounts, statusCode: $statusCode }';
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  late FetchedData fetchedData;
  bool isDataFetched = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  Future<void> fetchData() async {
    if (!isDataFetched && !isError) {
      try {
        final response = await _apiService.fetchData('api/v1/account/fetch');
        if (response.statusCode == 202) {
          if (mounted) {
            setState(() {
              fetchedData = FetchedData.fromJson(json.decode(response.body));
              isDataFetched = true;
            });
          }
        } else {
          handleNon200StatusCode(response.statusCode);
        }
      } catch (error) {
        handleError(error);
      }
    }
  }

  void handleNon200StatusCode(int statusCode) {
    // Handle non-200 status code
    print('Error: $statusCode');
    setState(() {
      isError = true;
    });
  }

  void handleError(dynamic error) {
    // Handle errors
    print('Error: $error');
    if (mounted) {
      setState(() {
        fetchedData = FetchedData(
          message: 'Error: $error',
          responseCode: '',
          result: [],
          totalCounts: 0,
          statusCode: 0,
        );
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isError
          ? _buildErrorUI()
          : isDataFetched
              ? _buildProfileUI()
              : _buildLoadingUI(),
    );
  }

  Widget _buildErrorUI() {
    // Implement UI for error state
    return Center(
      child: Text('Error occurred while fetching data.'),
    );
  }

  Widget _buildLoadingUI() {
    // Implement loading indicator UI
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildProfileUI() {
    // Implement the main profile UI using fetchedData
    return Column(
      children: [
        const Expanded(flex: 2, child: _TopPortion()),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Richie Lorie",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {},
                      heroTag: 'follow',
                      elevation: 0,
                      label: const Text("Follow"),
                      icon: const Icon(Icons.person_add_alt_1),
                    ),
                    const SizedBox(width: 16.0),
                    FloatingActionButton.extended(
                      onPressed: () {},
                      heroTag: 'message',
                      elevation: 0,
                      backgroundColor: Colors.red,
                      label: const Text("Message"),
                      icon: const Icon(Icons.message_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _ProfileInfoRow()
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({Key? key}) : super(key: key);

  final List<ProfileInfoItem> _items = const [
    ProfileInfoItem("Posts", 900),
    ProfileInfoItem("Followers", 120),
    ProfileInfoItem("Following", 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items
            .map((item) => Expanded(
                    child: Row(
                  children: [
                    if (_items.indexOf(item) != 0) const VerticalDivider(),
                    Expanded(child: _singleItem(context, item)),
                  ],
                )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80')),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
