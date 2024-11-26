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
        title: Text(
          'Add Business',
          style: TextStyle(
            color: Color(0xffD3B08F),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xff1C0D0D),
        iconTheme: IconThemeData(color: Color(0xffD3B08F)),
      ),
      backgroundColor: Color(0xff1C0D0D),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              // Business Name Input
              _buildInputField(
                controller: nameController,
                hintText: 'Business Name',
                icon: Icons.business,
              ),
              SizedBox(height: 16),
              // Address Input
              _buildInputField(
                controller: addressController,
                hintText: 'Address',
                icon: Icons.location_on,
              ),
              SizedBox(height: 16),
              // Phone Number Input
              _buildInputField(
                controller: phoneController,
                hintText: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              // Category Dropdown
              DropdownButtonFormField<String>(
                dropdownColor: Color(0xff2E1E1E),
                iconEnabledColor: Color(0xffD3B08F),
                value: selectedCategory,
                style: TextStyle(color: Color(0xffD3B08F)),
                hint: Text('Select Category', style: TextStyle(color: Color(0xffD3B08F),  fontSize: 16)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xff2E1E1E),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xff2E1E1E), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xff2E1E1E), width: 1),
                  ),
                ),
                items: ['Food', 'Healthcare', 'Education', 'Hotels']
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category, style: TextStyle(color: Color(0xffD2B48C),)),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: 16),
              // Description Input
              _buildInputField(
                controller: descriptionController,
                hintText: 'Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              SizedBox(height: 24),
              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 12,
                  shadowColor: Color(0xffD2B48C),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Color(0xffD2B48C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Color(0xff3E2723),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Material(
      color:  Color(0xff2E1E1E),
      borderRadius: BorderRadius.circular(20),
      elevation: 12,
      shadowColor:  Color(0xffD2AA89),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xffD3B08F)),
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xffD3B08F)),
          filled: true,
          fillColor: Color(0xff2E1E1E),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xff2E1E1E), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xff2E1E1E), width: 2),
          ),
        ),
      ),
    );
  }
}
