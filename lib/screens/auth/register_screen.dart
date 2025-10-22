import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/auth_controller.dart';
import 'package:smart_home_control/core/app_localizations.dart';
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
  bool _passwordVisible = false;
  bool _confirmVisible = false;
  double _passwordStrength = 0;
  String _strengthLabel = '';
  bool _termsAccepted = false;

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
                  obscureText: !_passwordVisible,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: loc.t('password'),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                      icon: Icon(_passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    ),
                  ),
                  onChanged: (value) => _updateStrength(loc, value),
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
                const SizedBox(height: 8),
                if (_strengthLabel.isNotEmpty) ...[
                  LinearProgressIndicator(
                    value: _passwordStrength,
                    minHeight: 6,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _strengthLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                ] else
                  const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmController,
                  obscureText: !_confirmVisible,
                  decoration: InputDecoration(
                    labelText: loc.t('confirm_password'),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _confirmVisible = !_confirmVisible),
                      icon: Icon(_confirmVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    ),
                  ),
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
                const SizedBox(height: 12),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _termsAccepted,
                  onChanged: (value) => setState(() => _termsAccepted = value ?? false),
                  title: Text(loc.t('terms_consent')),
                  controlAffinity: ListTileControlAffinity.leading,
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
    if (!_termsAccepted) {
      if (mounted) {
        final loc = auth.localization;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.t('terms_required'))),
        );
      }
      return;
    }
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
      setState(() {
        _termsAccepted = false;
        _passwordStrength = 0;
        _strengthLabel = '';
        _passwordVisible = false;
        _confirmVisible = false;
      });
    }
  }

  void _updateStrength(AppLocalizations loc, String value) {
    double score = 0;
    if (value.length >= 6) score += 0.25;
    if (value.length >= 10) score += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(value)) score += 0.2;
    if (RegExp(r'[0-9]').hasMatch(value)) score += 0.15;
    if (RegExp(r'[!@#\\$%^&*(),.?":{}|<>]').hasMatch(value)) score += 0.15;
    score = score.clamp(0, 1);
    String label;
    if (score >= 0.8) {
      label = loc.t('password_strong');
    } else if (score >= 0.5) {
      label = loc.t('password_good');
    } else if (score >= 0.3) {
      label = loc.t('password_fair');
    } else if (value.isNotEmpty) {
      label = loc.t('password_weak');
    } else {
      label = '';
    }
    setState(() {
      _passwordStrength = score;
      _strengthLabel = label;
    });
  }
}
