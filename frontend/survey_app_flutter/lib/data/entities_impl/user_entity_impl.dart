import 'package:survey_app_flutter/domain/entities/user_entity.dart';

/// Concrete implementation of [UserEntity] used in data layer.
class UserEntityImpl implements UserEntity {
	/// Creates a [UserEntityImpl].
	const UserEntityImpl({
		required this.id,
		required this.email,
		required this.passwordHash,
		required this.type,
		required this.createdAt,
	});

	/// Builds an instance from backend JSON payload.
	factory UserEntityImpl.fromJson(Map<String, dynamic> json) {
		return UserEntityImpl(
			id: json['id'] as String,
			email: json['email'] as String,
			passwordHash: json['password_hash'] as String,
			type: _mapUserType(json['type'] as String?),
			createdAt: DateTime.parse(json['created_at'] as String),
		);
	}

	@override
	final String id;

	@override
	final String email;

	@override
	final String passwordHash;

	@override
	final UserType type;

	@override
	final DateTime createdAt;

	/// Serializes this entity to backend-compatible JSON.
	Map<String, dynamic> toJson() {
		return {
			'id': id,
			'email': email,
			'password_hash': passwordHash,
			'type': _userTypeToJson(type),
			'created_at': createdAt.toIso8601String(),
		};
	}

	static UserType _mapUserType(String? value) {
		switch (value) {
			case 'admin':
				return UserType.admin;
			case 'public':
			default:
				return UserType.public;
		}
	}

	static String _userTypeToJson(UserType value) {
		switch (value) {
			case UserType.admin:
				return 'admin';
			case UserType.public:
				return 'public';
		}
	}
}
