import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/auth_controller.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/screens/auth/widgets/auth_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final auth = scope.auth;
    final loc = auth.localization;
    return AnimatedBuilder(
      animation: auth,
      builder: (context, _) {
        final errorKey = auth.errorKey;
        final errorText = errorKey == null ? null : loc.t(errorKey);
        return AuthScaffold(
          title: loc.t('sign_up_title'),
          subtitle: loc.t('sign_up_action'),
          form: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: loc.t('full_name')),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return loc.t('name_required');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: loc.t('email')),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return loc.t('email_required');
                    }
                    final emailRegex = RegExp(r'.+@.+\..+');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return loc.t('email_invalid');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: loc.t('password')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.t('password_required');
                    }
                    if (value.length < 6) {
                      return loc.t('auth_error_weak_password');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: loc.t('confirm_password')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.t('password_required');
                    }
                    if (value != _passwordController.text) {
                      return loc.t('auth_error_passwords');
                    }
                    return null;
                  },
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    errorText,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: auth.isBusy ? null : () => _submit(auth),
                    child: auth.isBusy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(loc.t('sign_up_action')),
                  ),
                ),
              ],
            ),
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(loc.t('have_account')),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => auth.setScreen(AuthScreen.signIn),
                child: Text(loc.t('login_now')),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit(AuthController auth) async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    final success = await auth.register(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirm,
    );
    if (success) {
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmController.clear();
    }
  }
}
