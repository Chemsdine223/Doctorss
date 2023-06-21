part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthSuccess extends AuthState {
  @override
  List<Object> get props => [];
}


class MedecinLogin extends AuthState {
  @override
  List<Object> get props => [];
}


class AuthError extends AuthState {
  @override
  List<Object> get props => [];
}



class InscriptionSuccess extends AuthState {
  @override
  List<Object> get props => [];
}


class InscriptionError extends AuthState {
  @override
  List<Object> get props => [];
}


class InscriptionLoading extends AuthState {
  @override
  List<Object> get props => [];
}
