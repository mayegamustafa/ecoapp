import 'package:e_com/main.export.dart';
import 'package:timeago/timeago.dart' as timeago;

class SellerChat {
  const SellerChat({
    required this.messages,
    required this.seller,
  });

  factory SellerChat.fromMap(Map<String, dynamic> map) {
    return SellerChat(
      messages: PagedItem<SellerMassage>.fromMap(
        map['messages'],
        (e) => SellerMassage.fromMap(e),
      ),
      seller: Seller.fromMap(map['seller']),
    );
  }

  final PagedItem<SellerMassage> messages;
  final Seller seller;

  Map<String, dynamic> toMap() {
    return {
      'messages': messages.toMap((x) => x.toMap()),
      'seller': seller.toMap(),
    };
  }

  SellerChat newMessages(
    PagedItem<SellerMassage>? messages,
  ) {
    return SellerChat(
      messages: messages ?? this.messages,
      seller: seller,
    );
  }
}

class SellerMassage {
  const SellerMassage({
    required this.id,
    required this.message,
    required this.fileMap,
    required this.isSeen,
    required this.createdAt,
    required this.isMine,
    required this.userData,
  });

  factory SellerMassage.fromMap(Map<String, dynamic> map) {
    return SellerMassage(
      id: map.parseInt('id'),
      message: map['message'],
      fileMap: List<Map>.from(map['files']),
      isSeen: map['is_seen'],
      createdAt: map['created_at'],
      isMine: map['sender_role']['role'] == 'customer',
      userData: map['sender_role']?['user'] ?? {},
    );
  }

  final String createdAt;
  final List<Map> fileMap;
  final int id;
  final bool isMine;
  final bool isSeen;
  final String message;
  final QMap userData;

  DateTime get dateTime => DateTime.parse(createdAt);

  String get readableTime => timeago.format(dateTime, locale: 'en_short');

  List<({String name, String url})> get files {
    final fileJoin = <String, String>{};
    for (final file in fileMap) {
      fileJoin.addAll(file.cast<String, String>());
    }
    return fileJoin.entries.map((e) => (name: e.key, url: e.value)).toList();
  }

  String get userName {
    return (userData['username'] ?? userData['name']) ??
        (isMine ? 'customer' : 'seller');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'files': fileMap,
      'is_seen': isSeen,
      'created_at': createdAt,
      'sender_role': {
        'role': isMine ? 'customer' : 'seller',
        'user': userData,
      },
    };
  }
}
