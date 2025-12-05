import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'contact_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final String contactId;
  final String contactName;
  final String? contactImage;

  ChatScreen({
    required this.contactId,
    required this.contactName,
    this.contactImage,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final _messageController = TextEditingController();
  List<String> selectedMessages = [];
  bool isSelectionMode = false;
  bool isTyping = false;
  Timer? _typingTimer;
  bool contactIsTyping = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _messageController.addListener(_onTypingChanged);
    _listenToTypingStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.removeListener(_onTypingChanged);
    _messageController.dispose();
    _typingTimer?.cancel();
    _updateTypingStatus(false);
    super.dispose();
  }

  void _onTypingChanged() {
    if (_messageController.text.isNotEmpty && !isTyping) {
      _updateTypingStatus(true);
    }
    
    _typingTimer?.cancel();
    _typingTimer = Timer(Duration(seconds: 2), () {
      if (isTyping) {
        _updateTypingStatus(false);
      }
    });
  }

  Future<void> _updateTypingStatus(bool typing) async {
    if (isTyping != typing) {
      setState(() {
        isTyping = typing;
      });
      String chatId = _getChatId();
      await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        '${currentUserId}_typing': typing,
      }, SetOptions(merge: true));
    }
  }

  void _listenToTypingStatus() {
    String chatId = _getChatId();
    FirebaseFirestore.instance.collection('chats').doc(chatId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        bool typing = snapshot.data()?['${widget.contactId}_typing'] ?? false;
        if (mounted) {
          setState(() {
            contactIsTyping = typing;
          });
        }
      }
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

  String _getChatId() {
    List<String> ids = [currentUserId, widget.contactId];
    ids.sort();
    return ids.join('_');
  }

  Future<void> _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    _updateTypingStatus(false);

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(_getChatId())
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'receiverId': widget.contactId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });

    // Send notification to other user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.contactId)
        .collection('notifications')
        .add({
      'from': currentUserId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });
  }

  Future<void> _deleteSelectedMessages() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Messages'),
        content: Text('Delete ${selectedMessages.length} selected message(s)?'),
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
      for (String messageId in selectedMessages) {
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(_getChatId())
            .collection('messages')
            .doc(messageId)
            .delete();
      }
      setState(() {
        selectedMessages.clear();
        isSelectionMode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Messages deleted'), backgroundColor: Colors.green),
      );
    }
  }

  String _getOnlineStatus(Map<String, dynamic>? userData) {
    if (userData == null) return 'Offline';
    
    bool isOnline = userData['isOnline'] ?? false;
    if (isOnline) return 'Online';
    
    Timestamp? lastSeen = userData['lastSeen'];
    if (lastSeen == null) return 'Offline';
    
    DateTime lastSeenTime = lastSeen.toDate();
    Duration diff = DateTime.now().difference(lastSeenTime);
    
    if (diff.inSeconds < 60) return 'Last seen just now';
    if (diff.inMinutes < 60) return 'Last seen ${diff.inMinutes}m ago';
    if (diff.inHours < 24) return 'Last seen ${diff.inHours}h ago';
    return 'Last seen ${DateFormat('MMM d').format(lastSeenTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (isSelectionMode) {
              setState(() {
                isSelectionMode = false;
                selectedMessages.clear();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(widget.contactId).snapshots(),
          builder: (context, snapshot) {
            Map<String, dynamic>? userData = snapshot.data?.data() as Map<String, dynamic>?;
            bool isOnline = userData?['isOnline'] ?? false;
            
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactProfileScreen(
                      contactId: widget.contactId,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.blue),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: isOnline ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.contactName,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            contactIsTyping ? 'typing...' : _getOnlineStatus(userData),
                            key: ValueKey(contactIsTyping),
                            style: TextStyle(
                              fontSize: 12,
                              color: contactIsTyping ? Colors.greenAccent : Colors.white70,
                              fontStyle: contactIsTyping ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedMessages,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(_getChatId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
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
                        Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'No messages yet',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Send a message to start chatting',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    bool isSentByMe = message['senderId'] == currentUserId;
                    bool isSelected = selectedMessages.contains(message.id);
                    Timestamp? timestamp = message['timestamp'];

                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          isSelectionMode = true;
                          if (!selectedMessages.contains(message.id)) {
                            selectedMessages.add(message.id);
                          }
                        });
                      },
                      onTap: () {
                        if (isSelectionMode) {
                          setState(() {
                            if (isSelected) {
                              selectedMessages.remove(message.id);
                            } else {
                              selectedMessages.add(message.id);
                            }
                            if (selectedMessages.isEmpty) {
                              isSelectionMode = false;
                            }
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            if (isSelectionMode)
                              Checkbox(
                                value: isSelected,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      selectedMessages.add(message.id);
                                    } else {
                                      selectedMessages.remove(message.id);
                                    }
                                    if (selectedMessages.isEmpty) {
                                      isSelectionMode = false;
                                    }
                                  });
                                },
                              ),
                            Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSentByMe ? Colors.blue.shade400 : Colors.grey.shade300,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomLeft: isSentByMe ? Radius.circular(16) : Radius.circular(0),
                                  bottomRight: isSentByMe ? Radius.circular(0) : Radius.circular(16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['message'],
                                    style: TextStyle(
                                      color: isSentByMe ? Colors.white : Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    timestamp != null
                                        ? DateFormat('hh:mm a').format(timestamp.toDate())
                                        : '',
                                    style: TextStyle(
                                      color: isSentByMe ? Colors.white70 : Colors.black54,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}