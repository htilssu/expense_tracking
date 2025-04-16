import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../application/service/language_service.dart';

// Events
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class ChangeLanguage extends LanguageEvent {
  final Locale locale;

  const ChangeLanguage(this.locale);

  @override
  List<Object?> get props => [locale];
}

class ResetLanguage extends LanguageEvent {}

// States
abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageChanged extends LanguageState {
  final Locale locale;

  const LanguageChanged(this.locale);

  @override
  List<Object?> get props => [locale];
}

// Bloc
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LanguageService _languageService;

  LanguageBloc(this._languageService) : super(LanguageInitial()) {
    on<ChangeLanguage>(_onChangeLanguage);
    on<ResetLanguage>(_onResetLanguage);
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    await _languageService.setLocale(event.locale);
    emit(LanguageChanged(event.locale));
  }

  Future<void> _onResetLanguage(
    ResetLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    await _languageService.resetToDefault();
    final defaultLocale = _languageService.getCurrentLocale();
    emit(LanguageChanged(defaultLocale));
  }
} 