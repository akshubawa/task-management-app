import 'package:equatable/equatable.dart';

/// Domain entity for pagination metadata.
class TaskPaginationEntity extends Equatable {
  const TaskPaginationEntity({
    required this.totalRecords,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int limit;
  final bool hasNextPage;
  final bool hasPreviousPage;

  @override
  List<Object?> get props =>
      [totalRecords, totalPages, currentPage, limit, hasNextPage, hasPreviousPage];
}
