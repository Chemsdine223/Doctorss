import 'package:bloc/bloc.dart';
import 'package:doctors/Data/Models/users.dart';
import 'package:doctors/Data/auth_service.dart';
import 'package:equatable/equatable.dart';

part 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  // final PatientRepo patientRepo; // Assuming you have a PatientRepo class

  PatientCubit() : super(PatientInitial()) {
    getPatientData();
  }

  Future<void> getPatientData() async {
    emit(PatientLoading());
    try {
      final response = await PatientRepo().getPatientData();
      emit(PatientLoaded(response));
    } catch (e) {
      emit(PatientError());
    }
  }
}
