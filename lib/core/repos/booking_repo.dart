import '../../app/app_setup_locator.dart';
import '../models/trip/trip_cost_request.dart';
import '../models/bookings/booking_summary.dart';
import '../models/trip/create_trip_request.dart';
import '../models/trip/safety_pin_request.dart';
import '../models/trip/trip.dart';
import '../models/trip/trip_cost_summary.dart';
import '../models/trip/trip_summary.dart';
import '../services/api_service.dart';

abstract class BookingRepo {
  Future<TripCostSummary?> fetchBookingCost(TripCostRequest request);
  Future<bool> createTrip(CreateTripRequest request);
  Future<List<Trip>?> fetchTrips(String status);
  Future<TripSummary?> fetchTripSummary(String id);
  Future<List<BookingSummary>?> fetchTripBookings(
    String id, {
    String? bookingStatus,
  });
  Future<bool> approveTripBooking(int tripId, int bookingId);
  Future<bool> declineTripBooking(String reason, int bookingId);
  Future<bool> completeTrip(String id, int totalAmount);
  Future<bool> cancelTrip(String id);
  Future<bool> verifyPassengerPins(String tripId, SafetyPinRequest request);
}

class BookingRepoImpl implements BookingRepo {
  final ApiService _apiService;

  BookingRepoImpl({ApiService? service})
    : _apiService = service ?? sl<ApiService>();

  @override
  Future<TripCostSummary?> fetchBookingCost(TripCostRequest request) async {
    final res = await _apiService.fetchBookingCost(request);
    return res.data;
  }

  @override
  Future<bool> createTrip(CreateTripRequest request) async {
    final result = await _apiService.createTrip(request);
    return result.code == 201;
  }

  @override
  Future<List<Trip>?> fetchTrips(String status) async {
    final res = await _apiService.fetchTrips(status);
    return res.data?.data;
  }

  @override
  Future<TripSummary?> fetchTripSummary(String id) async {
    final res = await _apiService.fetchTripSummary(id);
    return res.data;
  }

  @override
  Future<List<BookingSummary>?> fetchTripBookings(
    String tripId, {
    String? bookingStatus,
  }) async {
    final res = await _apiService.fetchTripBookings(
      tripId,
      bookingStatus: bookingStatus,
    );
    return res.data;
  }

  //test here
  @override
  Future<bool> completeTrip(String id, int totalAmount) async {
    final result = await _apiService.completeTrip(id, totalAmount);
    return result.data != null;
  }

  @override
  Future<bool> cancelTrip(String id) async {
    final result = await _apiService.cancelTrip(id);
    return result.code == 200;
  }

  @override
  Future<bool> approveTripBooking(int tripId, int bookingId) async {
    final res = await _apiService.approveTripBooking(tripId, bookingId);
    return res.code == 200;
  }

  @override
  Future<bool> declineTripBooking(String reason, int bookingId) async {
    final res = await _apiService.declineTripBooking(reason, bookingId);
    return res.code == 200;
  }

  @override
  Future<bool> verifyPassengerPins(
    String tripId,
    SafetyPinRequest request,
  ) async {
    final res = await _apiService.verifyPassengerPins(tripId, request);
    return res.code == 200;
  }
}
