enum CallStatus {pending, didntConnect, didntPickup, interested, notInterested}

extension CallStatusExtension on CallStatus {
  String asString() {
    switch (this) {
      case CallStatus.pending:
        return 'Pending';
      case CallStatus.didntConnect:
        return 'Didnt Connect';
      case CallStatus.didntPickup:
        return 'Didnt Pickup';
      case CallStatus.interested:
        return 'Interested';
      case CallStatus.notInterested:
        return 'Not interested';
    }
  }
}

extension CallStatusStringExtension on String {
  CallStatus toCallStatus() {
    switch (this) {
      case 'Pending':
        return CallStatus.pending;
      case 'Didnt Connect':
        return CallStatus.didntConnect;
      case 'Didnt Pickup':
        return CallStatus.didntPickup;
      case 'Interested':
        return CallStatus.interested;
      case 'Not interested':
        return CallStatus.notInterested;
      default:
        throw Exception("Invalid call status");
    }
  }
}