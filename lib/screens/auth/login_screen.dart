import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/auth_controller.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/screens/auth/widgets/auth_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          title: loc.t('sign_in_title'),
          subtitle: loc.t('welcome_back'),
          form: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  autofillHints: const [AutofillHints.username],
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: loc.t('email'),
                  ),
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
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    labelText: loc.t('password'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.t('password_required');
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
                        : Text(loc.t('sign_in_action')),
                  ),
                ),
              ],
            ),
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(loc.t('no_account')),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => auth.setScreen(AuthScreen.signUp),
                child: Text(loc.t('create_now')),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit(AuthController auth) async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    await auth.signIn(email: email, password: password);
  }
}
