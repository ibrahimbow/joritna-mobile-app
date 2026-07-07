enum AuthMode {
  login,
  register;

  bool get isLogin => this == AuthMode.login;

  bool get isRegister => this == AuthMode.register;

  AuthMode get toggled {
    return isLogin ? AuthMode.register : AuthMode.login;
  }
}
