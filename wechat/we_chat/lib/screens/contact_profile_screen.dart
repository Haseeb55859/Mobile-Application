import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactProfileScreen extends StatefulWidget {
  final String contactId;

  ContactProfileScreen({required this.contactId});

  @override
  _ContactProfileScreenState createState() => _ContactProfileScreenState();
}

class _ContactProfileScreenState extends State<ContactProfileScreen> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? contactData;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadContactData();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadContactData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(widget.contactId).get();
    setState(() {
      contactData = doc.data() as Map<String, dynamic>?;
    });
  }

  String _getOnlineStatus() {
    if (contactData == null) return 'Offline';
    
    bool isOnline = contactData!['isOnline'] ?? false;
    if (isOnline) return 'Online';
    
    return 'Offline';
  }

  @override
  Widget build(BuildContext context) {
    if (contactData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile'), backgroundColor: Colors.blue),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    bool isOnline = contactData!['isOnline'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),
                Hero(
                  tag: 'profile_${widget.contactId}',
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.blue.shade300,
                        child: Icon(Icons.person, size: 80, color: Colors.white),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isOnline ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  _getOnlineStatus(),
                  style: TextStyle(
                    color: isOnline ? Colors.green : Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30),
                Card(
                  margin: EdgeInsets.all(20),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person, color: Colors.blue, size: 28),
                          title: Text('Name', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          subtitle: Text(
                            contactData!['name'] ?? 'Unknown',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
                          ),
                        ),
                        Divider(height: 30),
                        ListTile(
                          leading: Icon(Icons.email, color: Colors.blue, size: 28),
                          title: Text('Email', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          subtitle: Text(
                            contactData!['email'] ?? '',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                        Divider(height: 30),
                        ListTile(
                          leading: Icon(Icons.badge, color: Colors.blue, size: 28),
                          title: Text('Contact ID', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          subtitle: Text(
                            contactData!['contactId'] ?? '',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.copy, color: Colors.blue),
                            tooltip: 'Copy Contact ID',
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: contactData!['contactId']));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Contact ID copied to clipboard'),
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}