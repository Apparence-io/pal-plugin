class Pageable<T> {
  int? pageNumber;
  int? offset;
  int? pageSize;
  int? totalPages;
  int? totalElements;
  int? numberOfElements;
  bool? last;
  bool? first;
  List<T>? entities;

  Pageable({
    this.pageNumber,
    this.offset,
    this.pageSize,
    this.totalPages,
    this.totalElements,
    this.numberOfElements,
    this.last,
    this.first,
    this.entities,
  });
}
