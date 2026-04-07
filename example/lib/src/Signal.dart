class Signal {
  int? id;
  String? description;
  String? image;
  int? classification;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Signal && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'image': image,
      'classification': classification,
    };
  }

  static Signal fromJson(Map<String, dynamic> model) {
    Signal signal = Signal();
    signal.id = model['id'];
    signal.description = model['description'];
    signal.image = model['image'];
    signal.classification = model['classification'];
    return signal;
  }
}
