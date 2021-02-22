import 'package:flutter_code_practice_app/model/event_model.dart';

class ConnpassRepository {
  final int resultsReturned;
  final int resultsStart;
  final List<EventRepository> events;

  ConnpassRepository({
    this.resultsReturned,
    this.events,
    this.resultsStart,
  });

  factory ConnpassRepository.fromJson(Map<String, dynamic> json) {
    return ConnpassRepository(
        resultsReturned: json['results_returned'],
        resultsStart: json['results_start'],
        events: json['events'] != null
            ? json['events']
                .map<EventRepository>((e) => EventRepository.fromJson(e))
                .toList()
            : null);
  }
}
