enum CourseStatus { none, enrolled, completed, cancelled }

extension CourseStatusExtension on CourseStatus {
  String asString() {
    switch (this) {
      case CourseStatus.none:
        return 'None';
      case CourseStatus.enrolled:
        return 'Enrolled';
      case CourseStatus.completed:
        return 'Completed';
      case CourseStatus.cancelled:
        return 'Cancelled';
    }
  }
}

extension CourseStatusStringExtension on String {
  CourseStatus toCourseStatus() {
    switch (this) {
      case 'None':
        return CourseStatus.none;
      case 'Enrolled':
        return CourseStatus.enrolled;
      case 'Completed':
        return CourseStatus.completed;
      case 'Cancelled':
        return CourseStatus.cancelled;
      default:
        throw Exception("Invalid Course status");
    }
  }
}
