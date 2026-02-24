import 'package:flutter_bloc/flutter_bloc.dart';

/// A Cubit that safely ignores `emit()` calls after it has been closed.
///
/// This prevents runtime crashes when async work completes after the UI that
/// owns the Cubit has been disposed.
abstract class SafeCubit<State> extends Cubit<State> {
  SafeCubit(super.initialState);

  @override
  void emit(State state) {
    if (isClosed) {
      return;
    }
    super.emit(state);
  }
}
