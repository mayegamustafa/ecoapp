import 'package:e_com/main.export.dart';
import 'package:timeago/timeago.dart' as timeago;

class DeliveryManChat {
  const DeliveryManChat({
    required this.messages,
    required this.deliveryMan,
  });

  final PagedItem<DeliveryManMessage> messages;
  final DeliveryMan deliveryMan;

  factory DeliveryManChat.fromMap(Map<String, dynamic> map) {
    return DeliveryManChat(
      messages: PagedItem<DeliveryManMessage>.fromMap(
        map['messages'],
        (e) => DeliveryManMessage.fromMap(e),
      ),
      deliveryMan: DeliveryMan.fromMap(map['delivery_man']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messages': messages.toMap((x) => x.toMap()),
      'delivery_man': deliveryMan.toMap(),
    };
  }

  DeliveryManChat newMessages(
    PagedItem<DeliveryManMessage>? messages,
  ) {
    return DeliveryManChat(
      messages: messages ?? this.messages,
      deliveryMan: deliveryMan,
    );
  }
}

class DeliveryManMessage {
  const DeliveryManMessage({
    required this.id,
    required this.message,
    required this.fileMap,
    required this.isSeen,
    required this.createdAt,
    required this.isMine,
    required this.userData,
  });
  factory DeliveryManMessage.fromMap(Map<String, dynamic> map) {
    return DeliveryManMessage(
      id: map.parseInt('id'),
      message: map['message'],
      fileMap: List<Map>.from(map['files']),
      isSeen: map['is_seen'],
      createdAt: map['created_at'],
      isMine: map['sender_role']?['role'] == 'customer',
      userData: map['sender_role']?['user'] ?? {},
    );
  }

  final String createdAt;
  final List<Map> fileMap;
  final int id;
  final bool isSeen;
  final String message;
  final bool isMine;
  final QMap userData;

  DateTime get dateTime => DateTime.parse(createdAt);
  String get readableTime => timeago.format(dateTime, locale: 'en_short');

  String get userName {
    return (userData['username'] ?? userData['name']) ??
        (isMine ? 'customer' : 'deliveryman');
  }

  List<({String name, String url})> get files {
    final fileJoin = <String, String>{};
    for (final file in fileMap) {
      fileJoin.addAll(file.cast<String, String>());
    }
    return fileJoin.entries.map((e) => (name: e.key, url: e.value)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'files': fileMap,
      'is_seen': isSeen,
      'created_at': createdAt,
      'sender_role': {
        'role': isMine ? 'customer' : 'deliveryman',
        'user': userData,
      },
    };
  }
}
