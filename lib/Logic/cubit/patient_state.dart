part of 'patient_cubit.dart';

abstract class PatientState extends Equatable {
  // const PatientState();

  // @override
  // List<Object> get props => [];
}

class PatientInitial extends PatientState {
  @override
  List<Object> get props => [];
}

class PatientLoading extends PatientState {
  @override
  List<Object> get props => [];
}

class PatientLoaded extends PatientState {
  final Patient patient;

  PatientLoaded(this.patient);

  @override
  List<Object> get props => [patient];
}

class PatientError extends PatientState {
  @override
  List<Object> get props => [];
}
