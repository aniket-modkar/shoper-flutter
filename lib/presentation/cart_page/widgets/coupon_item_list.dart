import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CouponListItem extends StatelessWidget {
  final dynamic discount;
  final VoidCallback onPressed;

  const CouponListItem({
    required this.discount,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(discount['code'] ?? 'No Code'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Type: ${discount['type'] ?? 'Unknown'}'),
          Text('Value: ${discount['value'] ?? 'Unknown'}%'),
          Text('Expiry Date: ${_formatDate(discount['endDate'] ?? '')}'),
        ],
      ),
      trailing: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.black, // background color
          onPrimary: Colors.white, // text color
        ),
        child: Text('Apply'),
      ),
    );
  }

  String _formatDate(String dateTimeString) {
    if (dateTimeString.isEmpty) {
      return 'No Expiry Date';
    }
    final dateTime = DateTime.tryParse(dateTimeString);
    return dateTime != null
        ? DateFormat.yMMMd().format(dateTime)
        : 'Invalid Date';
  }
}
