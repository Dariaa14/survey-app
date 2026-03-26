/// User role values based on backend `type` enum.
enum UserType {
	/// Admin user.
	admin,

	/// Public user.
	public,
}

/// Domain contract for a user entity.
abstract class UserEntity {
	/// User id (UUID).
	String get id;

	/// User email address.
	String get email;

	/// Password hash from backend.
	String get passwordHash;

	/// User type.
	UserType get type;

	/// Creation timestamp.
	DateTime get createdAt;
}
