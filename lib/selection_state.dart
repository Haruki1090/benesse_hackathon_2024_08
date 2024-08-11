import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'selection_state.freezed.dart';
part 'selection_state.g.dart';

@freezed
class SelectionState with _$SelectionState {
  const factory SelectionState({
    String? purpose,
    String? goal,
    String? community,
  }) = _SelectionState;

  factory SelectionState.fromJson(Map<String, dynamic> json) =>
      _$SelectionStateFromJson(json);
}

final selectionProvider =
    StateNotifierProvider<SelectionNotifier, SelectionState>((ref) {
  return SelectionNotifier();
});

class SelectionNotifier extends StateNotifier<SelectionState> {
  SelectionNotifier() : super(const SelectionState());

  void setPurpose(String purpose) {
    state = state.copyWith(purpose: purpose);
  }

  void setGoal(String goal) {
    state = state.copyWith(goal: goal);
  }

  void setCommunity(String community) {
    state = state.copyWith(community: community);
  }
}
