import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppStrings {
  static const appName = 'Food Stock';
  static const cropImageString = 'Crop Image';
  static const androidString = 'Android';
  static const iosString = 'IOS';
  static const timeString = '00:00';
  static const hr24String = '24:00';
  static const tempString = 'temp';
  static const cancelString = 'Cancel';
  static const doneString = 'Done';
  static const failedToLoadString = 'Failed to load';
  static const outOfStockString = 'Out of Stock';
  static const clearString = 'Clear';
  static const deleteString = 'Delete';
  static const deliverString = 'deliver';
  static const statusString = 'status';
  static const updateString = 'Updating';


  //language Strings
  static const englishString = 'en';
  static const hebrewString = 'he';

  //api req param strings
  static const profileImageString = 'profileImg';
  static const profileUpdateString =  'profileImage';
  static const promissoryNoteString = 'promissoryNote';
  static const personalGuaranteeString = 'personalGuarantee';
  static const israelIdImageString = 'israelIdImage';
  static const businessCertificateString = 'businessCertificate';
  static const messageString = 'message';
  static const fileString = 'file';
  static const filesString = 'files';
  static const formString = 'form';
  static const formsString = 'forms';
  static const idParamString = '_id';
  static const clientDetailString = 'clientDetail';
  static const logoString = 'logo';
  static const supplierIdString = 'supplierId';
  static const companyIdString = 'companyId';
  static const ascendingString = 'asc';
  static const descendingString = 'desc';
  static const planogramSortFieldString = 'planogramName';
  static const orderNumberString = 'orderNumber';
  static const signatureString = 'signature';
  static const cartProductIdString = 'cartProductId';
  static const categoryIdString = 'catregoryId';
  static const categoryNameString = 'catregoryName';
  static const pdfString = 'PDF';
  static const jsonString = 'JSON';
  static const orderBySupplierId = 'orderSupplierId';

  //validation strings
  static const businessNameValString = 'businessNameVal';
  static const hpValString = 'hpVal';
  static const ownerNameValString = 'ownerNameVal';
  static const idValString = 'idVal';
  static const contactNameValString = 'contactNameVal';
  static const addressValString = 'addressVal';
  static const emailValString = 'emailVal';
  static const faxValString = 'faxVal';
  static const generalValString = 'generalVal';
  static const mobileValString = 'mobileVal';

  //page parameters strings
  static const mobileParamString = 'mobileParam';
  static const profileParamString = 'profileParam';
  static const isUpdateParamString = 'isUpdateParam';
  static const planogramProductsParamString = 'planogramProductsParam';
  static const messageDataString = 'messageDataParam';
  static const appContentIdString = 'appContentIdParam';
  static const appContentNameString = 'appContentNameParam';
  static const messageReadString = 'messageReadSParam';
  static const messageDeleteString = 'messageDeleteParam';
  static const searchString = 'searchParam';
  static const reqSearchString = 'reqSearchParam';
  static const searchResultString = 'searchResultParam';
  static const fromStoreCategoryString = 'fromStoreCategoryParam';

  //toast strings
  static const registerSuccessString = 'Registered Successfully!';
  static const otpResendSuccessString = 'OTP resend Successfully!';
  static const loginSuccessString = 'Logged in Successfully!';
  static const updateSuccessString = 'Updated Successfully!';
  static const addCartSuccessString = 'Product added to Cart';
  static const removeSuccessString = 'Removed Successfully!';
  static const logOutSuccessString = 'Logged out Successfully!';
  static const somethingWrongString = 'Something is wrong, try again!';
  static const minQuantityMsgString = 'Add at least 1 quantity';
  static const selectSupplierMsgString = 'Please select supplier';
  static const maxQuantityMsgString = 'You have reached maximum quantity';
  static const imageNotSetString = 'Image not set';
  static const fileSizeLimitString =
      'File size must be less then ${AppConstants.fileSizeCap}KB';
  static const selectBusinessTypeString = 'Please select your business type';
  static const uploadingMsgString = 'Please wait while uploading';
  static const selectValidDocumentFormatString =
      'Please select only jpg, jpeg, png, heic, pdf and document files';
  static const downloadString = 'Downloaded successfully!';
  static const downloadFailedString = 'Failed to download';
  static const storageAllowPermissionString =
      'Please allow storage permission from settings';
  static const cameraAllowPermissionString =
      'Please allow camera permission from settings';
  static const uploadDocumentFirstString = 'Please upload document first';
  static const openingTimeAfterPreviousClosingString =
      'Please select opening time after previous closing time';
  static const openingTimeAfterClosingString =
      'Please select opening time before closing time';
  static const closingTimeAfterOpeningString =
      'Please select closing time after opening time';
  static const selectOpeningString = 'Please select opening Time';
  static const selectPreviousShiftString = 'Please select previous shift time';
  static const selectFirstShiftString = 'Please select first shift time';
  static const selectShiftTimeString = 'Please select shift time';
  static const enterOtpString = 'Please enter otp';
  static const selectTimeMoreThen0String =
      'Please select time grater then 00:00';
  static const fillUpClosingTimeString = 'Please fill up closing time';
  static const noInternetConnection = 'No Internet Connection';
  static const enter4DigitOtpCode = 'Please enter 4 digit otp code';
  static const clearCartPopUpString = 'Are you sure you want to clear cart?';
  static const deleteProductPopUpString =
      'Are you sure you want to delete product?';
  static const selectNextDayShiftString = 'please select next day shift';

  //hint strings
  static const hintNumberString = '1234567890';

  //argument strings
  static const isRegisterString = 'isRegister';
  static const contactString = 'contact';
  static const idString = 'id';
  static const orderIdString = 'orderId';
  static const productDataString = 'productData';
  static const supplierNameString = 'supplierName';
  static const deliveryStatusString = 'deliveryStatus';
  static const totalOrderString = 'totalOrder';
  static const deliveryDateString = 'deliveryDate';
  static const quantityString = 'quantity';
  static const supplierOrderNumberString = 'supplierOrderNumber';
  static const totalAmountString = 'totalAmount';
  static const cartIdString = 'id';
  static const driverNameString = 'driverName';
  static const driverNumberString = 'driverNumber';
  static const messageIdString = 'messageId';
  static const messageIdListString = 'messageIdList';
  static const isReadMoreString = 'isReadMore';

  static String getLocalizedStrings(String key,BuildContext context){
    switch(key){
      case 'errmessage':
        return AppLocalizations.of(context).errmessage;
    }
    return '';
  }
}
