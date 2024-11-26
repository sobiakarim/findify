import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xff1C0D0D),
        title: Text(
          'Search Businesses',
          style: TextStyle(color: Color(0xffD2B48C), fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Color(0xffD2B48C)),
      ),

      backgroundColor: Color(0xff1C0D0D),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: TextStyle(color: Color(0xffD2B48C)),
              cursorColor: Color(0xffD2B48C),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Color(0xffD2B48C)),
                hintText: 'Search here',
                hintStyle: TextStyle(color: Color(0xffC19A6B)),
                filled: true,
                fillColor: Color(0xff2E1E1E),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color(0xff2E1E1E)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Color(0xff2E1E1E), width: 2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    dropdownColor: Color(0xff2E1E1E),
                    style: TextStyle(color: Color(0xff2E1E1E)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xff2E1E1E),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Color(0xff2E1E1E)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Color(0xff2E1E1E))
                      ),
                    ),
                    iconEnabledColor: Color(0xffD2B48C),
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category, style: TextStyle(color: Color(0xffD2B48C))),
                      );
                    }).toList(),
                    onChanged: (String? newCategory) {
                      setState(() {
                        selectedCategory = newCategory!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // StreamBuilder to fetch data from Firestore based on the selected category and search query
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: searchBusinesses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Color(0xffD2B48C)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No businesses found.',
                      style: TextStyle(color: Color(0xffD2B48C), fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var business = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    String businessId = snapshot.data!.docs[index].id; // Fetch the document ID

                    return Card(
                      color: Color(0xff2E1E1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Color(0xff2E1E1E), width: 1),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListTile(
                        title: Text(
                          business['name'],
                          style: TextStyle(color: Color(0xffD2B48C), fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          business['location'] ?? 'No location provided',
                          style: TextStyle(color: Color(0xffD2B48C)),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: Color(0xffD2B48C)),
                        onTap: () {
                          // Navigate to the already defined BusinessDetailScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusinessDetailsScreen(
                                business: business, // Optionally pass other business details
                              ),
                            ),
                          );
                        },
                      ),
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
