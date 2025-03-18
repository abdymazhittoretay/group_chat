class MessageModel {
  final String message;
  final String? sentBy;
  final DateTime date;

  MessageModel({
    required this.message,
    required this.sentBy,
    required this.date,
  });
}
