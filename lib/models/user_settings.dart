class UserSettings {
  final String name;
  final String address;
  final String email;
  final bool receiveNewsletter;

  const UserSettings({
    this.name = '',
    this.address = '',
    this.email = '',
    this.receiveNewsletter = false,
  });
}
