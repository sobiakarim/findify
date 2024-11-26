import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'BusinessDetail.dart';

class CategoryScreen extends StatelessWidget {
  final String category;

  CategoryScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(category, style: TextStyle(color: Color(0xffD2B48C), fontWeight: FontWeight.w500),),
        backgroundColor: Color(0xff1C0D0D),
        iconTheme: IconThemeData(color: Color(0xffD2B48C))
      ),
      backgroundColor: Color(0xff1C0D0D),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(category).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No businesses found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var business = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Card(
                elevation: 20,
                shadowColor: Color(0xffD2B48C),
                color: Color(0xffD2B48C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(
                    business['name'],
                    style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    business['description'] ?? '',
                    style: TextStyle(color: Color(0xff3E2723)),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Color(0xff3E2723)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusinessDetailsScreen(business: business),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
