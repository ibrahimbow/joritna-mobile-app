enum ShareAndHelpPostStatus {
  open,
  resolved;

  static ShareAndHelpPostStatus fromJson(String value) {
    return switch (value) {
      'OPEN' => ShareAndHelpPostStatus.open,
      'RESOLVED' => ShareAndHelpPostStatus.resolved,
      _ => ShareAndHelpPostStatus.open,
    };
  }

  String toJson() {
    return switch (this) {
      ShareAndHelpPostStatus.open => 'OPEN',
      ShareAndHelpPostStatus.resolved => 'RESOLVED',
    };
  }

  bool get isResolved => this == ShareAndHelpPostStatus.resolved;
}