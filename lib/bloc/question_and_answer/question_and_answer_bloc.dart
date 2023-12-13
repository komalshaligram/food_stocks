import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/model/req_model/get_qna_req_model/get_qna_req_model.dart';
import 'package:food_stock/data/model/res_model/get_qna_res_model/get_qna_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';


part 'question_and_answer_event.dart';

part 'question_and_answer_state.dart';

part 'question_and_answer_bloc.freezed.dart';

class QuestionAndAnswerBloc
    extends Bloc<QuestionAndAnswerEvent, QuestionAndAnswerState> {
  QuestionAndAnswerBloc() : super(QuestionAndAnswerState.initial()) {
    on<QuestionAndAnswerEvent>((event, emit) async {
      if (event is _GetQNAListEvent) {
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfQNA) {
          return;
        }
        try {
          emit(state.copyWith(
              isShimmering: state.pageNum == 0 ? true : false,
              isLoadMore: state.pageNum == 0 ? false : true));
          final res = await DioClient(event.context).post(AppUrls.getAllQNAUrl,
              data: GetQnaReqModel(
                      pageNum: state.pageNum + 1,
                      pageLimit: AppConstants.qnaPageLimit)
                  .toJson());
          GetQnaResModel response = GetQnaResModel.fromJson(res);
          if (response.status == 200) {
            List<Datum> qnaList = state.qnaList.toList(growable: true);
            qnaList.addAll(response.data?.data
                    ?.map((qna) => Datum(
                        id: qna.id, question: qna.question, answer: qna.answer))
                    .toList() ??
                []);
            debugPrint('new qna list len = ${qnaList.length}');
            emit(state.copyWith(
                qnaList: qnaList,
                pageNum: state.pageNum + 1,
                isLoadMore: false,
                isShimmering: false));
            emit(state.copyWith(
                isBottomOfQNA:
                    qnaList.length == (response.data?.totalRecords ?? 0)
                        ? true
                        : false));
          } else {
            emit(state.copyWith(isLoadMore: false));
            showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? 'something_is_wrong_try_again',event.context),
                bgColor: AppColors.mainColor);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
      }
    });
  }
}
