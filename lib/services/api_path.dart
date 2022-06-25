class APIPath {
  static String userEvent(String uid, String eventId) =>
      'users/$uid/events/$eventId';
  static String userEvents(String uid) => 'users/$uid/events';
  static String event(String eventId) => 'events/$eventId';
  static String events() => 'events';
}
