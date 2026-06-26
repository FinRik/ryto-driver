class Bank {
  final String? name;
  final String? slug;
  final String? code;
  final String? longcode;
  final String? gateway;
  final bool? payWithBank;
  final bool? active;
  final bool? isDeleted;
  final String? country;
  final String? currency;
  final String? type;
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Bank({
    this.name,
    this.slug,
    this.code,
    this.longcode,
    this.gateway,
    this.payWithBank,
    this.active,
    this.isDeleted,
    this.country,
    this.currency,
    this.type,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      code: json['code'] as String?,
      longcode: json['longcode'] as String?,
      gateway: json['gateway'] as String?,
      payWithBank: json['pay_with_bank'] as bool?,
      active: json['active'] as bool?,
      isDeleted: json['is_deleted'] as bool?,
      country: json['country'] as String?,
      currency: json['currency'] as String?,
      type: json['type'] as String?,
      id: json['id'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'code': code,
      'longcode': longcode,
      'gateway': gateway,
      'pay_with_bank': payWithBank,
      'active': active,
      'is_deleted': isDeleted,
      'country': country,
      'currency': currency,
      'type': type,
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper getters (recommended for safer usage in UI)
  String get displayName => name ?? 'Unknown Bank';
  String get displayCode => code ?? '';
  bool get isActive => active ?? false;
}