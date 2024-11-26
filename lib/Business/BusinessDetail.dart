import 'package:flutter/material.dart';

class BusinessDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> business;

  BusinessDetailsScreen({required this.business});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(business['name'] ?? 'Business Details', style: TextStyle(color: Color(0xffD2B48C), fontWeight: FontWeight.w500),),
        backgroundColor: Color(0xff1C0D0D),
        iconTheme: IconThemeData(color: Color(0xffD2B48C)),
      ),
      backgroundColor: Color(0xff1C0D0D),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 36),
            InfoTile(
              label: 'Address',
              value: business['address'] ?? 'N/A',
            ),
            SizedBox(height: 8),
            InfoTile(
              label: 'Phone',
              value: business['phone'] ?? 'N/A',
            ),
            SizedBox(height: 8),
            InfoTile(
              label: 'Description',
              value: business['description'] ?? 'No description available',
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shadowColor: Color(0xffD2B48C),
      color: Color(0xffD2B48C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$label:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff3E2723),
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(color: Color(0xff3E2723)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
