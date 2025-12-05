import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final contactController = TextEditingController();

  void addContact() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Contact by User ID"),
        content: TextField(
          controller: contactController,
          decoration: InputDecoration(hintText: "Enter User ID"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              String contactId = contactController.text.trim();
              if (contactId.isEmpty) return;

              // Lookup contact UID by userId
              var docQuery = await FirebaseFirestore.instance
                  .collection('users')
                  .where('userId', isEqualTo: contactId)
                  .get();

              if (docQuery.docs.isNotEmpty) {
                String contactUid = docQuery.docs.first.id;

                // Add contact UID to current user's contacts array
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .update({
                  'contacts': FieldValue.arrayUnion([contactUid])
                });

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Contact Added Successfully")));
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("User ID not found")));
              }

              contactController.clear();
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Contacts")),
      floatingActionButton: FloatingActionButton(
        onPressed: addContact,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var userData = snapshot.data!;
          List contacts = userData['contacts'] ?? [];

          if (contacts.isEmpty) return Center(child: Text("No contacts added"));

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(contacts[index])
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return ListTile(title: Text("Loading..."));
                  var contactData = snapshot.data!;
                  return ListTile(
                    title: Text(contactData['name']),
                    subtitle: Text(contactData['userId']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            contactId: contactData.id,
                            contactName: contactData['name'],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
