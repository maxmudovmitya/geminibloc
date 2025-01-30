import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ngdemo23/data/%20repositories/gemini_talk_repository_impl.dart';
import 'package:ngdemo23/domain/usecases/gemini_text_only_usecase.dart';
import 'package:ngdemo23/presentation/bloc/home_event.dart';
import 'package:ngdemo23/presentation/bloc/home_state.dart';

import '../../core/services/log_service.dart';
import '../../data/models/message_model.dart';
import '../../domain/usecases/gemini_text_and_image_usecase.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  GeminiTextOnlyUseCase textOnlyUseCase = GeminiTextOnlyUseCase(
      GeminiTalkRepositoryImpl());
  GeminiTextAndImageUseCase textAndImageUseCase = GeminiTextAndImageUseCase(
      GeminiTalkRepositoryImpl());

  TextEditingController textEditingController = TextEditingController();
  List<MessageModel> messages = [];

  HomeBloc() : super(HomeInitialState()) {
    on<HomeTextOnlyEvent>(_onHomeTextOnlyEvent);
    on<HomeTextAndImageEvent>(_onHomeTextAndImageEvent);
  }

  Future<void> _onHomeTextOnlyEvent(HomeTextOnlyEvent event,
      Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    var either = await textOnlyUseCase.call(event.message);
    either.fold((l) {
      LogService.e(l);
      MessageModel gemini = MessageModel(isMine: false, message: l);
      updateMessages(gemini);
      emit(HomeFailureState());
    }, (r) {
      LogService.i(r);

      MessageModel gemini = MessageModel(isMine: false, message: r);
      updateMessages(gemini);
      emit(HomeSuccessState());
    });
  }

  Future<void> _onHomeTextAndImageEvent(HomeTextAndImageEvent event,
      Emitter<HomeState> emit) async {}


  updateMessages(MessageModel messageModel) {
    messages.add(messageModel);
  }

  void askToGemini() {
    String message = textEditingController.text.toString().trim();

    MessageModel mine = MessageModel(isMine: true, message: message);
    updateMessages(mine);

    add(HomeTextOnlyEvent(message: message));

    textEditingController.clear();
  }
}