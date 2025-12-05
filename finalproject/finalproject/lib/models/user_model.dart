class ChatUser {
  final String name;
  final String userId;

  ChatUser({required this.name, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'contacts': [], // default empty
    };
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      name: map['name'],
      userId: map['userId'],
    );
  }
}
