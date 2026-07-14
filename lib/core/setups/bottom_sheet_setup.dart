import '../../app/app_setup_locator.dart';
import '../../ui/bottom_sheets/chat_bottom_sheet.dart';
import '../../ui/bottom_sheets/cities_bottom_sheet.dart';
import '../../ui/bottom_sheets/region_selector_bottom_sheet.dart';
import '../../ui/bottom_sheets/states_bottom_sheet.dart';
import '../../ui/bottom_sheets/stripe_ identity_bottom_sheet.dart';
import '../enums/bottom_sheet_type.dart';
import '../services/bottom_sheet_service.dart';

/// create a base function with a variant
/// parameter to pass an enum
Future<void> setupBottomSheetUi() async {
  final bottomSheetService = sl<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.regionSelector: (request, completer) =>
        RegionSelectorBottomSheet(request: request, completer: completer),
    BottomSheetType.fetchStates: (request, completer) =>
        StatesBottomSheet(request: request, completer: completer),
    BottomSheetType.fetchCities: (request, completer) =>
        CitiesBottomSheet(request: request, completer: completer),
    BottomSheetType.chat: (request, completer) =>
        ChatBottomSheet(request: request, completer: completer),
    BottomSheetType.verification: (request, completer) =>
        StripeIdentityBottomSheet(request: request, completer: completer),
    //     BottomSheetType.serviceProviderPlan: (request, completer) => SelectServicePlanBottomSheet(request: request, completer: completer),
    //     BottomSheetType.strings: (request, completer) => StringsBottomSheet(request: request, completer: completer),
    //     BottomSheetType.transactionType: (request, completer) => SelectTransactionTypeBottomSheet(request: request, completer: completer),
    //     BottomSheetType.transactionStatus: (request, completer) => SelectTransactionStatusBottomSheet(request: request, completer: completer),
    //     BottomSheetType.transactionTime: (request, completer) => SelectTimeFrameBottomSheet(request: request, completer: completer),
    //     BottomSheetType.verifyNumber: (request, completer) => VerifyOtpBottomSheet(request: request, completer: completer),
    //     BottomSheetType.transferPin: (request, completer) => TransferPinBottomSheet(request: request, completer: completer),
    //     BottomSheetType.manualAccounts: (request, completer) => ManualAccountsBottomSheet(request: request, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}
