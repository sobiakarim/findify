import 'package:flutter/material.dart';

class BusinessDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> business;

  BusinessDetailsScreen({required this.business});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(business['name'] ?? 'Business Details', style: TextStyle(color: Color(0xffD3B08F)),),
        backgroundColor: Colors.brown[700],
        iconTheme: IconThemeData(color: Color(0xffD3B08F)),
      ),
      backgroundColor: Colors.brown[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              business['name'] ?? 'Business Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[700],
              ),
            ),
            SizedBox(height: 16),
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
      color: Color(0xffD3B08F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$label:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(color: Colors.brown[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
