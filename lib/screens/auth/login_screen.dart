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
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = ControllerScope.of(context).auth;
      final remembered = auth.lastEmail;
      if (auth.rememberMe && remembered != null && _emailController.text.isEmpty) {
        _emailController.text = remembered;
      }
    });
  }

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
        final infoKey = auth.infoKey;
        final infoText = infoKey == null ? null : loc.t(infoKey);
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
                  obscureText: !_passwordVisible,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    labelText: loc.t('password'),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                      icon: Icon(_passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.t('password_required');
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: auth.isBusy ? null : () => _showForgotPassword(context, auth),
                    child: Text(loc.t('forgot_password')),
                  ),
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    errorText,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                if (infoText != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    infoText,
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
                const SizedBox(height: 16),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: auth.rememberMe,
                  onChanged: auth.isBusy ? null : (value) => auth.setRememberMe(value ?? false),
                  title: Text(loc.t('remember_me')),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
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

  Future<void> _showForgotPassword(BuildContext context, AuthController auth) async {
    final loc = auth.localization;
    final controller = TextEditingController(text: _emailController.text.trim());
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.t('forgot_password'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                loc.t('forgot_password_hint'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: loc.t('email'),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(loc.t('cancel')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(loc.t('send_reset')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true) {
      final email = controller.text.trim();
      final success = await auth.requestPasswordReset(email);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.t('reset_email_sent_snack'))),
        );
      }
    }
    controller.dispose();
  }
}
