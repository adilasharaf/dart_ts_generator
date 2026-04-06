enum DLStatus {
  none,
  dlScheduled,
  dlPassed,
  dlPartialyPassed,
  dlFailed,
  dlNotAttended,
}

extension DLStatusExtension on DLStatus {
  String asString() => switch (this) {
    .none => 'None',
    .dlScheduled => 'DL Scheduled',
    .dlPassed => 'DL Passed',
    .dlPartialyPassed => 'DL Partially Passed',
    .dlFailed => 'DL Failed',
    .dlNotAttended => 'DL Not Attended',
  };
}

extension DLStatusStringExtension on String {
  DLStatus toDLStatus() => switch (this) {
    'None' => .none,
    'DL Scheduled' => .dlScheduled,
    'DL Passed' => .dlPassed,
    'DL Failed' => .dlFailed,
    'DL Not Attended' => .dlNotAttended,
    'DL Partially Passed' => .dlPartialyPassed,
    String() => throw Exception('Invalid DL Status'),
  };
}
