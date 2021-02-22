// EventRepositoryクラスを定義
class EventRepository {
  // メンバ変数
  final int eventId;
  final String title;
  final String catchMessage;
  final String eventUrl;
  final String startedAt;
  final String endedAt;

  // コンストラクタ
  EventRepository({
    this.eventId,
    this.title,
    this.catchMessage,
    this.eventUrl,
    this.startedAt,
    this.endedAt,
  });

  // JSONから取得
  factory EventRepository.fromJson(Map<String, dynamic> json) {
    return EventRepository(
      eventId: json['event_id'],
      title: json['title'],
      catchMessage: json['catch'],
      eventUrl: json['event_url'],
      startedAt: json['started_at'],
      endedAt: json['ended_at'],
    );
  }

  // JSONへ
  Map<String, dynamic> toJson() => {
        'event_id': eventId,
        'title': title,
        'catch': catchMessage,
        'event_url': eventUrl,
        'started_at': startedAt,
        'ended_at': endedAt,
      };
}
