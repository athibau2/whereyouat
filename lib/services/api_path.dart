class APIPath {
  static String event(String uid, String eventId) =>
      'users/$uid/events/$eventId';
  static String events(String uid) => 'users/$uid/events';
}
