import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic>? currentUserData;
  List<String> selectedContacts = [];
  bool isSelectionMode = false;
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _updateOnlineStatus(true);
    _fabController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _updateOnlineStatus(false);
    _searchController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _updateOnlineStatus(bool isOnline) async {
    await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _loadUserData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    setState(() {
      currentUserData = doc.data() as Map<String, dynamic>?;
    });
  }

  ImageProvider? _getImageProvider(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    try {
      Uint8List bytes = base64Decode(base64String);
      return MemoryImage(bytes);
    } catch (e) {
      return null;
    }
  }

  Future<void> _addContact() async {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add Contact'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Enter Contact ID',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: Icon(Icons.badge),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              String contactId = controller.text.trim();
              if (contactId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter Contact ID')),
                );
                return;
              }

              QuerySnapshot query = await FirebaseFirestore.instance
                  .collection('users')
                  .where('contactId', isEqualTo: contactId)
                  .get();

              if (query.docs.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User not found'), backgroundColor: Colors.red),
                );
                return;
              }

              var userData = query.docs.first.data() as Map<String, dynamic>;
              String otherUserId = query.docs.first.id;
              
              if (otherUserId == currentUserId) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cannot add yourself'), backgroundColor: Colors.red),
                );
                return;
              }

              Navigator.pop(context);

              bool? confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: Text('Confirm'),
                  content: Text('Add ${userData['name']} to contacts?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Add'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                // Add contact for current user
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUserId)
                    .collection('contacts')
                    .doc(otherUserId)
                    .set({
                  'contactId': otherUserId,
                  'addedAt': FieldValue.serverTimestamp(),
                });

                // Add contact for other user (both sides)
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .collection('contacts')
                    .doc(currentUserId)
                    .set({
                  'contactId': currentUserId,
                  'addedAt': FieldValue.serverTimestamp(),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Contact added successfully'), backgroundColor: Colors.green),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSelectedContacts() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Contacts'),
        content: Text('Delete ${selectedContacts.length} selected contact(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      for (String contactId in selectedContacts) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('contacts')
            .doc(contactId)
            .delete();
      }
      setState(() {
        selectedContacts.clear();
        isSelectionMode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contacts deleted'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _logout() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _updateOnlineStatus(false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.blue,
        elevation: 2,
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedContacts,
            ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              ).then((_) => _loadUserData());
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade400, Colors.blue.shade50],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.blue.shade700),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.blue),
                ),
                accountName: Text(currentUserData!['name'] ?? 'User', style: TextStyle(fontSize: 18)),
                accountEmail: Text(currentUserData!['email'] ?? ''),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.blue),
                title: Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  ).then((_) => _loadUserData());
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserId)
                  .collection('contacts')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.contacts, size: 80, color: Colors.grey),
                        SizedBox(height: 20),
                        Text(
                          'No contacts yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tap + button to add contacts',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var contact = snapshot.data!.docs[index];
                    String contactId = contact['contactId'];
                    bool isSelected = selectedContacts.contains(contactId);

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(contactId).get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return SizedBox.shrink();
                        }

                        var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                        String userName = userData['name'] ?? 'User';

                        if (searchQuery.isNotEmpty && !userName.toLowerCase().contains(searchQuery)) {
                          return SizedBox.shrink();
                        }

                        bool isOnline = userData['isOnline'] ?? false;

                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            elevation: isSelected ? 4 : 1,
                            color: isSelected ? Colors.blue.shade50 : null,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue.shade200,
                                    child: Icon(Icons.person, color: Colors.white),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: isOnline ? Colors.green : Colors.grey,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                userName,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                isOnline ? 'Online' : 'Offline',
                                style: TextStyle(
                                  color: isOnline ? Colors.green : Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: isSelectionMode
                                  ? Checkbox(
                                      value: isSelected,
                                      onChanged: (val) {
                                        setState(() {
                                          if (val == true) {
                                            selectedContacts.add(contactId);
                                          } else {
                                            selectedContacts.remove(contactId);
                                          }
                                          if (selectedContacts.isEmpty) {
                                            isSelectionMode = false;
                                          }
                                        });
                                      },
                                    )
                                  : null,
                              onTap: () {
                                if (isSelectionMode) {
                                  setState(() {
                                    if (isSelected) {
                                      selectedContacts.remove(contactId);
                                    } else {
                                      selectedContacts.add(contactId);
                                    }
                                    if (selectedContacts.isEmpty) {
                                      isSelectionMode = false;
                                    }
                                  });
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        contactId: contactId,
                                        contactName: userName,
                                        contactImage: userData['profileImage'],
                                      ),
                                    ),
                                  );
                                }
                              },
                              onLongPress: () {
                                setState(() {
                                  isSelectionMode = true;
                                  if (!selectedContacts.contains(contactId)) {
                                    selectedContacts.add(contactId);
                                  }
                                });
                              },
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
      floatingActionButton: ScaleTransition(
        scale: _fabController,
        child: FloatingActionButton(
          onPressed: _addContact,
          backgroundColor: Colors.blue,
          child: Icon(Icons.person_add),
        ),
      ),
    );
  }
}