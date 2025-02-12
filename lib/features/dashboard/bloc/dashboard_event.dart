import 'package:equatable/equatable.dart';

/// Base class for all Dashboard events.
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}
