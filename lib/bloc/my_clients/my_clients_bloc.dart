import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/req_model/get_agent_clients_permitted_suppliers_req_model/get_agent_stores_permitted_suppliers_req_model.dart';
import '../../data/model/req_model/update_agent_stores_no_minimum_req/update_agent_stores_no_minimum_req_model.dart';
import '../../data/model/res_model/get_agent_clients_permitted_suppliers_res_model/get_agent_clients_permitted_suppliers_res_model.dart';
import '../../data/model/res_model/login_otp_res_model/login_otp_res_model.dart';
import '../../data/model/res_model/update_agent_stores_no_minimum_res/update_agent_stores_no_minimum_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';

part 'my_clients_event.dart';
part 'my_clients_state.dart';
part 'my_clients_bloc.freezed.dart';

class MyClientsBloc extends Bloc<MyClientsEvent, MyClientsState> {
  MyClientsBloc() : super(MyClientsState.initial()) {
    on<MyClientsEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _getAgentClientsListEvent) {
        emit(state.copyWith(isShimmering: true, clientsList: []));
        try {
          GetAgentClientsPermittedSuppliersReqModel reqMap = GetAgentClientsPermittedSuppliersReqModel(agentPhoneNumber: preferences.getPhoneNumber());
          final res = await DioClient(event.context).post(AppUrlEndPoints.getAgentStoresWithPermittedSuppliers, data: reqMap);
          GetAgentClientsPermittedSuppliersResModel response = GetAgentClientsPermittedSuppliersResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(
              isShimmering: false,
              clientsList: List.from(response.data?.agentStores ?? []),
              filteredClientsList: List.from(response.data?.agentStores ?? []),
              language: preferences.getAppLanguage(),
            ));
            emit(state.copyWith(isBottomOfProducts: state.clientsList.length == List.from(response.data?.agentStores ?? []).length ? true : false));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } catch (_) {}
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      } else if (event is _switchAccountEvent) {
        emit(state.copyWith(isLoading: true));
        try {
          var reqMap = {'isStore': true};
          final res = await DioClient(event.context).post(AppUrlEndPoints.agentSwitchToAssignedStore + event.clientsId, data: reqMap);
          LoginOtpResModel response = LoginOtpResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            preferences.setCartId(cartId: response.data?.cartId ?? '');
            preferences.setAuthToken(accToken: response.data?.authToken?.accessToken ?? '');
            preferences.setRefreshToken(refToken: response.data?.authToken?.refreshToken ?? '');
            preferences.setUserId(id: (response.data?.adminType == AppStrings.subUserString) ? response.data?.user?.createdBy ?? '' : response.data?.user?.id ?? '');
            if (response.data?.adminType == AppStrings.subUserString) {
              preferences.setUserName(name: response.data?.user?.contactName ?? '');
            } else {
              preferences.setUserName(name: response.data?.user?.clientDetail?.ownerName ?? '');
            }
            preferences.setUserImageUrl(imageUrl: response.data?.user?.profileImage ?? '');
            preferences.setUserLoggedIn(isLoggedIn: true);
            preferences.setWalletId(userWalletId: response.data?.wallet ?? '');
            preferences.setIsSubUser(isSubUser: (response.data?.adminType == AppStrings.subUserString) ? true : false);
            preferences.setEmailId(userEmailId: response.data?.user?.email ?? '');
            preferences.setClubAgentId(clubAgentId: response.data?.agentId ?? '');
            preferences.setIsAgent(isAgent: response.data?.isAgent ?? false);
            preferences.setIsAgentSwitchToAssignedStore(isAgentSwitchToAssignedStore: response.data?.isAgentSwitchToAssignedStore ?? false);

            if (response.data?.adminType == AppStrings.subUserString) {
              var res = response.data?.subUserPermissions;
              preferences.setSubUserId(id: response.data?.user?.id ?? '');
              preferences.setCanSeeWallet(isSeeWallet: res?.canSeeWallet ?? false);
              preferences.setCanAddBasket(isAddBasket: res?.canAddToCart ?? false);
              preferences.setCanCreateOrder(isCreateOrder: res?.canCreateOrder ?? false);
              preferences.setCanSeeOrder(isSeeOrder: res?.canSeeOrders ?? false);
              preferences.setCanDuplicateOrder(isDuplicateOrder: res?.canDuplicateOrders ?? false);
              preferences.setCanUpdateBusinessInfo(isUpdateBusinessInfo: res?.canSeeAndUpdateBusinessInfo ?? false);
              preferences.setCanUpdateAdditionalInfo(isUpdateAdditionalInfo: res?.canSeeAndUpdateAdditionalInfo ?? false);
              preferences.setCanUpdateTimeInfo(isUpdateTimeInfo: res?.canSeeAndUpdateTimesInfo ?? false);
              preferences.setCanSeeFormsFiles(isSeeFormsFiles: res?.canSeeFileAndForms ?? false);
              preferences.setManageSubUser(isManageSubUser: res?.canManageSubUsers ?? false);
            }
            emit(state.copyWith(isLoading: false));
            Navigator.pushNamedAndRemoveUntil(event.context, RouteDefine.bottomNavScreen.name, (Route route) => route.isFirst);
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings('${AppLocalizations.of(event.context)!.switch_client_message}${event.clientName} , ${event.businessName!}', event.context),
              type: SnackBarType.success,
            );
          } else if (response.status == AppConstants.code_400) {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
            emit(state.copyWith(isShimmering: false));
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
              type: SnackBarType.failure,
            );
          }
        } catch (_) {}
      } else if (event is _updateAgentClientsNoMinimumEvent) {
        emit(state.copyWith(isShimmering: true, clientsList: []));
        try {
          UpdateAgentStoresNoMinimumReqModel reqMap = UpdateAgentStoresNoMinimumReqModel(supplierId: event.supplierId, storeId: event.clientsId, isNoMinimum: event.isNoMinimum);
          final res = await DioClient(event.context).post(AppUrlEndPoints.updateAgentStoresNoMinimumForPermittedSuppliers, data: reqMap);
          UpdateAgentStoresNoMinimumResModel response = UpdateAgentStoresNoMinimumResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            state.searchController.clear();
            emit(state.copyWith(searchQuery: '', filteredClientsList: []));
            add(MyClientsEvent.getAgentClientsListEvent(context: event.context));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } catch (_) {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _refreshListEvent) {
        state.searchController.clear();
        emit(state.copyWith(clientsList: [], filteredClientsList: [], isBottomOfProducts: false, searchQuery: ''));
        add(MyClientsEvent.getAgentClientsListEvent(context: event.context));
      } else if (event is _SearchClients) {
        final query = event.query.toLowerCase();

        if (query.isEmpty) {
          emit(state.copyWith(filteredClientsList: state.clientsList, searchQuery: ''));
          return;
        }

        final filtered = state.clientsList.where((client) {
          return (client.storeName ?? '').toLowerCase().contains(query) || (client.storeRepresentativeName ?? '').toLowerCase().contains(query) ||
              (client.address ?? '').toLowerCase().contains(query) || (client.storePhoneNumber ?? '').toLowerCase().contains(query);
        }).toList();

        emit(state.copyWith(filteredClientsList: filtered, searchQuery: query));
      }
    });
  }
}
