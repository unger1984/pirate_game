import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pirate/domain/usecases/locale_use_case.dart';

part 'locale_bloc.freezed.dart';

@freezed
class LocaleEvent with _$LocaleEvent {
  const LocaleEvent._();
  const factory LocaleEvent.init() = InitLocaleEvent;
  const factory LocaleEvent.change(String locale) = ChangeLocaleEvent;
}

@freezed
class LocaleState with _$LocaleState {
  const LocaleState._();
  const factory LocaleState.loading() = LoadingLocaleState;
  const factory LocaleState.success(String locale) = SuccessLocaleState;
}

class LocaleBLoC extends Bloc<LocaleEvent, LocaleState> {
  final LocaleUseCase _localeUseCase;

  LocaleBLoC({required LocaleUseCase localeUseCase})
      : _localeUseCase = localeUseCase,
        super(const LoadingLocaleState()) {
    on<LocaleEvent>(
      (event, emitter) => event.map(
        init: (event) => _init(event, emitter),
        change: (event) => _change(event, emitter),
      ),
    );

    add(const InitLocaleEvent());
  }

  Future<void> _init(_, Emitter<LocaleState> emitter) async {
    emitter(const LoadingLocaleState());
    final locale = await _localeUseCase.getLocale();
    emitter(SuccessLocaleState(locale));
  }

  void _change(ChangeLocaleEvent event, Emitter<LocaleState> emitter) async {
    _localeUseCase.setLocale(event.locale);
    emitter(SuccessLocaleState(event.locale));
  }
}
