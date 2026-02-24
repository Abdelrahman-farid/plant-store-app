class UserProfileState {
  final String name;
  final String? photoUrl;

  UserProfileState({required this.name, this.photoUrl});

  UserProfileState copyWith({String? name, String? photoUrl}) {
    return UserProfileState(
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
