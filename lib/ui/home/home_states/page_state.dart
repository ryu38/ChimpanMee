import 'package:chimpanmee/ui/home/camera/camera_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  factory HomeState({
    required AppPage currentPage,
  }) = _HomeState;
}

final homeStateProvider = StateNotifierProvider<HomeStateNotifier, HomeState>(
  (ref) => HomeStateNotifier(read: ref.read),
);

class HomeStateNotifier extends StateNotifier<HomeState> {
  HomeStateNotifier({
    required this.read,
    AppPage currentPage = AppPage.gallery,
  }) : super(HomeState(
    currentPage: currentPage,
  ));

  final Reader read;

  void moveToPage(AppPage page) {
    state = state.copyWith(
      currentPage: page,
    );
  }
}

enum AppPage { camera, gallery, web }
