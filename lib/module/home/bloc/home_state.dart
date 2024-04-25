import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final double? temperature;
  final int? pressure;
  final int? humidity;
  final int? cloudCover;
  final String cityName;

  const HomeLoaded({
    required this.temperature,
    required this.pressure,
    required this.humidity,
    required this.cloudCover,
    required this.cityName,
  });

  @override
  List<Object?> get props => [temperature, pressure, humidity, cloudCover, cityName];
}

class HomeError extends HomeState {}
