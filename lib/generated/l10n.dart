// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hebrew Language`
  String get app_language {
    return Intl.message(
      'Hebrew Language',
      name: 'app_language',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Business Info`
  String get business_details {
    return Intl.message(
      'Business Info',
      name: 'business_details',
      desc: '',
      args: [],
    );
  }

  /// `Type of Picture`
  String get type_of_picture {
    return Intl.message(
      'Type of Picture',
      name: 'type_of_picture',
      desc: '',
      args: [],
    );
  }

  /// `Business Type`
  String get type_of_business {
    return Intl.message(
      'Business Type',
      name: 'type_of_business',
      desc: '',
      args: [],
    );
  }

  /// `Profile Image`
  String get profile_picture {
    return Intl.message(
      'Profile Image',
      name: 'profile_picture',
      desc: '',
      args: [],
    );
  }

  /// `Institutional`
  String get institutional {
    return Intl.message(
      'Institutional',
      name: 'institutional',
      desc: '',
      args: [],
    );
  }

  /// `Business Name`
  String get business_name {
    return Intl.message(
      'Business Name',
      name: 'business_name',
      desc: '',
      args: [],
    );
  }

  /// `business address`
  String get address {
    return Intl.message(
      'business address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Owner Name`
  String get name_of_owner {
    return Intl.message(
      'Owner Name',
      name: 'name_of_owner',
      desc: '',
      args: [],
    );
  }

  /// `NEXT`
  String get next {
    return Intl.message('NEXT', name: 'next', desc: '', args: []);
  }

  /// `More Info`
  String get more_details {
    return Intl.message('More Info', name: 'more_details', desc: '', args: []);
  }

  /// `Client Info`
  String get client_form_details {
    return Intl.message(
      'Client Info',
      name: 'client_form_details',
      desc: '',
      args: [],
    );
  }

  /// `Full Address`
  String get full_address {
    return Intl.message(
      'Full Address',
      name: 'full_address',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Fax`
  String get fax {
    return Intl.message('Fax', name: 'fax', desc: '', args: []);
  }

  /// `Contact Name`
  String get contact_name {
    return Intl.message(
      'Contact Name',
      name: 'contact_name',
      desc: '',
      args: [],
    );
  }

  /// `Logo Image`
  String get logo_image {
    return Intl.message('Logo Image', name: 'logo_image', desc: '', args: []);
  }

  /// `Upload Image`
  String get upload_photo {
    return Intl.message(
      'Upload Image',
      name: 'upload_photo',
      desc: '',
      args: [],
    );
  }

  /// `Activity Time`
  String get activity_time {
    return Intl.message(
      'Activity Time',
      name: 'activity_time',
      desc: '',
      args: [],
    );
  }

  /// `Until Time`
  String get until_time {
    return Intl.message('Until Time', name: 'until_time', desc: '', args: []);
  }

  /// `From Time`
  String get from_time {
    return Intl.message('From Time', name: 'from_time', desc: '', args: []);
  }

  /// `Sunday`
  String get sunday {
    return Intl.message('Sunday', name: 'sunday', desc: '', args: []);
  }

  /// `Monday`
  String get monday {
    return Intl.message('Monday', name: 'monday', desc: '', args: []);
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message('Wednesday', name: 'wednesday', desc: '', args: []);
  }

  /// `Thursday`
  String get thursday {
    return Intl.message('Thursday', name: 'thursday', desc: '', args: []);
  }

  /// `Friday & Holiday`
  String get friday_and_holiday_eves {
    return Intl.message(
      'Friday & Holiday',
      name: 'friday_and_holiday_eves',
      desc: '',
      args: [],
    );
  }

  /// `Israel ID Number`
  String get israel_id {
    return Intl.message(
      'Israel ID Number',
      name: 'israel_id',
      desc: '',
      args: [],
    );
  }

  /// `This month's expenses`
  String get this_months_expenses {
    return Intl.message(
      'This month\'s expenses',
      name: 'this_months_expenses',
      desc: '',
      args: [],
    );
  }

  /// `Orders this month`
  String get this_months_orders {
    return Intl.message(
      'Orders this month',
      name: 'this_months_orders',
      desc: '',
      args: [],
    );
  }

  /// `General framework`
  String get general_framework {
    return Intl.message(
      'General framework',
      name: 'general_framework',
      desc: '',
      args: [],
    );
  }

  /// `Last month's expenses`
  String get last_months_expenses {
    return Intl.message(
      'Last month\'s expenses',
      name: 'last_months_expenses',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance_status {
    return Intl.message('Balance', name: 'balance_status', desc: '', args: []);
  }

  /// `₪`
  String get currency {
    return Intl.message('₪', name: 'currency', desc: '', args: []);
  }

  /// `All Sales`
  String get all_sales {
    return Intl.message('All Sales', name: 'all_sales', desc: '', args: []);
  }

  /// `Sales`
  String get sales {
    return Intl.message('Sales', name: 'sales', desc: '', args: []);
  }

  /// `My Basket`
  String get my_basket {
    return Intl.message('My Basket', name: 'my_basket', desc: '', args: []);
  }

  /// `New Order`
  String get new_order {
    return Intl.message('New Order', name: 'new_order', desc: '', args: []);
  }

  /// `All Messages`
  String get all_messages {
    return Intl.message(
      'All Messages',
      name: 'all_messages',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Read More`
  String get read_more {
    return Intl.message('Read More', name: 'read_more', desc: '', args: []);
  }

  /// `Menu`
  String get menu {
    return Intl.message('Menu', name: 'menu', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `My Orders`
  String get my_orders {
    return Intl.message('My Orders', name: 'my_orders', desc: '', args: []);
  }

  /// `FAQ`
  String get questions_and_answers {
    return Intl.message(
      'FAQ',
      name: 'questions_and_answers',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get terms_of_use {
    return Intl.message(
      'Terms and Conditions',
      name: 'terms_of_use',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contact_us {
    return Intl.message('Contact Us', name: 'contact_us', desc: '', args: []);
  }

  /// `About the App`
  String get about_the_app {
    return Intl.message(
      'About the App',
      name: 'about_the_app',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get editing {
    return Intl.message('Edit', name: 'editing', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `Order Status`
  String get order_status {
    return Intl.message(
      'Order Status',
      name: 'order_status',
      desc: '',
      args: [],
    );
  }

  /// `Order Date`
  String get order_date {
    return Intl.message('Order Date', name: 'order_date', desc: '', args: []);
  }

  /// `Suppliers`
  String get suppliers {
    return Intl.message('Suppliers', name: 'suppliers', desc: '', args: []);
  }

  /// `All Suppliers`
  String get all_suppliers {
    return Intl.message(
      'All Suppliers',
      name: 'all_suppliers',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message('Products', name: 'products', desc: '', args: []);
  }

  /// `Pending`
  String get pending_delivery {
    return Intl.message(
      'Pending',
      name: 'pending_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Received All`
  String get received {
    return Intl.message('Received All', name: 'received', desc: '', args: []);
  }

  /// `City of business`
  String get city {
    return Intl.message('City of business', name: 'city', desc: '', args: []);
  }

  /// `Enter your phone number`
  String get enter_your_phone {
    return Intl.message(
      'Enter your phone number',
      name: 'enter_your_phone',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Enter the OTP code`
  String get enter_the_code_sent_to_phone_num {
    return Intl.message(
      'Enter the OTP code',
      name: 'enter_the_code_sent_to_phone_num',
      desc: '',
      args: [],
    );
  }

  /// `Did not get the code ?`
  String get not_receive_verification_code {
    return Intl.message(
      'Did not get the code ?',
      name: 'not_receive_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Send Again`
  String get send_again {
    return Intl.message('Send Again', name: 'send_again', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Files`
  String get files {
    return Intl.message('Files', name: 'files', desc: '', args: []);
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `Download`
  String get download {
    return Intl.message('Download', name: 'download', desc: '', args: []);
  }

  /// `Promissory Note`
  String get promissory_note {
    return Intl.message(
      'Promissory Note',
      name: 'promissory_note',
      desc: '',
      args: [],
    );
  }

  /// `Personal Guarantee`
  String get personal_guarantee {
    return Intl.message(
      'Personal Guarantee',
      name: 'personal_guarantee',
      desc: '',
      args: [],
    );
  }

  /// `photo of T.Z.`
  String get photo_tz {
    return Intl.message('photo of T.Z.', name: 'photo_tz', desc: '', args: []);
  }

  /// `Business Certificate`
  String get business_certificate {
    return Intl.message(
      'Business Certificate',
      name: 'business_certificate',
      desc: '',
      args: [],
    );
  }

  /// `Saturday & Holidays`
  String get saturday_and_holidays {
    return Intl.message(
      'Saturday & Holidays',
      name: 'saturday_and_holidays',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message('Tuesday', name: 'tuesday', desc: '', args: []);
  }

  /// `Business ID number`
  String get business_id {
    return Intl.message(
      'Business ID number',
      name: 'business_id',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Companies`
  String get companies {
    return Intl.message('Companies', name: 'companies', desc: '', args: []);
  }

  /// `All Companies`
  String get all_companies {
    return Intl.message(
      'All Companies',
      name: 'all_companies',
      desc: '',
      args: [],
    );
  }

  /// `Total Order`
  String get total_order {
    return Intl.message('Total Order', name: 'total_order', desc: '', args: []);
  }

  /// `Delivery date`
  String get delivery_date {
    return Intl.message(
      'Delivery date',
      name: 'delivery_date',
      desc: '',
      args: [],
    );
  }

  /// `Received All`
  String get everything_was_received {
    return Intl.message(
      'Received All',
      name: 'everything_was_received',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get log_out {
    return Intl.message('Log Out', name: 'log_out', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Supplier order number`
  String get supplier_order_number {
    return Intl.message(
      'Supplier order number',
      name: 'supplier_order_number',
      desc: '',
      args: [],
    );
  }

  /// `Driver Name`
  String get driver_name {
    return Intl.message('Driver Name', name: 'driver_name', desc: '', args: []);
  }

  /// `Order products list`
  String get order_products_list {
    return Intl.message(
      'Order products list',
      name: 'order_products_list',
      desc: '',
      args: [],
    );
  }

  /// `Return products list`
  String get return_products_list {
    return Intl.message(
      'Return products list',
      name: 'return_products_list',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get product_Name {
    return Intl.message(
      'Product Name',
      name: 'product_Name',
      desc: '',
      args: [],
    );
  }

  /// `Product Issue`
  String get product_issue {
    return Intl.message(
      'Product Issue',
      name: 'product_issue',
      desc: '',
      args: [],
    );
  }

  /// `Shipment Verification`
  String get shipment_verification {
    return Intl.message(
      'Shipment Verification',
      name: 'shipment_verification',
      desc: '',
      args: [],
    );
  }

  /// `Driver Return`
  String get driver_return {
    return Intl.message(
      'Driver Return',
      name: 'driver_return',
      desc: '',
      args: [],
    );
  }

  /// `Signature`
  String get signature {
    return Intl.message('Signature', name: 'signature', desc: '', args: []);
  }

  /// `Driver Signature`
  String get driver_signature {
    return Intl.message(
      'Driver Signature',
      name: 'driver_signature',
      desc: '',
      args: [],
    );
  }

  /// `All Categories`
  String get all_categories {
    return Intl.message(
      'All Categories',
      name: 'all_categories',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Recommended for You`
  String get recommended_for_you {
    return Intl.message(
      'Recommended for You',
      name: 'recommended_for_you',
      desc: '',
      args: [],
    );
  }

  /// `All Recommended`
  String get all_recommended {
    return Intl.message(
      'All Recommended',
      name: 'all_recommended',
      desc: '',
      args: [],
    );
  }

  /// `from your previous orders`
  String get from_your_previous_orders {
    return Intl.message(
      'from your previous orders',
      name: 'from_your_previous_orders',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Note`
  String get note {
    return Intl.message('Note', name: 'note', desc: '', args: []);
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `Add to Order`
  String get add_to_order {
    return Intl.message(
      'Add to Order',
      name: 'add_to_order',
      desc: '',
      args: [],
    );
  }

  /// `Sale`
  String get sale {
    return Intl.message('Sale', name: 'sale', desc: '', args: []);
  }

  /// `Main`
  String get main {
    return Intl.message('Main', name: 'main', desc: '', args: []);
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Problem Detected`
  String get problem_detected {
    return Intl.message(
      'Problem Detected',
      name: 'problem_detected',
      desc: '',
      args: [],
    );
  }

  /// `Product did not arrive at all`
  String get product_did_not_arrive_at_all {
    return Intl.message(
      'Product did not arrive at all',
      name: 'product_did_not_arrive_at_all',
      desc: '',
      args: [],
    );
  }

  /// `Product arrived damaged`
  String get product_arrived_damaged {
    return Intl.message(
      'Product arrived damaged',
      name: 'product_arrived_damaged',
      desc: '',
      args: [],
    );
  }

  /// `Product arrived incomplete`
  String get product_arrived_incomplete {
    return Intl.message(
      'Product arrived incomplete',
      name: 'product_arrived_incomplete',
      desc: '',
      args: [],
    );
  }

  /// `Expiration date issue`
  String get expiration_date_issue {
    return Intl.message(
      'Expiration date issue',
      name: 'expiration_date_issue',
      desc: '',
      args: [],
    );
  }

  /// `Wrong product received`
  String get wrong_product_received {
    return Intl.message(
      'Wrong product received',
      name: 'wrong_product_received',
      desc: '',
      args: [],
    );
  }

  /// `Add Text`
  String get add_text {
    return Intl.message('Add Text', name: 'add_text', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Continue`
  String get continues {
    return Intl.message('Continue', name: 'continues', desc: '', args: []);
  }

  /// `Contact`
  String get contact {
    return Intl.message('Contact', name: 'contact', desc: '', args: []);
  }

  /// `Empty`
  String get empty {
    return Intl.message('Empty', name: 'empty', desc: '', args: []);
  }

  /// `Order Summary`
  String get order_summary {
    return Intl.message(
      'Order Summary',
      name: 'order_summary',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Name`
  String get supplier_name {
    return Intl.message(
      'Supplier Name',
      name: 'supplier_name',
      desc: '',
      args: [],
    );
  }

  /// `Send Order`
  String get send_order {
    return Intl.message('Send Order', name: 'send_order', desc: '', args: []);
  }

  /// `Planogram`
  String get planogram {
    return Intl.message('Planogram', name: 'planogram', desc: '', args: []);
  }

  /// `Order sent successfully`
  String get order_sent_successfully {
    return Intl.message(
      'Order sent successfully',
      name: 'order_sent_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Total Credit`
  String get total_credit {
    return Intl.message(
      'Total Credit',
      name: 'total_credit',
      desc: '',
      args: [],
    );
  }

  /// `Back to Home Page`
  String get back_to_home_page {
    return Intl.message(
      'Back to Home Page',
      name: 'back_to_home_page',
      desc: '',
      args: [],
    );
  }

  /// `kg`
  String get kg {
    return Intl.message('kg', name: 'kg', desc: '', args: []);
  }

  /// `Monthly expense graph`
  String get monthly_expense_graph {
    return Intl.message(
      'Monthly expense graph',
      name: 'monthly_expense_graph',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `Export`
  String get export {
    return Intl.message('Export', name: 'export', desc: '', args: []);
  }

  /// `Order`
  String get order {
    return Intl.message('Order', name: 'order', desc: '', args: []);
  }

  /// `Dec`
  String get jan {
    return Intl.message('Dec', name: 'jan', desc: '', args: []);
  }

  /// `Nov`
  String get feb {
    return Intl.message('Nov', name: 'feb', desc: '', args: []);
  }

  /// `Oct`
  String get mar {
    return Intl.message('Oct', name: 'mar', desc: '', args: []);
  }

  /// `Sep`
  String get apr {
    return Intl.message('Sep', name: 'apr', desc: '', args: []);
  }

  /// `Aug`
  String get may {
    return Intl.message('Aug', name: 'may', desc: '', args: []);
  }

  /// `Jul`
  String get jun {
    return Intl.message('Jul', name: 'jun', desc: '', args: []);
  }

  /// `Jun`
  String get jul {
    return Intl.message('Jun', name: 'jul', desc: '', args: []);
  }

  /// `May`
  String get aug {
    return Intl.message('May', name: 'aug', desc: '', args: []);
  }

  /// `Apr`
  String get sep {
    return Intl.message('Apr', name: 'sep', desc: '', args: []);
  }

  /// `Mar`
  String get oct {
    return Intl.message('Mar', name: 'oct', desc: '', args: []);
  }

  /// `Feb`
  String get nov {
    return Intl.message('Feb', name: 'nov', desc: '', args: []);
  }

  /// `Jan`
  String get dec {
    return Intl.message('Jan', name: 'dec', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `See All`
  String get see_all {
    return Intl.message('See All', name: 'see_all', desc: '', args: []);
  }

  /// `at discount`
  String get discount {
    return Intl.message('at discount', name: 'discount', desc: '', args: []);
  }

  /// `December`
  String get january {
    return Intl.message('December', name: 'january', desc: '', args: []);
  }

  /// `November`
  String get february {
    return Intl.message('November', name: 'february', desc: '', args: []);
  }

  /// `October`
  String get march {
    return Intl.message('October', name: 'march', desc: '', args: []);
  }

  /// `September`
  String get april {
    return Intl.message('September', name: 'april', desc: '', args: []);
  }

  /// `July`
  String get june {
    return Intl.message('July', name: 'june', desc: '', args: []);
  }

  /// `June`
  String get july {
    return Intl.message('June', name: 'july', desc: '', args: []);
  }

  /// `May`
  String get august {
    return Intl.message('May', name: 'august', desc: '', args: []);
  }

  /// `April`
  String get september {
    return Intl.message('April', name: 'september', desc: '', args: []);
  }

  /// `March`
  String get october {
    return Intl.message('March', name: 'october', desc: '', args: []);
  }

  /// `February`
  String get november {
    return Intl.message('February', name: 'november', desc: '', args: []);
  }

  /// `January`
  String get december {
    return Intl.message('January', name: 'december', desc: '', args: []);
  }

  /// `No data found`
  String get no_data {
    return Intl.message('No data found', name: 'no_data', desc: '', args: []);
  }

  /// `No invoice file found`
  String get no_invoice_file {
    return Intl.message(
      'No invoice file found',
      name: 'no_invoice_file',
      desc: '',
      args: [],
    );
  }

  /// `Your cart is empty`
  String get cart_empty {
    return Intl.message(
      'Your cart is empty',
      name: 'cart_empty',
      desc: '',
      args: [],
    );
  }

  /// `Please enter email`
  String get please_enter_email {
    return Intl.message(
      'Please enter email',
      name: 'please_enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid email`
  String get please_enter_valid_email {
    return Intl.message(
      'Please enter valid email',
      name: 'please_enter_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Phone number can't be Empty`
  String get phone_number_cant_be_empty {
    return Intl.message(
      'Phone number can\'t be Empty',
      name: 'phone_number_cant_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid phone number`
  String get please_enter_valid_phone_number {
    return Intl.message(
      'Please enter valid phone number',
      name: 'please_enter_valid_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Phone number must be 10-digit`
  String get phone_number_must_be_10digit {
    return Intl.message(
      'Phone number must be 10-digit',
      name: 'phone_number_must_be_10digit',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your business name`
  String get please_enter_your_business_name {
    return Intl.message(
      'Please enter your business name',
      name: 'please_enter_your_business_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid business name`
  String get please_enter_valid_business_name {
    return Intl.message(
      'Please enter valid business name',
      name: 'please_enter_valid_business_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter alphabets only`
  String get please_enter_alphabets_only {
    return Intl.message(
      'Please enter alphabets only',
      name: 'please_enter_alphabets_only',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid business ID`
  String get please_enter_valid_business_id {
    return Intl.message(
      'Please enter valid business ID',
      name: 'please_enter_valid_business_id',
      desc: '',
      args: [],
    );
  }

  /// `Please enter business ID`
  String get please_enter_business_id {
    return Intl.message(
      'Please enter business ID',
      name: 'please_enter_business_id',
      desc: '',
      args: [],
    );
  }

  /// `Please enter owner name`
  String get please_enter_owner_name {
    return Intl.message(
      'Please enter owner name',
      name: 'please_enter_owner_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter israel ID`
  String get please_enter_israel_id {
    return Intl.message(
      'Please enter israel ID',
      name: 'please_enter_israel_id',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid israel ID`
  String get please_enter_valid_israel_id {
    return Intl.message(
      'Please enter valid israel ID',
      name: 'please_enter_valid_israel_id',
      desc: '',
      args: [],
    );
  }

  /// `Please enter contact name`
  String get please_enter_contact_name {
    return Intl.message(
      'Please enter contact name',
      name: 'please_enter_contact_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter address`
  String get please_enter_address {
    return Intl.message(
      'Please enter address',
      name: 'please_enter_address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter fax number`
  String get please_enter_fax_number {
    return Intl.message(
      'Please enter fax number',
      name: 'please_enter_fax_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid fax number`
  String get please_enter_valid_fax_number {
    return Intl.message(
      'Please enter valid fax number',
      name: 'please_enter_valid_fax_number',
      desc: '',
      args: [],
    );
  }

  /// `Logged out Successfully`
  String get logged_out_successfully {
    return Intl.message(
      'Logged out Successfully',
      name: 'logged_out_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get are_you_sure {
    return Intl.message(
      'Are you sure?',
      name: 'are_you_sure',
      desc: '',
      args: [],
    );
  }

  /// `Document`
  String get document {
    return Intl.message('Document', name: 'document', desc: '', args: []);
  }

  /// `Registered Successfully`
  String get registered_successfully {
    return Intl.message(
      'Registered Successfully',
      name: 'registered_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Updated Successfully`
  String get updated_successfully {
    return Intl.message(
      'Updated Successfully',
      name: 'updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Removed Successfully!`
  String get removed_successfully {
    return Intl.message(
      'Removed Successfully!',
      name: 'removed_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Something is wrong, try again!`
  String get something_is_wrong_try_again {
    return Intl.message(
      'Something is wrong, try again!',
      name: 'something_is_wrong_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Image not set`
  String get image_not_set {
    return Intl.message(
      'Image not set',
      name: 'image_not_set',
      desc: '',
      args: [],
    );
  }

  /// `File size must be less then 1024 KB`
  String get file_size_must_be_less_then {
    return Intl.message(
      'File size must be less then 1024 KB',
      name: 'file_size_must_be_less_then',
      desc: '',
      args: [],
    );
  }

  /// `Please select opening time after previous closing time`
  String get please_select_opening_time_after_previous_closing_time {
    return Intl.message(
      'Please select opening time after previous closing time',
      name: 'please_select_opening_time_after_previous_closing_time',
      desc: '',
      args: [],
    );
  }

  /// `Please select opening time before closing time`
  String get please_select_opening_time_before_closing_time {
    return Intl.message(
      'Please select opening time before closing time',
      name: 'please_select_opening_time_before_closing_time',
      desc: '',
      args: [],
    );
  }

  /// `Please select closing time after opening time`
  String get please_select_closing_time_after_opening_time {
    return Intl.message(
      'Please select closing time after opening time',
      name: 'please_select_closing_time_after_opening_time',
      desc: '',
      args: [],
    );
  }

  /// `Please select opening Time`
  String get please_select_opening_time {
    return Intl.message(
      'Please select opening Time',
      name: 'please_select_opening_time',
      desc: '',
      args: [],
    );
  }

  /// `Please select previous shift time`
  String get please_select_previous_shift_time {
    return Intl.message(
      'Please select previous shift time',
      name: 'please_select_previous_shift_time',
      desc: '',
      args: [],
    );
  }

  /// `Please select first shift time`
  String get please_select_first_shift_time {
    return Intl.message(
      'Please select first shift time',
      name: 'please_select_first_shift_time',
      desc: '',
      args: [],
    );
  }

  /// `Please enter otp`
  String get please_enter_otp {
    return Intl.message(
      'Please enter otp',
      name: 'please_enter_otp',
      desc: '',
      args: [],
    );
  }

  /// `Please select time grater then 00:00`
  String get please_select_time_grater_then_0 {
    return Intl.message(
      'Please select time grater then 00:00',
      name: 'please_select_time_grater_then_0',
      desc: '',
      args: [],
    );
  }

  /// `Please fill up closing time`
  String get please_fill_up_closing_time {
    return Intl.message(
      'Please fill up closing time',
      name: 'please_fill_up_closing_time',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get no_internet_connection {
    return Intl.message(
      'No Internet Connection',
      name: 'no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `Cities not available`
  String get cities_not_available {
    return Intl.message(
      'Cities not available',
      name: 'cities_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Select supplier`
  String get select_supplier {
    return Intl.message(
      'Select supplier',
      name: 'select_supplier',
      desc: '',
      args: [],
    );
  }

  /// `please select supplier`
  String get please_select_supplier {
    return Intl.message(
      'please select supplier',
      name: 'please_select_supplier',
      desc: '',
      args: [],
    );
  }

  /// `Suppliers not available`
  String get suppliers_not_available {
    return Intl.message(
      'Suppliers not available',
      name: 'suppliers_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Search result not found`
  String get search_result_not_found {
    return Intl.message(
      'Search result not found',
      name: 'search_result_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Products not available`
  String get products_not_available {
    return Intl.message(
      'Products not available',
      name: 'products_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Sub Categories not available`
  String get sub_categories_not_available {
    return Intl.message(
      'Sub Categories not available',
      name: 'sub_categories_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Messages not found`
  String get messages_not_found {
    return Intl.message(
      'Messages not found',
      name: 'messages_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Currently this Supplier has no products`
  String get currently_this_Supplier_has_no_products {
    return Intl.message(
      'Currently this Supplier has no products',
      name: 'currently_this_Supplier_has_no_products',
      desc: '',
      args: [],
    );
  }

  /// `Currently products are not on sale`
  String get currently_products_are_not_on_sale {
    return Intl.message(
      'Currently products are not on sale',
      name: 'currently_products_are_not_on_sale',
      desc: '',
      args: [],
    );
  }

  /// `Recommendation products are not available`
  String get recommendation_products_are_not_available {
    return Intl.message(
      'Recommendation products are not available',
      name: 'recommendation_products_are_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Companies not available`
  String get companies_not_available {
    return Intl.message(
      'Companies not available',
      name: 'companies_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Categories not available`
  String get categories_not_available {
    return Intl.message(
      'Categories not available',
      name: 'categories_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Forms and Files not available`
  String get forms_Files_not_available {
    return Intl.message(
      'Forms and Files not available',
      name: 'forms_Files_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Q&A not available`
  String get qa_not_available {
    return Intl.message(
      'Q&A not available',
      name: 'qa_not_available',
      desc: '',
      args: [],
    );
  }

  /// `Product added to Cart`
  String get product_added_to_cart {
    return Intl.message(
      'Product added to Cart',
      name: 'product_added_to_cart',
      desc: '',
      args: [],
    );
  }

  /// `You have reached maximum quantity`
  String get you_have_reached_maximum_quantity {
    return Intl.message(
      'You have reached maximum quantity',
      name: 'you_have_reached_maximum_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Downloaded successfully!`
  String get downloaded_successfully {
    return Intl.message(
      'Downloaded successfully!',
      name: 'downloaded_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to download`
  String get failed_download {
    return Intl.message(
      'Failed to download',
      name: 'failed_download',
      desc: '',
      args: [],
    );
  }

  /// `Please allow camera permission from settings`
  String get camera_permission {
    return Intl.message(
      'Please allow camera permission from settings',
      name: 'camera_permission',
      desc: '',
      args: [],
    );
  }

  /// `Please allow storage permission from settings`
  String get storage_permission {
    return Intl.message(
      'Please allow storage permission from settings',
      name: 'storage_permission',
      desc: '',
      args: [],
    );
  }

  /// `Please enter 4 digit otp code`
  String get enter_4digit_otp {
    return Intl.message(
      'Please enter 4 digit otp code',
      name: 'enter_4digit_otp',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to clear cart?`
  String get you_want_clear_cart {
    return Intl.message(
      'Are you sure you want to clear cart?',
      name: 'you_want_clear_cart',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete product?`
  String get you_want_delete_product {
    return Intl.message(
      'Are you sure you want to delete product?',
      name: 'you_want_delete_product',
      desc: '',
      args: [],
    );
  }

  /// `Please select issue`
  String get select_issue {
    return Intl.message(
      'Please select issue',
      name: 'select_issue',
      desc: '',
      args: [],
    );
  }

  /// `Please select atleast one checkbox`
  String get select_atleast_one_checkbox {
    return Intl.message(
      'Please select atleast one checkbox',
      name: 'select_atleast_one_checkbox',
      desc: '',
      args: [],
    );
  }

  /// `Please select all checkbox`
  String get select_checkbox {
    return Intl.message(
      'Please select all checkbox',
      name: 'select_checkbox',
      desc: '',
      args: [],
    );
  }

  /// `Signature is missing`
  String get signature_missing {
    return Intl.message(
      'Signature is missing',
      name: 'signature_missing',
      desc: '',
      args: [],
    );
  }

  /// `Missing driver signature`
  String get driver_signature_missing {
    return Intl.message(
      'Missing driver signature',
      name: 'driver_signature_missing',
      desc: '',
      args: [],
    );
  }

  /// `Connection timed out`
  String get connection_timed_out {
    return Intl.message(
      'Connection timed out',
      name: 'connection_timed_out',
      desc: '',
      args: [],
    );
  }

  /// `Send timed out`
  String get send_timed_out {
    return Intl.message(
      'Send timed out',
      name: 'send_timed_out',
      desc: '',
      args: [],
    );
  }

  /// `Receive timed out`
  String get receive_timed_out {
    return Intl.message(
      'Receive timed out',
      name: 'receive_timed_out',
      desc: '',
      args: [],
    );
  }

  /// `Bad SSL certificates`
  String get bad_ssl_certificates {
    return Intl.message(
      'Bad SSL certificates',
      name: 'bad_ssl_certificates',
      desc: '',
      args: [],
    );
  }

  /// `Bad request`
  String get bad_request {
    return Intl.message('Bad request', name: 'bad_request', desc: '', args: []);
  }

  /// `Permission denied`
  String get permission_denied {
    return Intl.message(
      'Permission denied',
      name: 'permission_denied',
      desc: '',
      args: [],
    );
  }

  /// `Server internal error`
  String get server_internal_error {
    return Intl.message(
      'Server internal error',
      name: 'server_internal_error',
      desc: '',
      args: [],
    );
  }

  /// `Server bad response`
  String get server_bad_response {
    return Intl.message(
      'Server bad response',
      name: 'server_bad_response',
      desc: '',
      args: [],
    );
  }

  /// `Server canceled it`
  String get server_canceled {
    return Intl.message(
      'Server canceled it',
      name: 'server_canceled',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get unknown_error {
    return Intl.message(
      'Unknown error',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `Login successfully`
  String get login_successful {
    return Intl.message(
      'Login successfully',
      name: 'login_successful',
      desc: '',
      args: [],
    );
  }

  /// `Add at least 1 quantity`
  String get add_1_quantity {
    return Intl.message(
      'Add at least 1 quantity',
      name: 'add_1_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Out of Stock`
  String get out_of_stock {
    return Intl.message(
      'Out of Stock',
      name: 'out_of_stock',
      desc: '',
      args: [],
    );
  }

  /// `Please select your business type`
  String get select_business_type {
    return Intl.message(
      'Please select your business type',
      name: 'select_business_type',
      desc: '',
      args: [],
    );
  }

  /// `Reorder`
  String get reorder {
    return Intl.message('Reorder', name: 'reorder', desc: '', args: []);
  }

  /// `Products from Previous Orders`
  String get previous_order_products {
    return Intl.message(
      'Products from Previous Orders',
      name: 'previous_order_products',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get err_message {
    return Intl.message(
      'Something went wrong',
      name: 'err_message',
      desc: '',
      args: [],
    );
  }

  /// `Request completed successfully`
  String get success_message {
    return Intl.message(
      'Request completed successfully',
      name: 'success_message',
      desc: '',
      args: [],
    );
  }

  /// `Invalid operation`
  String get invalid_operation {
    return Intl.message(
      'Invalid operation',
      name: 'invalid_operation',
      desc: '',
      args: [],
    );
  }

  /// `Document created successfully`
  String get document_created_message {
    return Intl.message(
      'Document created successfully',
      name: 'document_created_message',
      desc: '',
      args: [],
    );
  }

  /// `Login successfully`
  String get login_success_message {
    return Intl.message(
      'Login successfully',
      name: 'login_success_message',
      desc: '',
      args: [],
    );
  }

  /// `Registered successfully`
  String get user_created_message {
    return Intl.message(
      'Registered successfully',
      name: 'user_created_message',
      desc: '',
      args: [],
    );
  }

  /// `Validation error`
  String get validation_error {
    return Intl.message(
      'Validation error',
      name: 'validation_error',
      desc: '',
      args: [],
    );
  }

  /// `Internal server error occurred`
  String get server_error_message {
    return Intl.message(
      'Internal server error occurred',
      name: 'server_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Invalid credentials`
  String get invalid_credentials {
    return Intl.message(
      'Invalid credentials',
      name: 'invalid_credentials',
      desc: '',
      args: [],
    );
  }

  /// `A verification email has been sent to your registered email address. Please check your inbox`
  String get verification_email_sent {
    return Intl.message(
      'A verification email has been sent to your registered email address. Please check your inbox',
      name: 'verification_email_sent',
      desc: '',
      args: [],
    );
  }

  /// `Invalid verification code. Please check the code and try again`
  String get invalid_code {
    return Intl.message(
      'Invalid verification code. Please check the code and try again',
      name: 'invalid_code',
      desc: '',
      args: [],
    );
  }

  /// `Verification already completed`
  String get already_verified {
    return Intl.message(
      'Verification already completed',
      name: 'already_verified',
      desc: '',
      args: [],
    );
  }

  /// `Verification code has expired. Please request a new verification code`
  String get expired_code {
    return Intl.message(
      'Verification code has expired. Please request a new verification code',
      name: 'expired_code',
      desc: '',
      args: [],
    );
  }

  /// `Verification successfully`
  String get verification_success {
    return Intl.message(
      'Verification successfully',
      name: 'verification_success',
      desc: '',
      args: [],
    );
  }

  /// `Invalid verification code. Please check the code and try again`
  String get invalid_verification_code {
    return Intl.message(
      'Invalid verification code. Please check the code and try again',
      name: 'invalid_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Verification code has expired. Please request a new verification code`
  String get expired_verification_code {
    return Intl.message(
      'Verification code has expired. Please request a new verification code',
      name: 'expired_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Verification code has not been verified. Please verify first`
  String get unverified_verification_code {
    return Intl.message(
      'Verification code has not been verified. Please verify first',
      name: 'unverified_verification_code',
      desc: '',
      args: [],
    );
  }

  /// `User not found`
  String get user_not_found {
    return Intl.message(
      'User not found',
      name: 'user_not_found',
      desc: '',
      args: [],
    );
  }

  /// `New password must be different from the existing password`
  String get new_password_same_as_old {
    return Intl.message(
      'New password must be different from the existing password',
      name: 'new_password_same_as_old',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successfully`
  String get reset_successful {
    return Intl.message(
      'Password reset successfully',
      name: 'reset_successful',
      desc: '',
      args: [],
    );
  }

  /// `Password set successfully`
  String get set_successful {
    return Intl.message(
      'Password set successfully',
      name: 'set_successful',
      desc: '',
      args: [],
    );
  }

  /// `Your current password is wrong please enter the correct password`
  String get current_password_wrong {
    return Intl.message(
      'Your current password is wrong please enter the correct password',
      name: 'current_password_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Password change successfully`
  String get change_successful {
    return Intl.message(
      'Password change successfully',
      name: 'change_successful',
      desc: '',
      args: [],
    );
  }

  /// `Form created successfully`
  String get form_create_successful {
    return Intl.message(
      'Form created successfully',
      name: 'form_create_successful',
      desc: '',
      args: [],
    );
  }

  /// `Form updated successfully`
  String get form_update_successful {
    return Intl.message(
      'Form updated successfully',
      name: 'form_update_successful',
      desc: '',
      args: [],
    );
  }

  /// `Form not found`
  String get form_not_found {
    return Intl.message(
      'Form not found',
      name: 'form_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Form name is already exists.Try new name`
  String get form_exists_with_name {
    return Intl.message(
      'Form name is already exists.Try new name',
      name: 'form_exists_with_name',
      desc: '',
      args: [],
    );
  }

  /// `Internal server error`
  String get internal_server_error {
    return Intl.message(
      'Internal server error',
      name: 'internal_server_error',
      desc: '',
      args: [],
    );
  }

  /// `Record already exists!`
  String get record_already_exist {
    return Intl.message(
      'Record already exists!',
      name: 'record_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Phone number already exists`
  String get phone_number_already_exist {
    return Intl.message(
      'Phone number already exists',
      name: 'phone_number_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Email already exists`
  String get email_already_exist {
    return Intl.message(
      'Email already exists',
      name: 'email_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Record not created`
  String get record_not_created {
    return Intl.message(
      'Record not created',
      name: 'record_not_created',
      desc: '',
      args: [],
    );
  }

  /// `Token error`
  String get token_error {
    return Intl.message('Token error', name: 'token_error', desc: '', args: []);
  }

  /// `Data not found`
  String get data_not_found {
    return Intl.message(
      'Data not found',
      name: 'data_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Invalid number please check your phone number`
  String get invalid_contact {
    return Intl.message(
      'Invalid number please check your phone number',
      name: 'invalid_contact',
      desc: '',
      args: [],
    );
  }

  /// `User is already been registered`
  String get found_contact {
    return Intl.message(
      'User is already been registered',
      name: 'found_contact',
      desc: '',
      args: [],
    );
  }

  /// `Email not found`
  String get invalid_email {
    return Intl.message(
      'Email not found',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Record doesn't exist`
  String get record_does_not_exist {
    return Intl.message(
      'Record doesn\'t exist',
      name: 'record_does_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `SKUS Are Required`
  String get sku_are_required {
    return Intl.message(
      'SKUS Are Required',
      name: 'sku_are_required',
      desc: '',
      args: [],
    );
  }

  /// `Product Id Are Required`
  String get product_id_are_required {
    return Intl.message(
      'Product Id Are Required',
      name: 'product_id_are_required',
      desc: '',
      args: [],
    );
  }

  /// `None Of The Skus Are Registered`
  String get skus_are_not_registered {
    return Intl.message(
      'None Of The Skus Are Registered',
      name: 'skus_are_not_registered',
      desc: '',
      args: [],
    );
  }

  /// `None of the products are registered`
  String get no_products_are_registered {
    return Intl.message(
      'None of the products are registered',
      name: 'no_products_are_registered',
      desc: '',
      args: [],
    );
  }

  /// `Supplier product is not registered`
  String get supplier_product_is_not_registered {
    return Intl.message(
      'Supplier product is not registered',
      name: 'supplier_product_is_not_registered',
      desc: '',
      args: [],
    );
  }

  /// `None of the Products are matched with Supplier`
  String get products_supplier_mismatch {
    return Intl.message(
      'None of the Products are matched with Supplier',
      name: 'products_supplier_mismatch',
      desc: '',
      args: [],
    );
  }

  /// `Product Removed from Sale Successful`
  String get product_removal_sale_success {
    return Intl.message(
      'Product Removed from Sale Successful',
      name: 'product_removal_sale_success',
      desc: '',
      args: [],
    );
  }

  /// `Product Removed from Sale Failure`
  String get product_removal_sale_failure {
    return Intl.message(
      'Product Removed from Sale Failure',
      name: 'product_removal_sale_failure',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient Data For Product Removal From Sale`
  String get insufficient_data_for_product_removal_from_sale {
    return Intl.message(
      'Insufficient Data For Product Removal From Sale',
      name: 'insufficient_data_for_product_removal_from_sale',
      desc: '',
      args: [],
    );
  }

  /// `Product Not Found`
  String get product_not_found {
    return Intl.message(
      'Product Not Found',
      name: 'product_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Failed to authenticate`
  String get failed_to_authenticate {
    return Intl.message(
      'Failed to authenticate',
      name: 'failed_to_authenticate',
      desc: '',
      args: [],
    );
  }

  /// `Record updated successfully`
  String get record_updated_successfully {
    return Intl.message(
      'Record updated successfully',
      name: 'record_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Record deleted successfully`
  String get record_deleted_successfully {
    return Intl.message(
      'Record deleted successfully',
      name: 'record_deleted_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Record created successfully`
  String get record_created_successfully {
    return Intl.message(
      'Record created successfully',
      name: 'record_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Please provide valid record ids`
  String get invalid_ids {
    return Intl.message(
      'Please provide valid record ids',
      name: 'invalid_ids',
      desc: '',
      args: [],
    );
  }

  /// `Items imported successfully`
  String get imported_successfully {
    return Intl.message(
      'Items imported successfully',
      name: 'imported_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Cart product is not Implemented`
  String get cart_products_bad_request {
    return Intl.message(
      'Cart product is not Implemented',
      name: 'cart_products_bad_request',
      desc: '',
      args: [],
    );
  }

  /// `Cart does not exist`
  String get cart_does_not_exist {
    return Intl.message(
      'Cart does not exist',
      name: 'cart_does_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `Cart product does not exist`
  String get cart_product_does_not_exist {
    return Intl.message(
      'Cart product does not exist',
      name: 'cart_product_does_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `Product does not exist`
  String get product_does_not_exist_in_cart {
    return Intl.message(
      'Product does not exist',
      name: 'product_does_not_exist_in_cart',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Does Not Have Enough Quantity`
  String get supplier_does_not_have_quantity {
    return Intl.message(
      'Supplier Does Not Have Enough Quantity',
      name: 'supplier_does_not_have_quantity',
      desc: '',
      args: [],
    );
  }

  /// `At-least one product required`
  String get order_products_bad_request {
    return Intl.message(
      'At-least one product required',
      name: 'order_products_bad_request',
      desc: '',
      args: [],
    );
  }

  /// `Order placed successfully`
  String get order_created_successfully {
    return Intl.message(
      'Order placed successfully',
      name: 'order_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Order updated successfully`
  String get order_updated_successfully {
    return Intl.message(
      'Order updated successfully',
      name: 'order_updated_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Order not found`
  String get order_not_found {
    return Intl.message(
      'Order not found',
      name: 'order_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Product has low quantity.`
  String get low_quantity {
    return Intl.message(
      'Product has low quantity.',
      name: 'low_quantity',
      desc: '',
      args: [],
    );
  }

  /// `Cart has been cleared now`
  String get cart_cleared {
    return Intl.message(
      'Cart has been cleared now',
      name: 'cart_cleared',
      desc: '',
      args: [],
    );
  }

  /// `Password is not set please set password`
  String get null_password {
    return Intl.message(
      'Password is not set please set password',
      name: 'null_password',
      desc: '',
      args: [],
    );
  }

  /// `Logged out successfully`
  String get logout {
    return Intl.message(
      'Logged out successfully',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Message created successfully`
  String get message_created {
    return Intl.message(
      'Message created successfully',
      name: 'message_created',
      desc: '',
      args: [],
    );
  }

  /// `Message updated successfully`
  String get message_updated {
    return Intl.message(
      'Message updated successfully',
      name: 'message_updated',
      desc: '',
      args: [],
    );
  }

  /// `Product quantity fulfilled`
  String get quantity_fulfilled {
    return Intl.message(
      'Product quantity fulfilled',
      name: 'quantity_fulfilled',
      desc: '',
      args: [],
    );
  }

  /// `Order exists sale can not deleted`
  String get order_sale_exist {
    return Intl.message(
      'Order exists sale can not deleted',
      name: 'order_sale_exist',
      desc: '',
      args: [],
    );
  }

  /// `Product exists supplier can not deleted`
  String get supplier_product_exist {
    return Intl.message(
      'Product exists supplier can not deleted',
      name: 'supplier_product_exist',
      desc: '',
      args: [],
    );
  }

  /// `Question does not exist`
  String get question_id_does_not_exist {
    return Intl.message(
      'Question does not exist',
      name: 'question_id_does_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `Question with the same text already exists`
  String get unique_question_and_answer {
    return Intl.message(
      'Question with the same text already exists',
      name: 'unique_question_and_answer',
      desc: '',
      args: [],
    );
  }

  /// `Question created successfully`
  String get question_created_successfully {
    return Intl.message(
      'Question created successfully',
      name: 'question_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `No matching record found for update`
  String get question_record_does_not_exist {
    return Intl.message(
      'No matching record found for update',
      name: 'question_record_does_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `Question deleted successfully`
  String get question_deleted_successfully {
    return Intl.message(
      'Question deleted successfully',
      name: 'question_deleted_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Product is already in cart`
  String get product_already_in_cart {
    return Intl.message(
      'Product is already in cart',
      name: 'product_already_in_cart',
      desc: '',
      args: [],
    );
  }

  /// `Product or supplier dosent exist`
  String get product_or_supplier_not_exits {
    return Intl.message(
      'Product or supplier dosent exist',
      name: 'product_or_supplier_not_exits',
      desc: '',
      args: [],
    );
  }

  /// `Product has been successfully added to your cart`
  String get product_added_in_cart {
    return Intl.message(
      'Product has been successfully added to your cart',
      name: 'product_added_in_cart',
      desc: '',
      args: [],
    );
  }

  /// `Product has been successfully updated to your cart`
  String get product_updated_in_cart {
    return Intl.message(
      'Product has been successfully updated to your cart',
      name: 'product_updated_in_cart',
      desc: '',
      args: [],
    );
  }

  /// `Issues Reported in SupplierOrderNumber#`
  String get order_issue_created_notification_title {
    return Intl.message(
      'Issues Reported in SupplierOrderNumber#',
      name: 'order_issue_created_notification_title',
      desc: '',
      args: [],
    );
  }

  /// `File not found`
  String get file_not_found {
    return Intl.message(
      'File not found',
      name: 'file_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Supplier ID`
  String get you_can_not_update_order {
    return Intl.message(
      'Invalid Supplier ID',
      name: 'you_can_not_update_order',
      desc: '',
      args: [],
    );
  }

  /// `cant create issue`
  String get you_can_not_create_issue {
    return Intl.message(
      'cant create issue',
      name: 'you_can_not_create_issue',
      desc: '',
      args: [],
    );
  }

  /// `cant place an order`
  String get you_can_not_place_order {
    return Intl.message(
      'cant place an order',
      name: 'you_can_not_place_order',
      desc: '',
      args: [],
    );
  }

  /// `you can not confirm delivery `
  String get you_can_not_confirm_delivery {
    return Intl.message(
      'you can not confirm delivery ',
      name: 'you_can_not_confirm_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Signature is required`
  String get signature_required {
    return Intl.message(
      'Signature is required',
      name: 'signature_required',
      desc: '',
      args: [],
    );
  }

  /// `Please Provide CSV`
  String get provide_valid_csv {
    return Intl.message(
      'Please Provide CSV',
      name: 'provide_valid_csv',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Supplier ID`
  String get invalid_supplier_id {
    return Intl.message(
      'Invalid Supplier ID',
      name: 'invalid_supplier_id',
      desc: '',
      args: [],
    );
  }

  /// `Admin Type already exists`
  String get admin_type_already_exist {
    return Intl.message(
      'Admin Type already exists',
      name: 'admin_type_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `You cannot delete this AdminType as it is associated with a user`
  String get already_linked_with_user {
    return Intl.message(
      'You cannot delete this AdminType as it is associated with a user',
      name: 'already_linked_with_user',
      desc: '',
      args: [],
    );
  }

  /// `Cant place order for product . Quantity must be above 0`
  String get qty_must_above_zero {
    return Intl.message(
      'Cant place order for product . Quantity must be above 0',
      name: 'qty_must_above_zero',
      desc: '',
      args: [],
    );
  }

  /// `Not enough quantity for product`
  String get not_enough_qty {
    return Intl.message(
      'Not enough quantity for product',
      name: 'not_enough_qty',
      desc: '',
      args: [],
    );
  }

  /// `Content with the same name already exists`
  String get content_already_exist {
    return Intl.message(
      'Content with the same name already exists',
      name: 'content_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Module name already exists`
  String get module_already_exist {
    return Intl.message(
      'Module name already exists',
      name: 'module_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Product or supplier dosent exist.`
  String get product_or_supplier_not_exist {
    return Intl.message(
      'Product or supplier dosent exist.',
      name: 'product_or_supplier_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `Issues are generated.`
  String get issue_generated {
    return Intl.message(
      'Issues are generated.',
      name: 'issue_generated',
      desc: '',
      args: [],
    );
  }

  /// `Delivery has been confirmed.`
  String get delivery_confirmed {
    return Intl.message(
      'Delivery has been confirmed.',
      name: 'delivery_confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Permission Template name already exists`
  String get permission_already_exist {
    return Intl.message(
      'Permission Template name already exists',
      name: 'permission_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Planogram already exists`
  String get planogram_already_exist {
    return Intl.message(
      'Planogram already exists',
      name: 'planogram_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Product already exists`
  String get product_already_exist {
    return Intl.message(
      'Product already exists',
      name: 'product_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Duplicate Or Invalid SKU`
  String get duplicate_or_invalid_sku {
    return Intl.message(
      'Duplicate Or Invalid SKU',
      name: 'duplicate_or_invalid_sku',
      desc: '',
      args: [],
    );
  }

  /// `Sale is existing you cant remove the supplier`
  String get already_linked_with_sale {
    return Intl.message(
      'Sale is existing you cant remove the supplier',
      name: 'already_linked_with_sale',
      desc: '',
      args: [],
    );
  }

  /// `Message with this content name already exists`
  String get already_exist {
    return Intl.message(
      'Message with this content name already exists',
      name: 'already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Wallet already exists`
  String get wallet_already_exist {
    return Intl.message(
      'Wallet already exists',
      name: 'wallet_already_exist',
      desc: '',
      args: [],
    );
  }

  /// `Not sufficient balance`
  String get not_enough_balance {
    return Intl.message(
      'Not sufficient balance',
      name: 'not_enough_balance',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Amount`
  String get invalid_amount {
    return Intl.message(
      'Invalid Amount',
      name: 'invalid_amount',
      desc: '',
      args: [],
    );
  }

  /// `Deduction would result in a negative balance`
  String get deduction_is_negative {
    return Intl.message(
      'Deduction would result in a negative balance',
      name: 'deduction_is_negative',
      desc: '',
      args: [],
    );
  }

  /// `missing quantity can't be more then original quantity`
  String get missing_quantity_not_more_than_original {
    return Intl.message(
      'missing quantity can\'t be more then original quantity',
      name: 'missing_quantity_not_more_than_original',
      desc: '',
      args: [],
    );
  }

  /// `Check All`
  String get check_all {
    return Intl.message('Check All', name: 'check_all', desc: '', args: []);
  }

  /// `Please wait while uploading`
  String get wait_while_uploading {
    return Intl.message(
      'Please wait while uploading',
      name: 'wait_while_uploading',
      desc: '',
      args: [],
    );
  }

  /// `OTP resend Successfully!`
  String get otp_resend_success {
    return Intl.message(
      'OTP resend Successfully!',
      name: 'otp_resend_success',
      desc: '',
      args: [],
    );
  }

  /// `Please select only jpg, jpeg, png, heic, pdf and document files`
  String get select_valid_document_format {
    return Intl.message(
      'Please select only jpg, jpeg, png, heic, pdf and document files',
      name: 'select_valid_document_format',
      desc: '',
      args: [],
    );
  }

  /// `please select next day shift`
  String get select_next_day_shift {
    return Intl.message(
      'please select next day shift',
      name: 'select_next_day_shift',
      desc: '',
      args: [],
    );
  }

  /// `Item Deleted`
  String get item_deleted {
    return Intl.message(
      'Item Deleted',
      name: 'item_deleted',
      desc: '',
      args: [],
    );
  }

  /// `This supplier have `
  String get this_supplier_have {
    return Intl.message(
      'This supplier have ',
      name: 'this_supplier_have',
      desc: '',
      args: [],
    );
  }

  /// `quantity in stock `
  String get quantity_in_stock {
    return Intl.message(
      'quantity in stock ',
      name: 'quantity_in_stock',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid owner name`
  String get enter_valid_owner_name {
    return Intl.message(
      'Please enter valid owner name',
      name: 'enter_valid_owner_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid contact name`
  String get enter_valid_contact_name {
    return Intl.message(
      'Please enter valid contact name',
      name: 'enter_valid_contact_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid address`
  String get enter_valid_address {
    return Intl.message(
      'Please enter valid address',
      name: 'enter_valid_address',
      desc: '',
      args: [],
    );
  }

  /// `Currently this company has no products`
  String get this_company_has_no_product {
    return Intl.message(
      'Currently this company has no products',
      name: 'this_company_has_no_product',
      desc: '',
      args: [],
    );
  }

  /// `Out of stock`
  String get out_of_stock1 {
    return Intl.message(
      'Out of stock',
      name: 'out_of_stock1',
      desc: '',
      args: [],
    );
  }

  /// `account not approve`
  String get account_not_approve {
    return Intl.message(
      'account not approve',
      name: 'account_not_approve',
      desc: '',
      args: [],
    );
  }

  /// `Rivchit credentials not set`
  String get rivchit_credentials_not_set {
    return Intl.message(
      'Rivchit credentials not set',
      name: 'rivchit_credentials_not_set',
      desc: '',
      args: [],
    );
  }

  /// `Comax invoice not found`
  String get comax_invoice_not_found {
    return Intl.message(
      'Comax invoice not found',
      name: 'comax_invoice_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Total amount can't be zero`
  String get total_amount_cant_be_zero {
    return Intl.message(
      'Total amount can\'t be zero',
      name: 'total_amount_cant_be_zero',
      desc: '',
      args: [],
    );
  }

  /// `Sale does not exist`
  String get sale_not_exists {
    return Intl.message(
      'Sale does not exist',
      name: 'sale_not_exists',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong.`
  String get comax_order_error {
    return Intl.message(
      'Something went wrong.',
      name: 'comax_order_error',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong.`
  String get comax_client_error {
    return Intl.message(
      'Something went wrong.',
      name: 'comax_client_error',
      desc: '',
      args: [],
    );
  }

  /// `units in the box`
  String get unit_in_box {
    return Intl.message(
      'units in the box',
      name: 'unit_in_box',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `per unit`
  String get per_unit {
    return Intl.message('per unit', name: 'per_unit', desc: '', args: []);
  }

  /// `Sub Categories`
  String get sub_categories {
    return Intl.message(
      'Sub Categories',
      name: 'sub_categories',
      desc: '',
      args: [],
    );
  }

  /// `Delivery up to 3 business days`
  String get delivery_date_value {
    return Intl.message(
      'Delivery up to 3 business days',
      name: 'delivery_date_value',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Credits`
  String get monthly_credit {
    return Intl.message(
      'Monthly Credits',
      name: 'monthly_credit',
      desc: '',
      args: [],
    );
  }

  /// `Refund`
  String get refund {
    return Intl.message('Refund', name: 'refund', desc: '', args: []);
  }

  /// `Sub Total`
  String get sub_total {
    return Intl.message('Sub Total', name: 'sub_total', desc: '', args: []);
  }

  /// `Order amount`
  String get order_amount {
    return Intl.message(
      'Order amount',
      name: 'order_amount',
      desc: '',
      args: [],
    );
  }

  /// `VAT`
  String get vat {
    return Intl.message('VAT', name: 'vat', desc: '', args: []);
  }

  /// `Total refund`
  String get total_refunds {
    return Intl.message(
      'Total refund',
      name: 'total_refunds',
      desc: '',
      args: [],
    );
  }

  /// `Remaining refund`
  String get remaining_refund {
    return Intl.message(
      'Remaining refund',
      name: 'remaining_refund',
      desc: '',
      args: [],
    );
  }

  /// `You still have a credit balance of:`
  String get refund_amount_1 {
    return Intl.message(
      'You still have a credit balance of:',
      name: 'refund_amount_1',
      desc: '',
      args: [],
    );
  }

  /// ` NIS to be used on future orders.`
  String get refund_amount_2 {
    return Intl.message(
      ' NIS to be used on future orders.',
      name: 'refund_amount_2',
      desc: '',
      args: [],
    );
  }

  /// `You have a credit balance of:`
  String get refund_amount_3 {
    return Intl.message(
      'You have a credit balance of:',
      name: 'refund_amount_3',
      desc: '',
      args: [],
    );
  }

  /// ` NIS to used on these orders.`
  String get refund_amount_4 {
    return Intl.message(
      ' NIS to used on these orders.',
      name: 'refund_amount_4',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Read condition`
  String get read_condition {
    return Intl.message(
      'Read condition',
      name: 'read_condition',
      desc: '',
      args: [],
    );
  }

  /// `Bottle Deposit`
  String get bottle_deposit {
    return Intl.message(
      'Bottle Deposit',
      name: 'bottle_deposit',
      desc: '',
      args: [],
    );
  }

  /// `Please provide valid time`
  String get please_provide_valid_time {
    return Intl.message(
      'Please provide valid time',
      name: 'please_provide_valid_time',
      desc: '',
      args: [],
    );
  }

  /// `Please enter city`
  String get please_enter_city {
    return Intl.message(
      'Please enter city',
      name: 'please_enter_city',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get issue_remove {
    return Intl.message('Remove', name: 'issue_remove', desc: '', args: []);
  }

  /// `Issue removed successfully.`
  String get issue_removed {
    return Intl.message(
      'Issue removed successfully.',
      name: 'issue_removed',
      desc: '',
      args: [],
    );
  }

  /// `The wallet information was sent to your email`
  String get wallet_information_sent_to_your_email {
    return Intl.message(
      'The wallet information was sent to your email',
      name: 'wallet_information_sent_to_your_email',
      desc: '',
      args: [],
    );
  }

  /// `From Date`
  String get form_date {
    return Intl.message('From Date', name: 'form_date', desc: '', args: []);
  }

  /// `Until Date`
  String get until_date {
    return Intl.message('Until Date', name: 'until_date', desc: '', args: []);
  }

  /// `Delete account`
  String get delete_account {
    return Intl.message(
      'Delete account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `We received your account deletion request and we will take care of it in a few days, thank you.`
  String get delete_pop_up_msg {
    return Intl.message(
      'We received your account deletion request and we will take care of it in a few days, thank you.',
      name: 'delete_pop_up_msg',
      desc: '',
      args: [],
    );
  }

  /// `Login as guest`
  String get login_as_guest {
    return Intl.message(
      'Login as guest',
      name: 'login_as_guest',
      desc: '',
      args: [],
    );
  }

  /// `קיימת גירסה חדשה עבור האפליקציה אנא עדכן את האפליקציה`
  String get new_version_app_update {
    return Intl.message(
      'קיימת גירסה חדשה עבור האפליקציה אנא עדכן את האפליקציה',
      name: 'new_version_app_update',
      desc: '',
      args: [],
    );
  }

  /// `עדכן`
  String get update {
    return Intl.message('עדכן', name: 'update', desc: '', args: []);
  }

  /// `Application version`
  String get application_version {
    return Intl.message(
      'Application version',
      name: 'application_version',
      desc: '',
      args: [],
    );
  }

  /// `המוצר לא קיים`
  String get no_product {
    return Intl.message(
      'המוצר לא קיים',
      name: 'no_product',
      desc: '',
      args: [],
    );
  }

  /// `Duplicate Order`
  String get duplicate_order {
    return Intl.message(
      'Duplicate Order',
      name: 'duplicate_order',
      desc: '',
      args: [],
    );
  }

  /// `Please note, products that no longer exist or are out of stock will not be added to the new order. Are you sure you want to duplicate the order?`
  String get you_want_to_duplicate_this_order {
    return Intl.message(
      'Please note, products that no longer exist or are out of stock will not be added to the new order. Are you sure you want to duplicate the order?',
      name: 'you_want_to_duplicate_this_order',
      desc: '',
      args: [],
    );
  }

  /// `Wallet refund`
  String get wallet_refund {
    return Intl.message(
      'Wallet refund',
      name: 'wallet_refund',
      desc: '',
      args: [],
    );
  }

  /// `Original was`
  String get original_was {
    return Intl.message(
      'Original was',
      name: 'original_was',
      desc: '',
      args: [],
    );
  }

  /// `Was not in stock`
  String get was_not_in_stock {
    return Intl.message(
      'Was not in stock',
      name: 'was_not_in_stock',
      desc: '',
      args: [],
    );
  }

  /// `Units`
  String get units {
    return Intl.message('Units', name: 'units', desc: '', args: []);
  }

  /// `Surfaces for order`
  String get surfaces_order {
    return Intl.message(
      'Surfaces for order',
      name: 'surfaces_order',
      desc: '',
      args: [],
    );
  }

  /// `Refund for order`
  String get refund_for_order {
    return Intl.message(
      'Refund for order',
      name: 'refund_for_order',
      desc: '',
      args: [],
    );
  }

  /// `Related products`
  String get related_products {
    return Intl.message(
      'Related products',
      name: 'related_products',
      desc: '',
      args: [],
    );
  }

  /// `Search Result`
  String get search_result {
    return Intl.message(
      'Search Result',
      name: 'search_result',
      desc: '',
      args: [],
    );
  }

  /// `Price per box`
  String get price_par_box {
    return Intl.message(
      'Price per box',
      name: 'price_par_box',
      desc: '',
      args: [],
    );
  }

  /// `Refund invoice`
  String get invoice_number {
    return Intl.message(
      'Refund invoice',
      name: 'invoice_number',
      desc: '',
      args: [],
    );
  }

  /// `This price does not include surfaces price`
  String get not_include_surfaces_price {
    return Intl.message(
      'This price does not include surfaces price',
      name: 'not_include_surfaces_price',
      desc: '',
      args: [],
    );
  }

  /// `open`
  String get open {
    return Intl.message('open', name: 'open', desc: '', args: []);
  }

  /// `Data for forms`
  String get data_for_form {
    return Intl.message(
      'Data for forms',
      name: 'data_for_form',
      desc: '',
      args: [],
    );
  }

  /// `Client Info`
  String get client_info {
    return Intl.message('Client Info', name: 'client_info', desc: '', args: []);
  }

  /// `My Agent Code`
  String get my_agent_code {
    return Intl.message(
      'My Agent Code',
      name: 'my_agent_code',
      desc: '',
      args: [],
    );
  }

  /// `Owner 1 full name`
  String get owner1_full_name {
    return Intl.message(
      'Owner 1 full name',
      name: 'owner1_full_name',
      desc: '',
      args: [],
    );
  }

  /// `Owner 1 Israel ID number`
  String get owner_1_israel_id {
    return Intl.message(
      'Owner 1 Israel ID number',
      name: 'owner_1_israel_id',
      desc: '',
      args: [],
    );
  }

  /// `Owner 2 full name`
  String get owner2_full_name {
    return Intl.message(
      'Owner 2 full name',
      name: 'owner2_full_name',
      desc: '',
      args: [],
    );
  }

  /// `Owner 2 Israel ID number`
  String get owner_2_israel_id {
    return Intl.message(
      'Owner 2 Israel ID number',
      name: 'owner_2_israel_id',
      desc: '',
      args: [],
    );
  }

  /// `Guarantee 1 full name`
  String get guarantee_1_full_name {
    return Intl.message(
      'Guarantee 1 full name',
      name: 'guarantee_1_full_name',
      desc: '',
      args: [],
    );
  }

  /// `Guarantee 1 Israel ID number`
  String get guarantee_1_israel_id {
    return Intl.message(
      'Guarantee 1 Israel ID number',
      name: 'guarantee_1_israel_id',
      desc: '',
      args: [],
    );
  }

  /// `Guarantee 2 full name`
  String get guarantee_2_full_name {
    return Intl.message(
      'Guarantee 2 full name',
      name: 'guarantee_2_full_name',
      desc: '',
      args: [],
    );
  }

  /// `Guarantee 2 Israel ID number`
  String get guarantee_2_israel_id {
    return Intl.message(
      'Guarantee 2 Israel ID number',
      name: 'guarantee_2_israel_id',
      desc: '',
      args: [],
    );
  }

  /// ` Guarantee 1 Address `
  String get guarantee_1_address {
    return Intl.message(
      ' Guarantee 1 Address ',
      name: 'guarantee_1_address',
      desc: '',
      args: [],
    );
  }

  /// ` Guarantee 2 Address `
  String get guarantee_2_address {
    return Intl.message(
      ' Guarantee 2 Address ',
      name: 'guarantee_2_address',
      desc: '',
      args: [],
    );
  }

  /// `Guarantee 1 phone number`
  String get guarantee_1_phone_number {
    return Intl.message(
      'Guarantee 1 phone number',
      name: 'guarantee_1_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Guarantee 2 phone number`
  String get guarantee_2_phone_number {
    return Intl.message(
      'Guarantee 2 phone number',
      name: 'guarantee_2_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Bank information`
  String get bank_info {
    return Intl.message(
      'Bank information',
      name: 'bank_info',
      desc: '',
      args: [],
    );
  }

  /// `Name of bank`
  String get name_of_bank {
    return Intl.message(
      'Name of bank',
      name: 'name_of_bank',
      desc: '',
      args: [],
    );
  }

  /// `Branch number`
  String get branch_number {
    return Intl.message(
      'Branch number',
      name: 'branch_number',
      desc: '',
      args: [],
    );
  }

  /// `Account number`
  String get account_number {
    return Intl.message(
      'Account number',
      name: 'account_number',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Guarantee1 Name`
  String get please_enter_guarantee1_name {
    return Intl.message(
      'Please Enter Guarantee1 Name',
      name: 'please_enter_guarantee1_name',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Guarantee2 Name`
  String get please_enter_guarantee2_name {
    return Intl.message(
      'Please Enter Guarantee2 Name',
      name: 'please_enter_guarantee2_name',
      desc: '',
      args: [],
    );
  }

  /// `Please select agent`
  String get please_select_agent {
    return Intl.message(
      'Please select agent',
      name: 'please_select_agent',
      desc: '',
      args: [],
    );
  }

  /// `Please enter branch number`
  String get please_enter_branch_number {
    return Intl.message(
      'Please enter branch number',
      name: 'please_enter_branch_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter account number`
  String get please_enter_account_number {
    return Intl.message(
      'Please enter account number',
      name: 'please_enter_account_number',
      desc: '',
      args: [],
    );
  }

  /// `Service Use Agreement - TAVILI`
  String get privacy_policy {
    return Intl.message(
      'Service Use Agreement - TAVILI',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Pesach Products`
  String get pesach_products {
    return Intl.message(
      'Pesach Products',
      name: 'pesach_products',
      desc: '',
      args: [],
    );
  }

  /// `כשר לפסח`
  String get pesach {
    return Intl.message('כשר לפסח', name: 'pesach', desc: '', args: []);
  }

  /// `Street name`
  String get street_name {
    return Intl.message('Street name', name: 'street_name', desc: '', args: []);
  }

  /// `Street number`
  String get street_number {
    return Intl.message(
      'Street number',
      name: 'street_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter street name`
  String get enter_street_name {
    return Intl.message(
      'Please enter street name',
      name: 'enter_street_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter street number`
  String get enter_street_number {
    return Intl.message(
      'Please enter street number',
      name: 'enter_street_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter zip code`
  String get enter_zip {
    return Intl.message(
      'Please enter zip code',
      name: 'enter_zip',
      desc: '',
      args: [],
    );
  }

  /// `Zip`
  String get zip {
    return Intl.message('Zip', name: 'zip', desc: '', args: []);
  }

  /// `Owner1 Signature`
  String get owner1_sign {
    return Intl.message(
      'Owner1 Signature',
      name: 'owner1_sign',
      desc: '',
      args: [],
    );
  }

  /// `Owner2 Signature`
  String get owner2_sign {
    return Intl.message(
      'Owner2 Signature',
      name: 'owner2_sign',
      desc: '',
      args: [],
    );
  }

  /// `Guarantee1 Signature`
  String get guarantee1_sign {
    return Intl.message(
      'Guarantee1 Signature',
      name: 'guarantee1_sign',
      desc: '',
      args: [],
    );
  }

  /// `Guarantee2 Signature`
  String get guarantee2_sign {
    return Intl.message(
      'Guarantee2 Signature',
      name: 'guarantee2_sign',
      desc: '',
      args: [],
    );
  }

  /// `Please upload document`
  String get upload_document {
    return Intl.message(
      'Please upload document',
      name: 'upload_document',
      desc: '',
      args: [],
    );
  }

  /// `Connection error`
  String get connection_error {
    return Intl.message(
      'Connection error',
      name: 'connection_error',
      desc: '',
      args: [],
    );
  }

  /// `My invoices`
  String get my_invoices {
    return Intl.message('My invoices', name: 'my_invoices', desc: '', args: []);
  }

  /// `My refunds`
  String get my_refunds {
    return Intl.message('My refunds', name: 'my_refunds', desc: '', args: []);
  }

  /// `Rivchit Invoice number`
  String get rivchit_invoice_number {
    return Intl.message(
      'Rivchit Invoice number',
      name: 'rivchit_invoice_number',
      desc: '',
      args: [],
    );
  }

  /// `Payment invoice`
  String get payment_invoice {
    return Intl.message(
      'Payment invoice',
      name: 'payment_invoice',
      desc: '',
      args: [],
    );
  }

  /// `Refund invoice`
  String get refund_invoice {
    return Intl.message(
      'Refund invoice',
      name: 'refund_invoice',
      desc: '',
      args: [],
    );
  }

  /// `Payed`
  String get payed {
    return Intl.message('Payed', name: 'payed', desc: '', args: []);
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Invoice date`
  String get invoice_date {
    return Intl.message(
      'Invoice date',
      name: 'invoice_date',
      desc: '',
      args: [],
    );
  }

  /// `Invoice type`
  String get invoice_type {
    return Intl.message(
      'Invoice type',
      name: 'invoice_type',
      desc: '',
      args: [],
    );
  }

  /// `Invoice status`
  String get invoice_status {
    return Intl.message(
      'Invoice status',
      name: 'invoice_status',
      desc: '',
      args: [],
    );
  }

  /// `Invoice amount`
  String get invoice_amount {
    return Intl.message(
      'Invoice amount',
      name: 'invoice_amount',
      desc: '',
      args: [],
    );
  }

  /// `Refund amount`
  String get refund_amount {
    return Intl.message(
      'Refund amount',
      name: 'refund_amount',
      desc: '',
      args: [],
    );
  }

  /// `Refunded on order`
  String get refunded_on_order {
    return Intl.message(
      'Refunded on order',
      name: 'refunded_on_order',
      desc: '',
      args: [],
    );
  }

  /// `Refunded on Invoices`
  String get refunded_on_invoices {
    return Intl.message(
      'Refunded on Invoices',
      name: 'refunded_on_invoices',
      desc: '',
      args: [],
    );
  }

  /// `need to approve previous order`
  String get approve_previous_order {
    return Intl.message(
      'need to approve previous order',
      name: 'approve_previous_order',
      desc: '',
      args: [],
    );
  }

  /// `It is not possible to transmit an order because there are orders that you received and did not sign\nPlease go through your order list and confirm that you have received them\nOnce you confirm you can broadcast the order\nThank you!`
  String get order_sign_dialog {
    return Intl.message(
      'It is not possible to transmit an order because there are orders that you received and did not sign\nPlease go through your order list and confirm that you have received them\nOnce you confirm you can broadcast the order\nThank you!',
      name: 'order_sign_dialog',
      desc: '',
      args: [],
    );
  }

  /// `Show order`
  String get show_order {
    return Intl.message('Show order', name: 'show_order', desc: '', args: []);
  }

  /// `Please enter the number of Returning surfaces`
  String get please_enter_surfaces {
    return Intl.message(
      'Please enter the number of Returning surfaces',
      name: 'please_enter_surfaces',
      desc: '',
      args: [],
    );
  }

  /// `How many pallets do you return?`
  String get pallets_return {
    return Intl.message(
      'How many pallets do you return?',
      name: 'pallets_return',
      desc: '',
      args: [],
    );
  }

  /// `Sub Users`
  String get sub_user {
    return Intl.message('Sub Users', name: 'sub_user', desc: '', args: []);
  }

  /// `New`
  String get new_user {
    return Intl.message('New', name: 'new_user', desc: '', args: []);
  }

  /// `New sub user`
  String get new_sub_user {
    return Intl.message(
      'New sub user',
      name: 'new_sub_user',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get full_name {
    return Intl.message('Full name', name: 'full_name', desc: '', args: []);
  }

  /// `Phone number for login`
  String get phone_number {
    return Intl.message(
      'Phone number for login',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter sub user`
  String get please_enter_sub_user {
    return Intl.message(
      'Please enter sub user',
      name: 'please_enter_sub_user',
      desc: '',
      args: [],
    );
  }

  /// `Account Permission`
  String get account_permission {
    return Intl.message(
      'Account Permission',
      name: 'account_permission',
      desc: '',
      args: [],
    );
  }

  /// `Categories Permissions`
  String get categories_permissions {
    return Intl.message(
      'Categories Permissions',
      name: 'categories_permissions',
      desc: '',
      args: [],
    );
  }

  /// `Brands permissions`
  String get brand_permissions {
    return Intl.message(
      'Brands permissions',
      name: 'brand_permissions',
      desc: '',
      args: [],
    );
  }

  /// `Supplier permissions`
  String get supplier_permissions {
    return Intl.message(
      'Supplier permissions',
      name: 'supplier_permissions',
      desc: '',
      args: [],
    );
  }

  /// `Account admin`
  String get account_admin {
    return Intl.message(
      'Account admin',
      name: 'account_admin',
      desc: '',
      args: [],
    );
  }

  /// `Can see wallet`
  String get can_see_wallet {
    return Intl.message(
      'Can see wallet',
      name: 'can_see_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Can Add to basket`
  String get can_add_basket {
    return Intl.message(
      'Can Add to basket',
      name: 'can_add_basket',
      desc: '',
      args: [],
    );
  }

  /// `Can create orders`
  String get can_create_order {
    return Intl.message(
      'Can create orders',
      name: 'can_create_order',
      desc: '',
      args: [],
    );
  }

  /// `Can approve orders`
  String get can_approve_order {
    return Intl.message(
      'Can approve orders',
      name: 'can_approve_order',
      desc: '',
      args: [],
    );
  }

  /// `Can duplicate orders`
  String get can_duplicate_order {
    return Intl.message(
      'Can duplicate orders',
      name: 'can_duplicate_order',
      desc: '',
      args: [],
    );
  }

  /// `Can see and update business info`
  String get can_see_update_business_info {
    return Intl.message(
      'Can see and update business info',
      name: 'can_see_update_business_info',
      desc: '',
      args: [],
    );
  }

  /// `Can see and update additional info`
  String get can_see_update_additional_info {
    return Intl.message(
      'Can see and update additional info',
      name: 'can_see_update_additional_info',
      desc: '',
      args: [],
    );
  }

  /// `Can see and update times info`
  String get can_see_update_times_info {
    return Intl.message(
      'Can see and update times info',
      name: 'can_see_update_times_info',
      desc: '',
      args: [],
    );
  }

  /// `Can see files and forms`
  String get can_see_files_forms {
    return Intl.message(
      'Can see files and forms',
      name: 'can_see_files_forms',
      desc: '',
      args: [],
    );
  }

  /// `Can manage sub users`
  String get can_manage_sub_users {
    return Intl.message(
      'Can manage sub users',
      name: 'can_manage_sub_users',
      desc: '',
      args: [],
    );
  }

  /// `Select all`
  String get select_all {
    return Intl.message('Select all', name: 'select_all', desc: '', args: []);
  }

  /// `Can see My orders`
  String get see_order {
    return Intl.message(
      'Can see My orders',
      name: 'see_order',
      desc: '',
      args: [],
    );
  }

  /// `Select none`
  String get select_none {
    return Intl.message('Select none', name: 'select_none', desc: '', args: []);
  }

  /// `Not sufficient permission`
  String get not_sufficient_permission {
    return Intl.message(
      'Not sufficient permission',
      name: 'not_sufficient_permission',
      desc: '',
      args: [],
    );
  }

  /// `The phone number is already associated with another user`
  String get phone_number_of_other_sub_user {
    return Intl.message(
      'The phone number is already associated with another user',
      name: 'phone_number_of_other_sub_user',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete_sub_user_account {
    return Intl.message(
      'Delete',
      name: 'delete_sub_user_account',
      desc: '',
      args: [],
    );
  }

  /// `Can see invoices`
  String get can_see_invoices {
    return Intl.message(
      'Can see invoices',
      name: 'can_see_invoices',
      desc: '',
      args: [],
    );
  }

  /// `Maximum Quantity`
  String get maximum_qty {
    return Intl.message(
      'Maximum Quantity',
      name: 'maximum_qty',
      desc: '',
      args: [],
    );
  }

  /// `You can not add more than maximum quantity`
  String get not_add_more_than_max_qty {
    return Intl.message(
      'You can not add more than maximum quantity',
      name: 'not_add_more_than_max_qty',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `clear`
  String get clear {
    return Intl.message('clear', name: 'clear', desc: '', args: []);
  }

  /// `Sorting`
  String get sorting {
    return Intl.message('Sorting', name: 'sorting', desc: '', args: []);
  }

  /// `Filtering`
  String get filtering {
    return Intl.message('Filtering', name: 'filtering', desc: '', args: []);
  }

  /// `Out of stock`
  String get product_no_longer_in_stock {
    return Intl.message(
      'Out of stock',
      name: 'product_no_longer_in_stock',
      desc: '',
      args: [],
    );
  }

  /// `Total price with VAT`
  String get total_price_with_vat {
    return Intl.message(
      'Total price with VAT',
      name: 'total_price_with_vat',
      desc: '',
      args: [],
    );
  }

  /// `Price includes VAT`
  String get price_includes_vat {
    return Intl.message(
      'Price includes VAT',
      name: 'price_includes_vat',
      desc: '',
      args: [],
    );
  }

  /// `Way of payment`
  String get way_of_payment {
    return Intl.message(
      'Way of payment',
      name: 'way_of_payment',
      desc: '',
      args: [],
    );
  }

  /// `Collection from bank account`
  String get collection_from_bank_account {
    return Intl.message(
      'Collection from bank account',
      name: 'collection_from_bank_account',
      desc: '',
      args: [],
    );
  }

  /// `Credit Card`
  String get credit_card {
    return Intl.message('Credit Card', name: 'credit_card', desc: '', args: []);
  }

  /// `Credit card details`
  String get credit_card_details {
    return Intl.message(
      'Credit card details',
      name: 'credit_card_details',
      desc: '',
      args: [],
    );
  }

  /// `Credit card number`
  String get credit_card_number {
    return Intl.message(
      'Credit card number',
      name: 'credit_card_number',
      desc: '',
      args: [],
    );
  }

  /// `Validity`
  String get validity {
    return Intl.message('Validity', name: 'validity', desc: '', args: []);
  }

  /// `There are some products that are out of stock.Do you want to submit the order without products that are out of stock ?`
  String get some_products_out_of_stock_Do_you_want_submit_order {
    return Intl.message(
      'There are some products that are out of stock.Do you want to submit the order without products that are out of stock ?',
      name: 'some_products_out_of_stock_Do_you_want_submit_order',
      desc: '',
      args: [],
    );
  }

  /// `Please enter credit card number`
  String get enter_credit_card_number {
    return Intl.message(
      'Please enter credit card number',
      name: 'enter_credit_card_number',
      desc: '',
      args: [],
    );
  }

  /// `Please enter credit card validity`
  String get enter_credit_card_validity {
    return Intl.message(
      'Please enter credit card validity',
      name: 'enter_credit_card_validity',
      desc: '',
      args: [],
    );
  }

  /// `Manage credit card`
  String get manage_credit_card {
    return Intl.message(
      'Manage credit card',
      name: 'manage_credit_card',
      desc: '',
      args: [],
    );
  }

  /// `There is an error on Israel ID number or Business ID number`
  String get israel_id_or_business_id_number_error {
    return Intl.message(
      'There is an error on Israel ID number or Business ID number',
      name: 'israel_id_or_business_id_number_error',
      desc: '',
      args: [],
    );
  }

  /// `rivchitclienterror`
  String get rivchitclienterror {
    return Intl.message(
      'rivchitclienterror',
      name: 'rivchitclienterror',
      desc: '',
      args: [],
    );
  }

  /// `Change credit card`
  String get change_credit_card {
    return Intl.message(
      'Change credit card',
      name: 'change_credit_card',
      desc: '',
      args: [],
    );
  }

  /// `Add credit card`
  String get add_credit_card {
    return Intl.message(
      'Add credit card',
      name: 'add_credit_card',
      desc: '',
      args: [],
    );
  }

  /// `Delete credit card`
  String get delete_credit_card {
    return Intl.message(
      'Delete credit card',
      name: 'delete_credit_card',
      desc: '',
      args: [],
    );
  }

  /// `Pay with wallet`
  String get change_to_wallet_payment {
    return Intl.message(
      'Pay with wallet',
      name: 'change_to_wallet_payment',
      desc: '',
      args: [],
    );
  }

  /// `Pay with bank transfer`
  String get pay_with_bank_transfer {
    return Intl.message(
      'Pay with bank transfer',
      name: 'pay_with_bank_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Pay with credit card`
  String get pay_with_credit_card {
    return Intl.message(
      'Pay with credit card',
      name: 'pay_with_credit_card',
      desc: '',
      args: [],
    );
  }

  /// `Pay with wallet`
  String get pay_with_wallet {
    return Intl.message(
      'Pay with wallet',
      name: 'pay_with_wallet',
      desc: '',
      args: [],
    );
  }

  /// `This Israel ID already exist in the system.`
  String get israel_id_exist {
    return Intl.message(
      'This Israel ID already exist in the system.',
      name: 'israel_id_exist',
      desc: '',
      args: [],
    );
  }

  /// `TAVILI is under maintenance now, please try again later.`
  String get under_maintenance {
    return Intl.message(
      'TAVILI is under maintenance now, please try again later.',
      name: 'under_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `The Agent code is not correct`
  String get invalid_agent_code {
    return Intl.message(
      'The Agent code is not correct',
      name: 'invalid_agent_code',
      desc: '',
      args: [],
    );
  }

  /// `The Agent code must be 6 digit.`
  String get agent_code_length_error {
    return Intl.message(
      'The Agent code must be 6 digit.',
      name: 'agent_code_length_error',
      desc: '',
      args: [],
    );
  }

  /// `You are blocked, please try again in 30 minutes`
  String get agent_block {
    return Intl.message(
      'You are blocked, please try again in 30 minutes',
      name: 'agent_block',
      desc: '',
      args: [],
    );
  }

  /// `you have only 2 times to add a correct Agent code`
  String get warning_agent_code {
    return Intl.message(
      'you have only 2 times to add a correct Agent code',
      name: 'warning_agent_code',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid israel ID for Owner1`
  String get please_enter_valid_israel_id_owner1 {
    return Intl.message(
      'Please enter valid israel ID for Owner1',
      name: 'please_enter_valid_israel_id_owner1',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid israel ID for Owner2`
  String get please_enter_valid_israel_id_owner2 {
    return Intl.message(
      'Please enter valid israel ID for Owner2',
      name: 'please_enter_valid_israel_id_owner2',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid israel ID for Guarantee1`
  String get please_enter_valid_israel_id_guarantee1 {
    return Intl.message(
      'Please enter valid israel ID for Guarantee1',
      name: 'please_enter_valid_israel_id_guarantee1',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid israel ID for Guarantee2`
  String get please_enter_valid_israel_id_guarantee2 {
    return Intl.message(
      'Please enter valid israel ID for Guarantee2',
      name: 'please_enter_valid_israel_id_guarantee2',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid Guarantee1 Name`
  String get please_enter_valid_guarantee_name1 {
    return Intl.message(
      'Please enter valid Guarantee1 Name',
      name: 'please_enter_valid_guarantee_name1',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid Guarantee2 Name`
  String get please_enter_valid_guarantee_name2 {
    return Intl.message(
      'Please enter valid Guarantee2 Name',
      name: 'please_enter_valid_guarantee_name2',
      desc: '',
      args: [],
    );
  }

  /// `I approve TAVILI to send me promotional info in Email and SMS.`
  String get approve_for_promotional_info {
    return Intl.message(
      'I approve TAVILI to send me promotional info in Email and SMS.',
      name: 'approve_for_promotional_info',
      desc: '',
      args: [],
    );
  }

  /// `You can try again with these options:`
  String get payment_dialog_option_title {
    return Intl.message(
      'You can try again with these options:',
      name: 'payment_dialog_option_title',
      desc: '',
      args: [],
    );
  }

  /// `Understood, Submit Order!`
  String get understand_submit_order {
    return Intl.message(
      'Understood, Submit Order!',
      name: 'understand_submit_order',
      desc: '',
      args: [],
    );
  }

  /// `There is an issue with the Payment.`
  String get issue_with_payment {
    return Intl.message(
      'There is an issue with the Payment.',
      name: 'issue_with_payment',
      desc: '',
      args: [],
    );
  }

  /// `How do you want to pay?`
  String get how_do_you_want_to_pay {
    return Intl.message(
      'How do you want to pay?',
      name: 'how_do_you_want_to_pay',
      desc: '',
      args: [],
    );
  }

  /// `Credit Card Not Found.`
  String get credit_card_not_found {
    return Intl.message(
      'Credit Card Not Found.',
      name: 'credit_card_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Credit Card Payment failed.`
  String get credit_card_payment_failed {
    return Intl.message(
      'Credit Card Payment failed.',
      name: 'credit_card_payment_failed',
      desc: '',
      args: [],
    );
  }

  /// `Bank Not Found.`
  String get bank_not_found {
    return Intl.message(
      'Bank Not Found.',
      name: 'bank_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Business Type Not Found.`
  String get business_type_not_found {
    return Intl.message(
      'Business Type Not Found.',
      name: 'business_type_not_found',
      desc: '',
      args: [],
    );
  }

  /// `User Not Updated.`
  String get user_not_updated {
    return Intl.message(
      'User Not Updated.',
      name: 'user_not_updated',
      desc: '',
      args: [],
    );
  }

  /// `Status Not Found.`
  String get status_not_found {
    return Intl.message(
      'Status Not Found.',
      name: 'status_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Client Details Not found.`
  String get client_details_not_found {
    return Intl.message(
      'Client Details Not found.',
      name: 'client_details_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong in BDI`
  String get bdi_error {
    return Intl.message(
      'Something went wrong in BDI',
      name: 'bdi_error',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message('Year', name: 'year', desc: '', args: []);
  }

  /// `Month`
  String get month {
    return Intl.message('Month', name: 'month', desc: '', args: []);
  }

  /// `Please enter valid year`
  String get enter_valid_year {
    return Intl.message(
      'Please enter valid year',
      name: 'enter_valid_year',
      desc: '',
      args: [],
    );
  }

  /// `Please select valid month`
  String get select_valid_month {
    return Intl.message(
      'Please select valid month',
      name: 'select_valid_month',
      desc: '',
      args: [],
    );
  }

  /// `Minimum box`
  String get minimum_box {
    return Intl.message('Minimum box', name: 'minimum_box', desc: '', args: []);
  }

  /// `The minimum number of packages for this sale is: `
  String get minimum_box_title {
    return Intl.message(
      'The minimum number of packages for this sale is: ',
      name: 'minimum_box_title',
      desc: '',
      args: [],
    );
  }

  /// `The minimum boxes for this mixed sale is: `
  String get mix_minimum_box_title {
    return Intl.message(
      'The minimum boxes for this mixed sale is: ',
      name: 'mix_minimum_box_title',
      desc: '',
      args: [],
    );
  }

  /// `This is a mixed sale`
  String get mix_sale_text {
    return Intl.message(
      'This is a mixed sale',
      name: 'mix_sale_text',
      desc: '',
      args: [],
    );
  }

  /// `If you do not order at least`
  String get sale_other_text {
    return Intl.message(
      'If you do not order at least',
      name: 'sale_other_text',
      desc: '',
      args: [],
    );
  }

  /// `products, you will not receive the sale price`
  String get sale_other_text1 {
    return Intl.message(
      'products, you will not receive the sale price',
      name: 'sale_other_text1',
      desc: '',
      args: [],
    );
  }

  /// `You may also order from the other products participating in the sale`
  String get mixed_sale_other_text {
    return Intl.message(
      'You may also order from the other products participating in the sale',
      name: 'mixed_sale_other_text',
      desc: '',
      args: [],
    );
  }

  /// `, are you sure you don’t want to get the sale price?`
  String get confirm_minimum_box {
    return Intl.message(
      ', are you sure you don’t want to get the sale price?',
      name: 'confirm_minimum_box',
      desc: '',
      args: [],
    );
  }

  /// `Product participating in the sale:`
  String get productParticipatingSale {
    return Intl.message(
      'Product participating in the sale:',
      name: 'productParticipatingSale',
      desc: '',
      args: [],
    );
  }

  /// `The minimum boxes for this sale is: `
  String get minimum_boxes_detail {
    return Intl.message(
      'The minimum boxes for this sale is: ',
      name: 'minimum_boxes_detail',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get addText {
    return Intl.message('Add', name: 'addText', desc: '', args: []);
  }

  /// `Close`
  String get closeText {
    return Intl.message('Close', name: 'closeText', desc: '', args: []);
  }

  /// `Mixed sale`
  String get mixedSale {
    return Intl.message('Mixed sale', name: 'mixedSale', desc: '', args: []);
  }

  /// `Min`
  String get minGrid {
    return Intl.message('Min', name: 'minGrid', desc: '', args: []);
  }

  /// `Max`
  String get maxGrid {
    return Intl.message('Max', name: 'maxGrid', desc: '', args: []);
  }

  /// `Minimum`
  String get minimumGrid {
    return Intl.message('Minimum', name: 'minimumGrid', desc: '', args: []);
  }

  /// `Maximum`
  String get maximumGrid {
    return Intl.message('Maximum', name: 'maximumGrid', desc: '', args: []);
  }

  /// `Minimum for sale`
  String get minimumList {
    return Intl.message(
      'Minimum for sale',
      name: 'minimumList',
      desc: '',
      args: [],
    );
  }

  /// `Maximum for sale`
  String get maximumList {
    return Intl.message(
      'Maximum for sale',
      name: 'maximumList',
      desc: '',
      args: [],
    );
  }

  /// `Savings for sales`
  String get savings_for_sales {
    return Intl.message(
      'Savings for sales',
      name: 'savings_for_sales',
      desc: '',
      args: [],
    );
  }

  /// `Not minimum order`
  String get not_minimum_order {
    return Intl.message(
      'Not minimum order',
      name: 'not_minimum_order',
      desc: '',
      args: [],
    );
  }

  /// `Show All Results`
  String get show_all_results {
    return Intl.message(
      'Show All Results',
      name: 'show_all_results',
      desc: '',
      args: [],
    );
  }

  /// `Bank transfer information`
  String get bank_transfer_information {
    return Intl.message(
      'Bank transfer information',
      name: 'bank_transfer_information',
      desc: '',
      args: [],
    );
  }

  /// `Pay with bank check`
  String get pay_with_bank_check {
    return Intl.message(
      'Pay with bank check',
      name: 'pay_with_bank_check',
      desc: '',
      args: [],
    );
  }

  /// `Due Date`
  String get due_date {
    return Intl.message('Due Date', name: 'due_date', desc: '', args: []);
  }

  /// `You will be charged when you get the invoice`
  String get invoice_charge {
    return Intl.message(
      'You will be charged when you get the invoice',
      name: 'invoice_charge',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paid {
    return Intl.message('Paid', name: 'paid', desc: '', args: []);
  }

  /// `Wallet`
  String get wallet {
    return Intl.message('Wallet', name: 'wallet', desc: '', args: []);
  }

  /// `Bank Transfer`
  String get bank_transfer {
    return Intl.message(
      'Bank Transfer',
      name: 'bank_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Bank Check`
  String get bank_check {
    return Intl.message('Bank Check', name: 'bank_check', desc: '', args: []);
  }

  /// `Payment Type`
  String get payment_type {
    return Intl.message(
      'Payment Type',
      name: 'payment_type',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message('Copy', name: 'copy', desc: '', args: []);
  }

  /// `Copied!`
  String get copied {
    return Intl.message('Copied!', name: 'copied', desc: '', args: []);
  }

  /// `Select Number of Owners`
  String get select_number_of_owners {
    return Intl.message(
      'Select Number of Owners',
      name: 'select_number_of_owners',
      desc: '',
      args: [],
    );
  }

  /// `Owner first Name`
  String get owner_first_name {
    return Intl.message(
      'Owner first Name',
      name: 'owner_first_name',
      desc: '',
      args: [],
    );
  }

  /// `Owner last Name`
  String get owner_last_name {
    return Intl.message(
      'Owner last Name',
      name: 'owner_last_name',
      desc: '',
      args: [],
    );
  }

  /// `Back to Orders`
  String get back_to_order {
    return Intl.message(
      'Back to Orders',
      name: 'back_to_order',
      desc: '',
      args: [],
    );
  }

  /// `Returns`
  String get returns {
    return Intl.message('Returns', name: 'returns', desc: '', args: []);
  }

  /// `Enter the product barcode`
  String get enter_product_barcode {
    return Intl.message(
      'Enter the product barcode',
      name: 'enter_product_barcode',
      desc: '',
      args: [],
    );
  }

  /// `Scan return product`
  String get scan_return_product {
    return Intl.message(
      'Scan return product',
      name: 'scan_return_product',
      desc: '',
      args: [],
    );
  }

  /// `Product return info`
  String get product_return_info {
    return Intl.message(
      'Product return info',
      name: 'product_return_info',
      desc: '',
      args: [],
    );
  }

  /// `Number of units for return?`
  String get no_of_unit_for_return {
    return Intl.message(
      'Number of units for return?',
      name: 'no_of_unit_for_return',
      desc: '',
      args: [],
    );
  }

  /// `Why do you want to return the product?`
  String get why_return_product {
    return Intl.message(
      'Why do you want to return the product?',
      name: 'why_return_product',
      desc: '',
      args: [],
    );
  }

  /// `Add proof images`
  String get add_proof_img {
    return Intl.message(
      'Add proof images',
      name: 'add_proof_img',
      desc: '',
      args: [],
    );
  }

  /// `A photocopy of the delivery receipt you received`
  String get add_driver_delivery_document_img {
    return Intl.message(
      'A photocopy of the delivery receipt you received',
      name: 'add_driver_delivery_document_img',
      desc: '',
      args: [],
    );
  }

  /// `The delivery note must be photographed as proof of receipt of the goods.`
  String get add_driver_delivery_document_img_note {
    return Intl.message(
      'The delivery note must be photographed as proof of receipt of the goods.',
      name: 'add_driver_delivery_document_img_note',
      desc: '',
      args: [],
    );
  }

  /// `A photocopy of the return certificate you received`
  String get driver_return_delivery_document_img {
    return Intl.message(
      'A photocopy of the return certificate you received',
      name: 'driver_return_delivery_document_img',
      desc: '',
      args: [],
    );
  }

  /// `The return receipt must be photographed as proof of returning the goods.`
  String get driver_return_delivery_document_img_note {
    return Intl.message(
      'The return receipt must be photographed as proof of returning the goods.',
      name: 'driver_return_delivery_document_img_note',
      desc: '',
      args: [],
    );
  }

  /// `Add your notes here`
  String get add_notes {
    return Intl.message(
      'Add your notes here',
      name: 'add_notes',
      desc: '',
      args: [],
    );
  }

  /// `New Return`
  String get new_return {
    return Intl.message('New Return', name: 'new_return', desc: '', args: []);
  }

  /// `The product is defective`
  String get product_defective {
    return Intl.message(
      'The product is defective',
      name: 'product_defective',
      desc: '',
      args: [],
    );
  }

  /// `The product has expiration date issue`
  String get product_expiration_date_issue {
    return Intl.message(
      'The product has expiration date issue',
      name: 'product_expiration_date_issue',
      desc: '',
      args: [],
    );
  }

  /// `Wrong product`
  String get wrong_product {
    return Intl.message(
      'Wrong product',
      name: 'wrong_product',
      desc: '',
      args: [],
    );
  }

  /// `Product return list`
  String get product_return_list {
    return Intl.message(
      'Product return list',
      name: 'product_return_list',
      desc: '',
      args: [],
    );
  }

  /// `Add another product`
  String get add_another_product {
    return Intl.message(
      'Add another product',
      name: 'add_another_product',
      desc: '',
      args: [],
    );
  }

  /// `Send the request`
  String get send_the_request {
    return Intl.message(
      'Send the request',
      name: 'send_the_request',
      desc: '',
      args: [],
    );
  }

  /// `Open refund invoice`
  String get open_refund_invoice {
    return Intl.message(
      'Open refund invoice',
      name: 'open_refund_invoice',
      desc: '',
      args: [],
    );
  }

  /// `The product doesn't exist in the system`
  String get product_does_not_exist {
    return Intl.message(
      'The product doesn\'t exist in the system',
      name: 'product_does_not_exist',
      desc: '',
      args: [],
    );
  }

  /// `Date Sent:`
  String get date_sent {
    return Intl.message('Date Sent:', name: 'date_sent', desc: '', args: []);
  }

  /// `Date Approved:`
  String get date_approved {
    return Intl.message(
      'Date Approved:',
      name: 'date_approved',
      desc: '',
      args: [],
    );
  }

  /// `Total refunds:`
  String get total_refund {
    return Intl.message(
      'Total refunds:',
      name: 'total_refund',
      desc: '',
      args: [],
    );
  }

  /// `View invoice`
  String get view_invoice {
    return Intl.message(
      'View invoice',
      name: 'view_invoice',
      desc: '',
      args: [],
    );
  }

  /// `please enter the units`
  String get enter_units {
    return Intl.message(
      'please enter the units',
      name: 'enter_units',
      desc: '',
      args: [],
    );
  }

  /// `please select one of the options`
  String get select_one_option {
    return Intl.message(
      'please select one of the options',
      name: 'select_one_option',
      desc: '',
      args: [],
    );
  }

  /// `You must add at least one proof image`
  String get add_one_proof_img {
    return Intl.message(
      'You must add at least one proof image',
      name: 'add_one_proof_img',
      desc: '',
      args: [],
    );
  }

  /// `Return not found.`
  String get return_not_found {
    return Intl.message(
      'Return not found.',
      name: 'return_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Return deleted successfully.`
  String get return_deleted {
    return Intl.message(
      'Return deleted successfully.',
      name: 'return_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Return Summary`
  String get return_summary {
    return Intl.message(
      'Return Summary',
      name: 'return_summary',
      desc: '',
      args: [],
    );
  }

  /// `Return created successfully.`
  String get return_created_success {
    return Intl.message(
      'Return created successfully.',
      name: 'return_created_success',
      desc: '',
      args: [],
    );
  }

  /// `Return updated successfully.`
  String get return_updated_success {
    return Intl.message(
      'Return updated successfully.',
      name: 'return_updated_success',
      desc: '',
      args: [],
    );
  }

  /// `Click to Scan Products`
  String get click_to_scan {
    return Intl.message(
      'Click to Scan Products',
      name: 'click_to_scan',
      desc: '',
      args: [],
    );
  }

  /// `You have`
  String get you_have {
    return Intl.message('You have', name: 'you_have', desc: '', args: []);
  }

  /// ` hours to create more orders without any minimum limit to the supplier Tavili.`
  String get countdown {
    return Intl.message(
      ' hours to create more orders without any minimum limit to the supplier Tavili.',
      name: 'countdown',
      desc: '',
      args: [],
    );
  }

  /// `Call the Agent`
  String get call_the_agent {
    return Intl.message(
      'Call the Agent',
      name: 'call_the_agent',
      desc: '',
      args: [],
    );
  }

  /// `You have returns that haven't been sent yet.`
  String get return_draft_not_sent {
    return Intl.message(
      'You have returns that haven\'t been sent yet.',
      name: 'return_draft_not_sent',
      desc: '',
      args: [],
    );
  }

  /// `View Return`
  String get view_return {
    return Intl.message('View Return', name: 'view_return', desc: '', args: []);
  }

  /// `Send any way`
  String get send_any_way {
    return Intl.message(
      'Send any way',
      name: 'send_any_way',
      desc: '',
      args: [],
    );
  }

  /// `The, return has been successfully recorded. For convenience, your return will be sent on the day you place your next order. Until then, you can add more returns.`
  String get waiting_for_new_order_success_msg {
    return Intl.message(
      'The, return has been successfully recorded. For convenience, your return will be sent on the day you place your next order. Until then, you can add more returns.',
      name: 'waiting_for_new_order_success_msg',
      desc: '',
      args: [],
    );
  }

  /// `issue: `
  String get issue_text {
    return Intl.message('issue: ', name: 'issue_text', desc: '', args: []);
  }

  /// `Return Number: `
  String get return_number_text {
    return Intl.message(
      'Return Number: ',
      name: 'return_number_text',
      desc: '',
      args: [],
    );
  }

  /// `You must add delivery document image`
  String get return_delivery_document_image {
    return Intl.message(
      'You must add delivery document image',
      name: 'return_delivery_document_image',
      desc: '',
      args: [],
    );
  }

  /// `You must add return document image`
  String get driver_return_document_image {
    return Intl.message(
      'You must add return document image',
      name: 'driver_return_document_image',
      desc: '',
      args: [],
    );
  }

  /// `Your order is being sent`
  String get basket_loader_text {
    return Intl.message(
      'Your order is being sent',
      name: 'basket_loader_text',
      desc: '',
      args: [],
    );
  }

  /// `Please wait...`
  String get please_wait_text {
    return Intl.message(
      'Please wait...',
      name: 'please_wait_text',
      desc: '',
      args: [],
    );
  }

  /// `Your order confirmation is being sent`
  String get order_confirmation_loader_text {
    return Intl.message(
      'Your order confirmation is being sent',
      name: 'order_confirmation_loader_text',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open_text {
    return Intl.message('Open', name: 'open_text', desc: '', args: []);
  }

  /// `Closed`
  String get closed_text {
    return Intl.message('Closed', name: 'closed_text', desc: '', args: []);
  }

  /// `In Progress`
  String get in_progress_text {
    return Intl.message(
      'In Progress',
      name: 'in_progress_text',
      desc: '',
      args: [],
    );
  }

  /// `Partially Closed`
  String get partially_closed_text {
    return Intl.message(
      'Partially Closed',
      name: 'partially_closed_text',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'he'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
