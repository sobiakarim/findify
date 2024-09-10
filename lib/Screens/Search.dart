import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Assuming BusinessDetailScreen is already defined somewhere in your project
import 'BusinessDetail.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';
  String selectedCategory = 'Food'; // Default category
  List<String> categories = ['Food', 'Healthcare', 'Hotels', 'Education'];
  String searchType = 'name'; // Default search type (can be name or location)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[700],

      ),
      backgroundColor: Colors.brown,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                  hintText: 'Search here',
                hintStyle: TextStyle(
                  color: Color(0xffD3B08F),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color(0xffD3B08F)),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xffD3B08F))
                ),
              ),
            ),
          ),
          // Dropdown to select category

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: DropdownButton<String>(
              iconEnabledColor: Color(0xffD3B08F),
              value: selectedCategory,
              items: categories.map((String category) {
                return DropdownMenuItem<String>(

                  value: category,
                  child: Text(category, style: TextStyle(color: Color(0xffD3B08F)),),
                );
              }).toList(),
              onChanged: (String? newCategory) {
                setState(() {
                  selectedCategory = newCategory!;
                });
              },
            ),
          ),
          // StreamBuilder to fetch data from Firestore based on the selected category and search query
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: searchBusinesses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                        'No businesses found.',
                        style: TextStyle(color: Color(0xffD3B08F)),
                      )
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var business = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    String businessId = snapshot.data!.docs[index].id; // Fetch the document ID

                    return ListTile(
                      title: Text(business['name']),
                      subtitle: Text(business['location'] ?? ''),
                      onTap: () {
                        // Navigate to the already defined BusinessDetailScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessDetailsScreen(
                             // Pass the business ID
                              business: business, // Optionally pass other business details
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Function to build the Firestore query for searching businesses
  Stream<QuerySnapshot> searchBusinesses() {
    Query query = FirebaseFirestore.instance.collection(selectedCategory);

    if (searchQuery.isNotEmpty) {
      // Filter by name or location based on searchType
      query = query
          .where(searchType, isGreaterThanOrEqualTo: searchQuery)
          .where(searchType, isLessThanOrEqualTo: searchQuery + '\uf8ff');
    }

    return query.snapshots();
  }
}
