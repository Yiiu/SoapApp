class Pagination {
  Pagination({
    this.page,
    this.pageSize,
  }) {}

  int page = 1;
  int pageSize = 30;

  Map<String, int> toMap() {
    return {
      'page': page,
      'pageSize': pageSize,
    };
  }
}
