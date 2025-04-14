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

class TR {
  TR();

  static TR? _current;

  static TR get current {
    assert(_current != null,
        'No instance of TR was loaded. Try to initialize the TR delegate before accessing TR.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<TR> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = TR();
      TR._current = instance;

      return instance;
    });
  }

  static TR of(BuildContext context) {
    final instance = TR.maybeOf(context);
    assert(instance != null,
        'No instance of TR present in the widget tree. Did you add TR.delegate in localizationsDelegates?');
    return instance!;
  }

  static TR? maybeOf(BuildContext context) {
    return Localizations.of<TR>(context, TR);
  }

  /// `Payable`
  String get payable {
    return Intl.message(
      'Payable',
      name: 'payable',
      desc: '',
      args: [],
    );
  }

  /// `Tap To `
  String get tap_to {
    return Intl.message(
      'Tap To ',
      name: 'tap_to',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message(
      'Guest',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `Your order is ready for payment`
  String get your_order_ready_for_payment {
    return Intl.message(
      'Your order is ready for payment',
      name: 'your_order_ready_for_payment',
      desc: '',
      args: [],
    );
  }

  /// `There are not any reviews for this product yet!!!`
  String get there_no_review {
    return Intl.message(
      'There are not any reviews for this product yet!!!',
      name: 'there_no_review',
      desc: '',
      args: [],
    );
  }

  /// `Complete Payment`
  String get complete_payment {
    return Intl.message(
      'Complete Payment',
      name: 'complete_payment',
      desc: '',
      args: [],
    );
  }

  /// `Ready For Payment`
  String get ready_for_payment {
    return Intl.message(
      'Ready For Payment',
      name: 'ready_for_payment',
      desc: '',
      args: [],
    );
  }

  /// `See Details`
  String get see_details {
    return Intl.message(
      'See Details',
      name: 'see_details',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Charge`
  String get charge {
    return Intl.message(
      'Charge',
      name: 'charge',
      desc: '',
      args: [],
    );
  }

  /// `Payment Failed`
  String get payment_failed {
    return Intl.message(
      'Payment Failed',
      name: 'payment_failed',
      desc: '',
      args: [],
    );
  }

  /// `Payment Success`
  String get payment_success {
    return Intl.message(
      'Payment Success',
      name: 'payment_success',
      desc: '',
      args: [],
    );
  }

  /// `Return Home`
  String get return_home {
    return Intl.message(
      'Return Home',
      name: 'return_home',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong with your payment`
  String get payment_failed_massage {
    return Intl.message(
      'Something went wrong with your payment',
      name: 'payment_failed_massage',
      desc: '',
      args: [],
    );
  }

  /// `Your payment has been successfully processed`
  String get payment_success_massage {
    return Intl.message(
      'Your payment has been successfully processed',
      name: 'payment_success_massage',
      desc: '',
      args: [],
    );
  }

  /// `Search Categories`
  String get search_categories {
    return Intl.message(
      'Search Categories',
      name: 'search_categories',
      desc: '',
      args: [],
    );
  }

  /// `Order History`
  String get order_history {
    return Intl.message(
      'Order History',
      name: 'order_history',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been placed successfully.`
  String get order_place_successfully {
    return Intl.message(
      'Your order has been placed successfully.',
      name: 'order_place_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Continue Shopping`
  String get continue_shopping {
    return Intl.message(
      'Continue Shopping',
      name: 'continue_shopping',
      desc: '',
      args: [],
    );
  }

  /// `Have any question?Reach directly to our`
  String get have_question {
    return Intl.message(
      'Have any question?Reach directly to our',
      name: 'have_question',
      desc: '',
      args: [],
    );
  }

  /// `Customer Support`
  String get customer_support {
    return Intl.message(
      'Customer Support',
      name: 'customer_support',
      desc: '',
      args: [],
    );
  }

  /// `Order Confirm`
  String get order_confirm {
    return Intl.message(
      'Order Confirm',
      name: 'order_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Flash Product`
  String get flash_product {
    return Intl.message(
      'Flash Product',
      name: 'flash_product',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Search Brands`
  String get search_brands {
    return Intl.message(
      'Search Brands',
      name: 'search_brands',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `All Order`
  String get all_order {
    return Intl.message(
      'All Order',
      name: 'all_order',
      desc: '',
      args: [],
    );
  }

  /// `All Product`
  String get all_product {
    return Intl.message(
      'All Product',
      name: 'all_product',
      desc: '',
      args: [],
    );
  }

  /// `Shipped Order`
  String get shipped_order {
    return Intl.message(
      'Shipped Order',
      name: 'shipped_order',
      desc: '',
      args: [],
    );
  }

  /// `Followed Store`
  String get followed_store {
    return Intl.message(
      'Followed Store',
      name: 'followed_store',
      desc: '',
      args: [],
    );
  }

  /// `To Review`
  String get to_review {
    return Intl.message(
      'To Review',
      name: 'to_review',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Store`
  String get store {
    return Intl.message(
      'Store',
      name: 'store',
      desc: '',
      args: [],
    );
  }

  /// `Visit Store`
  String get visit_store {
    return Intl.message(
      'Visit Store',
      name: 'visit_store',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get follow {
    return Intl.message(
      'Follow',
      name: 'follow',
      desc: '',
      args: [],
    );
  }

  /// `Flash Deals`
  String get flash_deals {
    return Intl.message(
      'Flash Deals',
      name: 'flash_deals',
      desc: '',
      args: [],
    );
  }

  /// `Get'em before they're gone!`
  String get flash_sub {
    return Intl.message(
      'Get\'em before they\'re gone!',
      name: 'flash_sub',
      desc: '',
      args: [],
    );
  }

  /// `Track Order`
  String get track_order {
    return Intl.message(
      'Track Order',
      name: 'track_order',
      desc: '',
      args: [],
    );
  }

  /// `Suggested  Product`
  String get suggest_product {
    return Intl.message(
      'Suggested  Product',
      name: 'suggest_product',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Charge`
  String get shipping_charge {
    return Intl.message(
      'Shipping Charge',
      name: 'shipping_charge',
      desc: '',
      args: [],
    );
  }

  /// `Featured Categories`
  String get category {
    return Intl.message(
      'Featured Categories',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Sub Total`
  String get sub_total {
    return Intl.message(
      'Sub Total',
      name: 'sub_total',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get all {
    return Intl.message(
      'See All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Wishlist`
  String get wishlist {
    return Intl.message(
      'Wishlist',
      name: 'wishlist',
      desc: '',
      args: [],
    );
  }

  /// `Shopping`
  String get shopping {
    return Intl.message(
      'Shopping',
      name: 'shopping',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Deal of the Day`
  String get deal_of_the_day {
    return Intl.message(
      'Deal of the Day',
      name: 'deal_of_the_day',
      desc: '',
      args: [],
    );
  }

  /// `Campaign`
  String get campaign {
    return Intl.message(
      'Campaign',
      name: 'campaign',
      desc: '',
      args: [],
    );
  }

  /// `Featured Products`
  String get featured_products {
    return Intl.message(
      'Featured Products',
      name: 'featured_products',
      desc: '',
      args: [],
    );
  }

  /// `New Arrivals`
  String get new_arrivals {
    return Intl.message(
      'New Arrivals',
      name: 'new_arrivals',
      desc: '',
      args: [],
    );
  }

  /// `Digital Products`
  String get digital_products {
    return Intl.message(
      'Digital Products',
      name: 'digital_products',
      desc: '',
      args: [],
    );
  }

  /// `Brands`
  String get brands {
    return Intl.message(
      'Brands',
      name: 'brands',
      desc: '',
      args: [],
    );
  }

  /// `My Order`
  String get my_order {
    return Intl.message(
      'My Order',
      name: 'my_order',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get Welcome {
    return Intl.message(
      'Welcome',
      name: 'Welcome',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Get In Touch`
  String get get_in_touch {
    return Intl.message(
      'Get In Touch',
      name: 'get_in_touch',
      desc: '',
      args: [],
    );
  }

  /// `No Item Found`
  String get no_item_found {
    return Intl.message(
      'No Item Found',
      name: 'no_item_found',
      desc: '',
      args: [],
    );
  }

  /// `Enter coupon code here`
  String get enter_coupon {
    return Intl.message(
      'Enter coupon code here',
      name: 'enter_coupon',
      desc: '',
      args: [],
    );
  }

  /// `Helpline`
  String get helpline {
    return Intl.message(
      'Helpline',
      name: 'helpline',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email and password to get access your account`
  String get login_subtitle {
    return Intl.message(
      'Enter your email and password to get access your account',
      name: 'login_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get create_account {
    return Intl.message(
      'Create Account',
      name: 'create_account',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter valid information to access your account`
  String get reg_subtitle {
    return Intl.message(
      'Please Enter valid information to access your account',
      name: 'reg_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Have questions or need to report an issue with our product or service? We have got you covered.`
  String get helpline_subtitle {
    return Intl.message(
      'Have questions or need to report an issue with our product or service? We have got you covered.',
      name: 'helpline_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Nothing To Show`
  String get nothing_to_show {
    return Intl.message(
      'Nothing To Show',
      name: 'nothing_to_show',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get region {
    return Intl.message(
      'Region',
      name: 'region',
      desc: '',
      args: [],
    );
  }

  /// `Shopping Cart`
  String get shopping_cart {
    return Intl.message(
      'Shopping Cart',
      name: 'shopping_cart',
      desc: '',
      args: [],
    );
  }

  /// `Submit Order`
  String get submit_order {
    return Intl.message(
      'Submit Order',
      name: 'submit_order',
      desc: '',
      args: [],
    );
  }

  /// `Sub Total`
  String get subtotal {
    return Intl.message(
      'Sub Total',
      name: 'subtotal',
      desc: '',
      args: [],
    );
  }

  /// `Product Details`
  String get product_details {
    return Intl.message(
      'Product Details',
      name: 'product_details',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get review {
    return Intl.message(
      'Review',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Method`
  String get shipping_method {
    return Intl.message(
      'Shipping Method',
      name: 'shipping_method',
      desc: '',
      args: [],
    );
  }

  /// `Related Product`
  String get related_product {
    return Intl.message(
      'Related Product',
      name: 'related_product',
      desc: '',
      args: [],
    );
  }

  /// `Add To Cart`
  String get add_to_cart {
    return Intl.message(
      'Add To Cart',
      name: 'add_to_cart',
      desc: '',
      args: [],
    );
  }

  /// `Select Shipping Method`
  String get Select_shipping_method {
    return Intl.message(
      'Select Shipping Method',
      name: 'Select_shipping_method',
      desc: '',
      args: [],
    );
  }

  /// `No Shipping Information To Show`
  String get No_Shipping_information_to_Show {
    return Intl.message(
      'No Shipping Information To Show',
      name: 'No_Shipping_information_to_Show',
      desc: '',
      args: [],
    );
  }

  /// `Standard Delivery`
  String get standard_delivery {
    return Intl.message(
      'Standard Delivery',
      name: 'standard_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Something Went Wrong`
  String get something_went_wrong {
    return Intl.message(
      'Something Went Wrong',
      name: 'something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Information`
  String get shipping_details {
    return Intl.message(
      'Shipping Information',
      name: 'shipping_details',
      desc: '',
      args: [],
    );
  }

  /// `Next Pay`
  String get next_pay {
    return Intl.message(
      'Next Pay',
      name: 'next_pay',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get full_name {
    return Intl.message(
      'Name',
      name: 'full_name',
      desc: '',
      args: [],
    );
  }

  /// `Write A Review`
  String get write_a_review {
    return Intl.message(
      'Write A Review',
      name: 'write_a_review',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `E-Mail`
  String get email {
    return Intl.message(
      'E-Mail',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Street name`
  String get address {
    return Intl.message(
      'Street name',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get state_name {
    return Intl.message(
      'State',
      name: 'state_name',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city_name {
    return Intl.message(
      'City',
      name: 'city_name',
      desc: '',
      args: [],
    );
  }

  /// `Zip Code`
  String get zip_code {
    return Intl.message(
      'Zip Code',
      name: 'zip_code',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Address`
  String get shipping_address {
    return Intl.message(
      'Shipping Address',
      name: 'shipping_address',
      desc: '',
      args: [],
    );
  }

  /// `Coupon Code`
  String get coupon_code {
    return Intl.message(
      'Coupon Code',
      name: 'coupon_code',
      desc: '',
      args: [],
    );
  }

  /// `Select Payment Method`
  String get select_payment_method {
    return Intl.message(
      'Select Payment Method',
      name: 'select_payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Order Successful`
  String get order_successful {
    return Intl.message(
      'Order Successful',
      name: 'order_successful',
      desc: '',
      args: [],
    );
  }

  /// `Your Order Placement Was Successful`
  String get your_order_placement_was_successful {
    return Intl.message(
      'Your Order Placement Was Successful',
      name: 'your_order_placement_was_successful',
      desc: '',
      args: [],
    );
  }

  /// `Pay now`
  String get pay_now {
    return Intl.message(
      'Pay now',
      name: 'pay_now',
      desc: '',
      args: [],
    );
  }

  /// `Order Page`
  String get order_page {
    return Intl.message(
      'Order Page',
      name: 'order_page',
      desc: '',
      args: [],
    );
  }

  /// `Back To Home`
  String get Back_to_home {
    return Intl.message(
      'Back To Home',
      name: 'Back_to_home',
      desc: '',
      args: [],
    );
  }

  /// `Tracking Info`
  String get tracking_info {
    return Intl.message(
      'Tracking Info',
      name: 'tracking_info',
      desc: '',
      args: [],
    );
  }

  /// `Tracking Id`
  String get tracking_id {
    return Intl.message(
      'Tracking Id',
      name: 'tracking_id',
      desc: '',
      args: [],
    );
  }

  /// `Track Now`
  String get track_now {
    return Intl.message(
      'Track Now',
      name: 'track_now',
      desc: '',
      args: [],
    );
  }

  /// `Order Details`
  String get order_details {
    return Intl.message(
      'Order Details',
      name: 'order_details',
      desc: '',
      args: [],
    );
  }

  /// `Order Timeline`
  String get order_timeline {
    return Intl.message(
      'Order Timeline',
      name: 'order_timeline',
      desc: '',
      args: [],
    );
  }

  /// `Order Info`
  String get order_info {
    return Intl.message(
      'Order Info',
      name: 'order_info',
      desc: '',
      args: [],
    );
  }

  /// `Order Id`
  String get order_id {
    return Intl.message(
      'Order Id',
      name: 'order_id',
      desc: '',
      args: [],
    );
  }

  /// `Order Placement`
  String get order_placement {
    return Intl.message(
      'Order Placement',
      name: 'order_placement',
      desc: '',
      args: [],
    );
  }

  /// `Shipping By`
  String get shipping_by {
    return Intl.message(
      'Shipping By',
      name: 'shipping_by',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Billing Info`
  String get billing_info {
    return Intl.message(
      'Billing Info',
      name: 'billing_info',
      desc: '',
      args: [],
    );
  }

  /// `Payment Info`
  String get payment_info {
    return Intl.message(
      'Payment Info',
      name: 'payment_info',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get transactions {
    return Intl.message(
      'Transactions',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get payment_method {
    return Intl.message(
      'Payment Method',
      name: 'payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Payment Status`
  String get payment_status {
    return Intl.message(
      'Payment Status',
      name: 'payment_status',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get total_amount {
    return Intl.message(
      'Total Amount',
      name: 'total_amount',
      desc: '',
      args: [],
    );
  }

  /// `Search Product`
  String get search_for_product {
    return Intl.message(
      'Search Product',
      name: 'search_for_product',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Language & Currency`
  String get language_and_currency {
    return Intl.message(
      'Language & Currency',
      name: 'language_and_currency',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message(
      'Currency',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Login To Your Account`
  String get login_to_account {
    return Intl.message(
      'Login To Your Account',
      name: 'login_to_account',
      desc: '',
      args: [],
    );
  }

  /// `Do not have an account?  `
  String get donot_have_account {
    return Intl.message(
      'Do not have an account?  ',
      name: 'donot_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Register now`
  String get register_now {
    return Intl.message(
      'Register now',
      name: 'register_now',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?  `
  String get already_have_account {
    return Intl.message(
      'Already have an account?  ',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Login now`
  String get login_now {
    return Intl.message(
      'Login now',
      name: 'login_now',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Name`
  String get enter_name {
    return Intl.message(
      'Enter Your Name',
      name: 'enter_name',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Digital Orders`
  String get digital_order {
    return Intl.message(
      'Digital Orders',
      name: 'digital_order',
      desc: '',
      args: [],
    );
  }

  /// `Buy Now`
  String get buy_now {
    return Intl.message(
      'Buy Now',
      name: 'buy_now',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Select an item`
  String get select_item_digital {
    return Intl.message(
      'Select an item',
      name: 'select_item_digital',
      desc: '',
      args: [],
    );
  }

  /// `Can not be empty`
  String get cant_be_empty {
    return Intl.message(
      'Can not be empty',
      name: 'cant_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Enter Valid Number`
  String get enter_valid_Name {
    return Intl.message(
      'Enter Valid Number',
      name: 'enter_valid_Name',
      desc: '',
      args: [],
    );
  }

  /// `Enter Valid Email`
  String get enter_valid_email {
    return Intl.message(
      'Enter Valid Email',
      name: 'enter_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get filters {
    return Intl.message(
      'Filters',
      name: 'filters',
      desc: '',
      args: [],
    );
  }

  /// `Sort With Price`
  String get sort_with_price {
    return Intl.message(
      'Sort With Price',
      name: 'sort_with_price',
      desc: '',
      args: [],
    );
  }

  /// `Min`
  String get min {
    return Intl.message(
      'Min',
      name: 'min',
      desc: '',
      args: [],
    );
  }

  /// `Max`
  String get max {
    return Intl.message(
      'Max',
      name: 'max',
      desc: '',
      args: [],
    );
  }

  /// `Sort order`
  String get sort_order {
    return Intl.message(
      'Sort order',
      name: 'sort_order',
      desc: '',
      args: [],
    );
  }

  /// `Low to high`
  String get low_to_high {
    return Intl.message(
      'Low to high',
      name: 'low_to_high',
      desc: '',
      args: [],
    );
  }

  /// `High to low`
  String get high_to_low {
    return Intl.message(
      'High to low',
      name: 'high_to_low',
      desc: '',
      args: [],
    );
  }

  /// `reset`
  String get reset {
    return Intl.message(
      'reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `In stock`
  String get in_stock {
    return Intl.message(
      'In stock',
      name: 'in_stock',
      desc: '',
      args: [],
    );
  }

  /// `Stock out`
  String get stock_out {
    return Intl.message(
      'Stock out',
      name: 'stock_out',
      desc: '',
      args: [],
    );
  }

  /// `Short Description`
  String get short_description {
    return Intl.message(
      'Short Description',
      name: 'short_description',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Support Ticket`
  String get support_ticket {
    return Intl.message(
      'Support Ticket',
      name: 'support_ticket',
      desc: '',
      args: [],
    );
  }

  /// `Create Support Ticket`
  String get create_ticket {
    return Intl.message(
      'Create Support Ticket',
      name: 'create_ticket',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Close Ticket`
  String get close_ticket {
    return Intl.message(
      'Close Ticket',
      name: 'close_ticket',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure`
  String get are_you_sure {
    return Intl.message(
      'Are you sure',
      name: 'are_you_sure',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Type a message`
  String get type_a_message {
    return Intl.message(
      'Type a message',
      name: 'type_a_message',
      desc: '',
      args: [],
    );
  }

  /// `This ticket has been closed`
  String get ticket_is_closed {
    return Intl.message(
      'This ticket has been closed',
      name: 'ticket_is_closed',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get files {
    return Intl.message(
      'Files',
      name: 'files',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get subject {
    return Intl.message(
      'Subject',
      name: 'subject',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Ship and Bill to`
  String get ship_n_bill {
    return Intl.message(
      'Ship and Bill to',
      name: 'ship_n_bill',
      desc: '',
      args: [],
    );
  }

  /// `Package`
  String get package {
    return Intl.message(
      'Package',
      name: 'package',
      desc: '',
      args: [],
    );
  }

  /// `Invalid ID`
  String get invalid_id {
    return Intl.message(
      'Invalid ID',
      name: 'invalid_id',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Choose attributes`
  String get choose_attributes {
    return Intl.message(
      'Choose attributes',
      name: 'choose_attributes',
      desc: '',
      args: [],
    );
  }

  /// `Attributes`
  String get attributes {
    return Intl.message(
      'Attributes',
      name: 'attributes',
      desc: '',
      args: [],
    );
  }

  /// `followers`
  String get followers {
    return Intl.message(
      'followers',
      name: 'followers',
      desc: '',
      args: [],
    );
  }

  /// `Unfollow`
  String get unfollow {
    return Intl.message(
      'Unfollow',
      name: 'unfollow',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get field_required {
    return Intl.message(
      'This field is required',
      name: 'field_required',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is not valid`
  String get invalid_phone {
    return Intl.message(
      'Phone number is not valid',
      name: 'invalid_phone',
      desc: '',
      args: [],
    );
  }

  /// `Email address is not valid`
  String get invalid_email {
    return Intl.message(
      'Email address is not valid',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Please Login to continue`
  String get login_to_continue {
    return Intl.message(
      'Please Login to continue',
      name: 'login_to_continue',
      desc: '',
      args: [],
    );
  }

  /// `Not Authorized`
  String get not_authorized {
    return Intl.message(
      'Not Authorized',
      name: 'not_authorized',
      desc: '',
      args: [],
    );
  }

  /// `Check your Internet connection`
  String get check_internet {
    return Intl.message(
      'Check your Internet connection',
      name: 'check_internet',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back to online`
  String get back_online {
    return Intl.message(
      'Welcome back to online',
      name: 'back_online',
      desc: '',
      args: [],
    );
  }

  /// `We are sorry for the inconvenience. We will be back shortly`
  String get inconvenience {
    return Intl.message(
      'We are sorry for the inconvenience. We will be back shortly',
      name: 'inconvenience',
      desc: '',
      args: [],
    );
  }

  /// `Under Maintenance`
  String get maintenance {
    return Intl.message(
      'Under Maintenance',
      name: 'maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Your software is not installed yet`
  String get not_installed {
    return Intl.message(
      'Your software is not installed yet',
      name: 'not_installed',
      desc: '',
      args: [],
    );
  }

  /// `Please contact your provider`
  String get contact_provider {
    return Intl.message(
      'Please contact your provider',
      name: 'contact_provider',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous {
    return Intl.message(
      'Previous',
      name: 'previous',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Good Morning`
  String get morning {
    return Intl.message(
      'Good Morning',
      name: 'morning',
      desc: '',
      args: [],
    );
  }

  /// `Good Afternoon`
  String get noon {
    return Intl.message(
      'Good Afternoon',
      name: 'noon',
      desc: '',
      args: [],
    );
  }

  /// `Good Evening`
  String get evening {
    return Intl.message(
      'Good Evening',
      name: 'evening',
      desc: '',
      args: [],
    );
  }

  /// `Good Night`
  String get night {
    return Intl.message(
      'Good Night',
      name: 'night',
      desc: '',
      args: [],
    );
  }

  /// `Hello Guest`
  String get hello_guest {
    return Intl.message(
      'Hello Guest',
      name: 'hello_guest',
      desc: '',
      args: [],
    );
  }

  /// `Checkout Summary`
  String get summary {
    return Intl.message(
      'Checkout Summary',
      name: 'summary',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Your coupon`
  String get your_coupon {
    return Intl.message(
      'Your coupon',
      name: 'your_coupon',
      desc: '',
      args: [],
    );
  }

  /// `Please select a billing address`
  String get select_billing {
    return Intl.message(
      'Please select a billing address',
      name: 'select_billing',
      desc: '',
      args: [],
    );
  }

  /// `Also register for an account with the provided email address`
  String get register_with_email {
    return Intl.message(
      'Also register for an account with the provided email address',
      name: 'register_with_email',
      desc: '',
      args: [],
    );
  }

  /// `Submitting an order without creating an account will not allow you to track your order if you lose your order ID`
  String get submit_without_account_warn {
    return Intl.message(
      'Submitting an order without creating an account will not allow you to track your order if you lose your order ID',
      name: 'submit_without_account_warn',
      desc: '',
      args: [],
    );
  }

  /// `It seems you are not Logged in.\nCopy your order ID to track your order later.`
  String get not_logged_in_order_warn {
    return Intl.message(
      'It seems you are not Logged in.\nCopy your order ID to track your order later.',
      name: 'not_logged_in_order_warn',
      desc: '',
      args: [],
    );
  }

  /// `Choose Address`
  String get choose_address {
    return Intl.message(
      'Choose Address',
      name: 'choose_address',
      desc: '',
      args: [],
    );
  }

  /// `Update Password`
  String get update_password {
    return Intl.message(
      'Update Password',
      name: 'update_password',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Basic Information`
  String get basic_info {
    return Intl.message(
      'Basic Information',
      name: 'basic_info',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get first_name {
    return Intl.message(
      'First name',
      name: 'first_name',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get last_name {
    return Intl.message(
      'Last name',
      name: 'last_name',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get add_address {
    return Intl.message(
      'Add New Address',
      name: 'add_address',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Time`
  String get estimate_time {
    return Intl.message(
      'Estimated Time',
      name: 'estimate_time',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Updated`
  String get updated {
    return Intl.message(
      'Updated',
      name: 'updated',
      desc: '',
      args: [],
    );
  }

  /// `Deleted`
  String get deleted {
    return Intl.message(
      'Deleted',
      name: 'deleted',
      desc: '',
      args: [],
    );
  }

  /// `Create billing address`
  String get create_billing {
    return Intl.message(
      'Create billing address',
      name: 'create_billing',
      desc: '',
      args: [],
    );
  }

  /// `Address name`
  String get address_name {
    return Intl.message(
      'Address name',
      name: 'address_name',
      desc: '',
      args: [],
    );
  }

  /// `The coupon will be applied at checkout`
  String get apply_at_checkout {
    return Intl.message(
      'The coupon will be applied at checkout',
      name: 'apply_at_checkout',
      desc: '',
      args: [],
    );
  }

  /// `Enter your tracking Id`
  String get enter_tracking_id {
    return Intl.message(
      'Enter your tracking Id',
      name: 'enter_tracking_id',
      desc: '',
      args: [],
    );
  }

  /// `Total Orders`
  String get total_orders {
    return Intl.message(
      'Total Orders',
      name: 'total_orders',
      desc: '',
      args: [],
    );
  }

  /// `Exit payment page`
  String get exit_payment {
    return Intl.message(
      'Exit payment page',
      name: 'exit_payment',
      desc: '',
      args: [],
    );
  }

  /// `We appreciate you taking the time to give a rating`
  String get appreciate_rating {
    return Intl.message(
      'We appreciate you taking the time to give a rating',
      name: 'appreciate_rating',
      desc: '',
      args: [],
    );
  }

  /// `No, Thanks!`
  String get no_thanks {
    return Intl.message(
      'No, Thanks!',
      name: 'no_thanks',
      desc: '',
      args: [],
    );
  }

  /// `If you logged in using O-Auth, leave this field empty.`
  String get can_be_empty {
    return Intl.message(
      'If you logged in using O-Auth, leave this field empty.',
      name: 'can_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `current password`
  String get current_pass {
    return Intl.message(
      'current password',
      name: 'current_pass',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_pass {
    return Intl.message(
      'New password',
      name: 'new_pass',
      desc: '',
      args: [],
    );
  }

  /// `Password did not match`
  String get pass_not_match {
    return Intl.message(
      'Password did not match',
      name: 'pass_not_match',
      desc: '',
      args: [],
    );
  }

  /// `hey...`
  String get hey {
    return Intl.message(
      'hey...',
      name: 'hey',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to exit?`
  String get sure_to_exit {
    return Intl.message(
      'Are you sure you want to exit?',
      name: 'sure_to_exit',
      desc: '',
      args: [],
    );
  }

  /// `exit`
  String get exit {
    return Intl.message(
      'exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `retry`
  String get retry {
    return Intl.message(
      'retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Full Details`
  String get full_details {
    return Intl.message(
      'Full Details',
      name: 'full_details',
      desc: '',
      args: [],
    );
  }

  /// `No attribute found`
  String get no_attribute {
    return Intl.message(
      'No attribute found',
      name: 'no_attribute',
      desc: '',
      args: [],
    );
  }

  /// `I accept`
  String get i_accept {
    return Intl.message(
      'I accept',
      name: 'i_accept',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get tnc {
    return Intl.message(
      'Terms and Conditions',
      name: 'tnc',
      desc: '',
      args: [],
    );
  }

  /// `One time password (OTP)`
  String get otp {
    return Intl.message(
      'One time password (OTP)',
      name: 'otp',
      desc: '',
      args: [],
    );
  }

  /// `Verify OTP`
  String get verify_otp {
    return Intl.message(
      'Verify OTP',
      name: 'verify_otp',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgetPass {
    return Intl.message(
      'Forgot Password?',
      name: 'forgetPass',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPass {
    return Intl.message(
      'Reset password',
      name: 'resetPass',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get sendOTP {
    return Intl.message(
      'Send OTP',
      name: 'sendOTP',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP to this Email`
  String get sendToEmailText {
    return Intl.message(
      'Send OTP to this Email',
      name: 'sendToEmailText',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel the process and start over?`
  String get confirmCancel {
    return Intl.message(
      'Are you sure you want to cancel the process and start over?',
      name: 'confirmCancel',
      desc: '',
      args: [],
    );
  }

  /// `Your Addresses`
  String get userAddress {
    return Intl.message(
      'Your Addresses',
      name: 'userAddress',
      desc: '',
      args: [],
    );
  }

  /// `Receiver`
  String get receiver {
    return Intl.message(
      'Receiver',
      name: 'receiver',
      desc: '',
      args: [],
    );
  }

  /// `Offline Payment`
  String get offlinePayment {
    return Intl.message(
      'Offline Payment',
      name: 'offlinePayment',
      desc: '',
      args: [],
    );
  }

  /// `Whatsapp Order`
  String get waOrder {
    return Intl.message(
      'Whatsapp Order',
      name: 'waOrder',
      desc: '',
      args: [],
    );
  }

  /// `Please wait while we process your payment`
  String get payment_wait_massage {
    return Intl.message(
      'Please wait while we process your payment',
      name: 'payment_wait_massage',
      desc: '',
      args: [],
    );
  }

  /// `Payment Processing`
  String get payment_wait {
    return Intl.message(
      'Payment Processing',
      name: 'payment_wait',
      desc: '',
      args: [],
    );
  }

  /// `Street name`
  String get streetName {
    return Intl.message(
      'Street name',
      name: 'streetName',
      desc: '',
      args: [],
    );
  }

  /// `Please select address on map`
  String get msgSelectOnMap {
    return Intl.message(
      'Please select address on map',
      name: 'msgSelectOnMap',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Select Location`
  String get selectLocation {
    return Intl.message(
      'Select Location',
      name: 'selectLocation',
      desc: '',
      args: [],
    );
  }

  /// `Google`
  String get google {
    return Intl.message(
      'Google',
      name: 'google',
      desc: '',
      args: [],
    );
  }

  /// `Facebook`
  String get facebook {
    return Intl.message(
      'Facebook',
      name: 'facebook',
      desc: '',
      args: [],
    );
  }

  /// `Accept and continue`
  String get acceptAndContinue {
    return Intl.message(
      'Accept and continue',
      name: 'acceptAndContinue',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `The coupon will be applied at checkout`
  String get couponWillApply {
    return Intl.message(
      'The coupon will be applied at checkout',
      name: 'couponWillApply',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get deposit {
    return Intl.message(
      'Deposit',
      name: 'deposit',
      desc: '',
      args: [],
    );
  }

  /// `Seller Chat`
  String get sellerChat {
    return Intl.message(
      'Seller Chat',
      name: 'sellerChat',
      desc: '',
      args: [],
    );
  }

  /// `Tax information`
  String get taxInformation {
    return Intl.message(
      'Tax information',
      name: 'taxInformation',
      desc: '',
      args: [],
    );
  }

  /// `Reward Redeem`
  String get rewardRedeem {
    return Intl.message(
      'Reward Redeem',
      name: 'rewardRedeem',
      desc: '',
      args: [],
    );
  }

  /// `Redeem Point`
  String get redeemPoint {
    return Intl.message(
      'Redeem Point',
      name: 'redeemPoint',
      desc: '',
      args: [],
    );
  }

  /// `Reward Point`
  String get rewardPoint {
    return Intl.message(
      'Reward Point',
      name: 'rewardPoint',
      desc: '',
      args: [],
    );
  }

  /// `You will get`
  String get youWillGet {
    return Intl.message(
      'You will get',
      name: 'youWillGet',
      desc: '',
      args: [],
    );
  }

  /// `from redeeming this reward.`
  String get fromRedeeming {
    return Intl.message(
      'from redeeming this reward.',
      name: 'fromRedeeming',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Claim`
  String get claim {
    return Intl.message(
      'Claim',
      name: 'claim',
      desc: '',
      args: [],
    );
  }

  /// `Pick Image`
  String get pickImage {
    return Intl.message(
      'Pick Image',
      name: 'pickImage',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get withdraw {
    return Intl.message(
      'Withdraw',
      name: 'withdraw',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw now`
  String get withdrawNow {
    return Intl.message(
      'Withdraw now',
      name: 'withdrawNow',
      desc: '',
      args: [],
    );
  }

  /// `Available Balance`
  String get availableBalance {
    return Intl.message(
      'Available Balance',
      name: 'availableBalance',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw methods`
  String get withdrawMethods {
    return Intl.message(
      'Withdraw methods',
      name: 'withdrawMethods',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw Limit`
  String get withdrawLimit {
    return Intl.message(
      'Withdraw Limit',
      name: 'withdrawLimit',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message(
      'Duration',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw amount in {currency}`
  String withdrawAmountIn(Object currency) {
    return Intl.message(
      'Withdraw amount in $currency',
      name: 'withdrawAmountIn',
      desc: '',
      args: [currency],
    );
  }

  /// `Search by trx number`
  String get searchByTrxNumber {
    return Intl.message(
      'Search by trx number',
      name: 'searchByTrxNumber',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw Request`
  String get withdrawRequest {
    return Intl.message(
      'Withdraw Request',
      name: 'withdrawRequest',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong while requesting withdraw`
  String get msgSomethingWrongWithdraw {
    return Intl.message(
      'Something went wrong while requesting withdraw',
      name: 'msgSomethingWrongWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `WITHDRAW PREVIEW`
  String get withdrawPreview {
    return Intl.message(
      'WITHDRAW PREVIEW',
      name: 'withdrawPreview',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw Method`
  String get withdrawMethod {
    return Intl.message(
      'Withdraw Method',
      name: 'withdrawMethod',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw Amount`
  String get withdrawAmount {
    return Intl.message(
      'Withdraw Amount',
      name: 'withdrawAmount',
      desc: '',
      args: [],
    );
  }

  /// `Conversion rate`
  String get conversionRate {
    return Intl.message(
      'Conversion rate',
      name: 'conversionRate',
      desc: '',
      args: [],
    );
  }

  /// `Final Amount`
  String get finalAmount {
    return Intl.message(
      'Final Amount',
      name: 'finalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Error Details`
  String get errorDetails {
    return Intl.message(
      'Error Details',
      name: 'errorDetails',
      desc: '',
      args: [],
    );
  }

  /// `Reload`
  String get reload {
    return Intl.message(
      'Reload',
      name: 'reload',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Select Country`
  String get selectCountry {
    return Intl.message(
      'Select Country',
      name: 'selectCountry',
      desc: '',
      args: [],
    );
  }

  /// `Select State`
  String get selectState {
    return Intl.message(
      'Select State',
      name: 'selectState',
      desc: '',
      args: [],
    );
  }

  /// `Select City`
  String get selectCity {
    return Intl.message(
      'Select City',
      name: 'selectCity',
      desc: '',
      args: [],
    );
  }

  /// `e.g home, office`
  String get egHomeOffice {
    return Intl.message(
      'e.g home, office',
      name: 'egHomeOffice',
      desc: '',
      args: [],
    );
  }

  /// `Please enable location service`
  String get enableLocSer {
    return Intl.message(
      'Please enable location service',
      name: 'enableLocSer',
      desc: '',
      args: [],
    );
  }

  /// `Please grant location permission`
  String get grantLocPermission {
    return Intl.message(
      'Please grant location permission',
      name: 'grantLocPermission',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Reward`
  String get reward {
    return Intl.message(
      'Reward',
      name: 'reward',
      desc: '',
      args: [],
    );
  }

  /// `Chat With Seller`
  String get chatWithSeller {
    return Intl.message(
      'Chat With Seller',
      name: 'chatWithSeller',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `Enter Email address`
  String get enterEmail {
    return Intl.message(
      'Enter Email address',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your otp`
  String get enterOtp {
    return Intl.message(
      'Enter your otp',
      name: 'enterOtp',
      desc: '',
      args: [],
    );
  }

  /// `Enter {fieldText}`
  String enterFieldName(Object fieldText) {
    return Intl.message(
      'Enter $fieldText',
      name: 'enterFieldName',
      desc: '',
      args: [fieldText],
    );
  }

  /// `Spend`
  String get spend {
    return Intl.message(
      'Spend',
      name: 'spend',
      desc: '',
      args: [],
    );
  }

  /// `more to place order`
  String get moreToPlaceOrder {
    return Intl.message(
      'more to place order',
      name: 'moreToPlaceOrder',
      desc: '',
      args: [],
    );
  }

  /// `File`
  String get file {
    return Intl.message(
      'File',
      name: 'file',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get newChat {
    return Intl.message(
      'New',
      name: 'newChat',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get state {
    return Intl.message(
      'State',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Point`
  String get point {
    return Intl.message(
      'Point',
      name: 'point',
      desc: '',
      args: [],
    );
  }

  /// `Traditional`
  String get traditional {
    return Intl.message(
      'Traditional',
      name: 'traditional',
      desc: '',
      args: [],
    );
  }

  /// `Payment options`
  String get paymentOptions {
    return Intl.message(
      'Payment options',
      name: 'paymentOptions',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get free {
    return Intl.message(
      'Free',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `Deposit Method`
  String get depositMethod {
    return Intl.message(
      'Deposit Method',
      name: 'depositMethod',
      desc: '',
      args: [],
    );
  }

  /// `Deposit history`
  String get depositHistory {
    return Intl.message(
      'Deposit history',
      name: 'depositHistory',
      desc: '',
      args: [],
    );
  }

  /// `No Flash Deal Found`
  String get noFlashDealFound {
    return Intl.message(
      'No Flash Deal Found',
      name: 'noFlashDealFound',
      desc: '',
      args: [],
    );
  }

  /// `Config Load Failed`
  String get configLoadFailed {
    return Intl.message(
      'Config Load Failed',
      name: 'configLoadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Original`
  String get original {
    return Intl.message(
      'Original',
      name: 'original',
      desc: '',
      args: [],
    );
  }

  /// `Tax`
  String get tax {
    return Intl.message(
      'Tax',
      name: 'tax',
      desc: '',
      args: [],
    );
  }

  /// `Custom Information`
  String get customInformation {
    return Intl.message(
      'Custom Information',
      name: 'customInformation',
      desc: '',
      args: [],
    );
  }

  /// `Payment information`
  String get paymentInformation {
    return Intl.message(
      'Payment information',
      name: 'paymentInformation',
      desc: '',
      args: [],
    );
  }

  /// `Payment VIA Wallet`
  String get paymentViaWallet {
    return Intl.message(
      'Payment VIA Wallet',
      name: 'paymentViaWallet',
      desc: '',
      args: [],
    );
  }

  /// `Original Amount`
  String get originalAmount {
    return Intl.message(
      'Original Amount',
      name: 'originalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Tax amount`
  String get taxAmount {
    return Intl.message(
      'Tax amount',
      name: 'taxAmount',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Cost`
  String get shippingCost {
    return Intl.message(
      'Shipping Cost',
      name: 'shippingCost',
      desc: '',
      args: [],
    );
  }

  /// `Package was {status} on`
  String packageWasStatusOn(Object status) {
    return Intl.message(
      'Package was $status on',
      name: 'packageWasStatusOn',
      desc: '',
      args: [status],
    );
  }

  /// `Deposit Success`
  String get depositSuccess {
    return Intl.message(
      'Deposit Success',
      name: 'depositSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Deposit Processing`
  String get depositProcessing {
    return Intl.message(
      'Deposit Processing',
      name: 'depositProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Payment Processing`
  String get paymentProcessing {
    return Intl.message(
      'Payment Processing',
      name: 'paymentProcessing',
      desc: '',
      args: [],
    );
  }

  /// `Deposit Failed`
  String get depositFailed {
    return Intl.message(
      'Deposit Failed',
      name: 'depositFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please wait while we process your payment`
  String get paymentProcessMsg {
    return Intl.message(
      'Please wait while we process your payment',
      name: 'paymentProcessMsg',
      desc: '',
      args: [],
    );
  }

  /// `Product Options`
  String get productOptions {
    return Intl.message(
      'Product Options',
      name: 'productOptions',
      desc: '',
      args: [],
    );
  }

  /// `Standard Delivery : {duration} Working Days`
  String deliveryDuration(Object duration) {
    return Intl.message(
      'Standard Delivery : $duration Working Days',
      name: 'deliveryDuration',
      desc: '',
      args: [duration],
    );
  }

  /// `Total Reward Points`
  String get totalRewardPoints {
    return Intl.message(
      'Total Reward Points',
      name: 'totalRewardPoints',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `Redeemed`
  String get redeemed {
    return Intl.message(
      'Redeemed',
      name: 'redeemed',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get expired {
    return Intl.message(
      'Expired',
      name: 'expired',
      desc: '',
      args: [],
    );
  }

  /// `points`
  String get points {
    return Intl.message(
      'points',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `will expire in`
  String get willExpireIn {
    return Intl.message(
      'will expire in',
      name: 'willExpireIn',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get days {
    return Intl.message(
      'days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `Reward Logs`
  String get rewardLogs {
    return Intl.message(
      'Reward Logs',
      name: 'rewardLogs',
      desc: '',
      args: [],
    );
  }

  /// `Expire at`
  String get expireAt {
    return Intl.message(
      'Expire at',
      name: 'expireAt',
      desc: '',
      args: [],
    );
  }

  /// `Created at`
  String get createdAt {
    return Intl.message(
      'Created at',
      name: 'createdAt',
      desc: '',
      args: [],
    );
  }

  /// `Redeemed at`
  String get redeemedAt {
    return Intl.message(
      'Redeemed at',
      name: 'redeemedAt',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message(
      'Product',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message(
      'Order',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Total points`
  String get totalPoints {
    return Intl.message(
      'Total points',
      name: 'totalPoints',
      desc: '',
      args: [],
    );
  }

  /// `Your package has been {status}.`
  String packageStatusName(Object status) {
    return Intl.message(
      'Your package has been $status.',
      name: 'packageStatusName',
      desc: '',
      args: [status],
    );
  }

  /// `User name`
  String get userName {
    return Intl.message(
      'User name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Post Balance`
  String get postBalance {
    return Intl.message(
      'Post Balance',
      name: 'postBalance',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw History`
  String get withdrawHistory {
    return Intl.message(
      'Withdraw History',
      name: 'withdrawHistory',
      desc: '',
      args: [],
    );
  }

  /// `Receivable`
  String get receivable {
    return Intl.message(
      'Receivable',
      name: 'receivable',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw Information`
  String get withdrawInformation {
    return Intl.message(
      'Withdraw Information',
      name: 'withdrawInformation',
      desc: '',
      args: [],
    );
  }

  /// `To get withdrawal information, first select a withdrawal method from the list below.`
  String get msgSelectWithdrawalMethod {
    return Intl.message(
      'To get withdrawal information, first select a withdrawal method from the list below.',
      name: 'msgSelectWithdrawalMethod',
      desc: '',
      args: [],
    );
  }

  /// `Chat with deliveryman`
  String get chatWithDeliveryman {
    return Intl.message(
      'Chat with deliveryman',
      name: 'chatWithDeliveryman',
      desc: '',
      args: [],
    );
  }

  /// `We appreciate you taking the time to give a rating`
  String get msgAppreciateRating {
    return Intl.message(
      'We appreciate you taking the time to give a rating',
      name: 'msgAppreciateRating',
      desc: '',
      args: [],
    );
  }

  /// `Write A Review`
  String get writeAReview {
    return Intl.message(
      'Write A Review',
      name: 'writeAReview',
      desc: '',
      args: [],
    );
  }

  /// `No thanks`
  String get noThanks {
    return Intl.message(
      'No thanks',
      name: 'noThanks',
      desc: '',
      args: [],
    );
  }

  /// `Chat With Delivery Partner`
  String get chatWithDeliveryPartner {
    return Intl.message(
      'Chat With Delivery Partner',
      name: 'chatWithDeliveryPartner',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<TR> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'az'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'ur'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<TR> load(Locale locale) => TR.load(locale);
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
