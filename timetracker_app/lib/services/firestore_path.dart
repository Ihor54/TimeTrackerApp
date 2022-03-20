class FirestorePath {
  static String jobs(String uid) => 'users/$uid/jobs';
  static String job(String uid, String jobUid) => 'users/$uid/jobs/$jobUid';
}
