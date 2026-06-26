class Meta {
  final int? currentPage;
  final int? perPage;
  final int? skip;
  // for banks
  final String? next;
  final String? previous;
  // for banks
  final int? lastPage;
  final int? nextPage;
  final int? prevPage;
  final int? from;
  final int? to;

  Meta({
    this.currentPage,
    this.perPage,
    this.skip,
    // for banks
    this.next,
    this.previous,
    // for banks
    this.lastPage,
    this.nextPage,
    this.prevPage,
    this.from,
    this.to,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
        currentPage: (json['currentPage'] as num?)?.toInt(),
        perPage: (json['perPage'] as num?)?.toInt(),
        skip: (json['skip'] as num?)?.toInt(),
        // for banks
        next: json['next'] as String?,
        previous: json['previous'] as String?,
        // for banks
        lastPage: (json['lastPage'] as num?)?.toInt(),
        nextPage: (json['nextPage'] as num?)?.toInt(),
        prevPage: (json['prevPage'] as num?)?.toInt(),
        from: (json['from'] as num?)?.toInt(),
        to: (json['to'] as num?)?.toInt()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'next': next,
      'previous': previous,

      'currentPage': currentPage,
      'perPage': perPage,
      'skip': skip,
      'lastPage': lastPage,
      'nextPage': nextPage,
      'prevPage': prevPage,
      'from': from,
      'to': to,
    };
  }
}