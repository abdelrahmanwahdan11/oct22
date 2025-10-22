class AccessRule {
  const AccessRule({
    required this.id,
    required this.title,
    required this.description,
    required this.enabled,
    required this.visibility,
  });

  final String id;
  final String title;
  final String description;
  final bool enabled;
  final String visibility;

  AccessRule copyWith({
    bool? enabled,
  }) {
    return AccessRule(
      id: id,
      title: title,
      description: description,
      enabled: enabled ?? this.enabled,
      visibility: visibility,
    );
  }
}
