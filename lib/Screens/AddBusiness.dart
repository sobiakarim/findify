import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBusinessScreen extends StatefulWidget {
  @override
  _AddBusinessScreenState createState() => _AddBusinessScreenState();
}

class _AddBusinessScreenState extends State<AddBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
          title: Text('Add Business', style: TextStyle(color: Color(0xffD3B08F)),),
        backgroundColor: Colors.brown[700],
        iconTheme: IconThemeData(color: Color(0xffD3B08F)),
      ),
     backgroundColor: Colors.brown,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Color(0xffD3B08F)),
                    hintText: 'Business Name'
                ),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Color(0xffD3B08F)),
                    hintText: 'Address'),
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Color(0xffD3B08F)),
                    hintText: 'Phone Number'),
              ),
              DropdownButtonFormField<String>(
                dropdownColor: Color(0xffD3B08F),
                iconEnabledColor: Color(0xffD3B08F),
                value: selectedCategory,
                hint: Text('Select Category', style: TextStyle(color: Color(0xffD3B08F)),),
                items: ['Food', 'Healthcare', 'Education', 'Hotels']
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Color(0xffD3B08F)),
                    hintText: 'Description'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xffD3B08F)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate() && selectedCategory != null) {
                    await FirebaseFirestore.instance.collection(selectedCategory!).add({
                      'name': nameController.text,
                      'address': addressController.text,
                      'phone': phoneController.text,
                      'description': descriptionController.text,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Business added successfully!'),
                    ));

                    // Optionally clear the form
                    nameController.clear();
                    addressController.clear();
                    phoneController.clear();
                    descriptionController.clear();
                    setState(() {
                      selectedCategory = null;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please fill all fields and select a category'),
                    ));
                  }
                },
                child: Text('Submit', style: TextStyle(color: Colors.brown)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
