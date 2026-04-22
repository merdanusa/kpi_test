class Task {
  final int indicatorToMoId;
  final int parentId;
  final String name;
  final int order;

  const Task({
    required this.indicatorToMoId,
    required this.parentId,
    required this.name,
    required this.order,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      indicatorToMoId: json['indicator_to_mo_id'] ?? 0,
      parentId: json['parent_id'] ?? 0,
      name: json['name'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'indicator_to_mo_id': indicatorToMoId,
      'parent_id': parentId,
      'name': name,
      'order': order,
    };
  }

  Task copyWith({
    int? indicatorToMoId,
    int? parentId,
    String? name,
    int? order,
  }) {
    return Task(
      indicatorToMoId: indicatorToMoId ?? this.indicatorToMoId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      order: order ?? this.order,
    );
  }
}
