class Review {
  final int score;
  final String? review;

  Review({required this.score, required this.review});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"score": score};
    if (review != null) {
      map["review"] = review;
    }
    return map;
  }
}
