class NotificationInfo {
  final String type;
  final List<String> args;

  NotificationInfo({
    this.type,
    this.args,
});

  static NotificationInfo fromPayload(String payload, {String typePostfix = ''}) {
    final List<String> data = payload.split(':');

    return NotificationInfo(
      type: data[0] + typePostfix,
      args: data.sublist(1),
    );
  }
}