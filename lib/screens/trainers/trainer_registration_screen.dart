import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/app_scope.dart';
import '../../data/models/trainer.dart';

class TrainerRegistrationScreen extends StatefulWidget {
  const TrainerRegistrationScreen({super.key});

  @override
  State<TrainerRegistrationScreen> createState() => _TrainerRegistrationScreenState();
}

class _TrainerRegistrationScreenState extends State<TrainerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _certificationsController = TextEditingController();
  final _languagesController = TextEditingController(text: 'العربية, English');
  final _experienceController = TextEditingController(text: '5');
  final _clubsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _specialtyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _certificationsController.dispose();
    _languagesController.dispose();
    _experienceController.dispose();
    _clubsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trainerController = AppScope.of(context).trainerController;
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: trainerController,
      builder: (context, _) {
        return Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surfaceTint.withOpacity(0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 64,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        Text(
                          l10n.translate('trainer_registration_title'),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.translate('trainer_registration_caption'),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 18),
                        _TextField(
                          controller: _nameController,
                          label: l10n.translate('full_name'),
                          validator: (value) => value!.isEmpty ? l10n.translate('required_field') : null,
                        ),
                        _TextField(
                          controller: _specialtyController,
                          label: l10n.translate('specialty'),
                          validator: (value) => value!.isEmpty ? l10n.translate('required_field') : null,
                        ),
                        _TextField(
                          controller: _experienceController,
                          label: l10n.translate('years_experience'),
                          keyboardType: TextInputType.number,
                        ),
                        _TextField(
                          controller: _languagesController,
                          label: l10n.translate('spoken_languages'),
                        ),
                        _TextField(
                          controller: _bioController,
                          label: l10n.translate('bio'),
                          maxLines: 3,
                          validator: (value) => value!.isEmpty ? l10n.translate('required_field') : null,
                        ),
                        _TextField(
                          controller: _certificationsController,
                          label: l10n.translate('certifications'),
                          maxLines: 2,
                        ),
                        _TextField(
                          controller: _clubsController,
                          label: l10n.translate('preferred_clubs'),
                          helper: l10n.translate('clubs_helper'),
                        ),
                        _TextField(
                          controller: _emailController,
                          label: l10n.translate('email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value!.contains('@') ? null : l10n.translate('invalid_email'),
                        ),
                        _TextField(
                          controller: _phoneController,
                          label: l10n.translate('phone'),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: trainerController.isSubmitting ? null : () => _submit(context),
                          icon: const Icon(Icons.rocket_launch),
                          label: trainerController.isSubmitting
                              ? Text(l10n.translate('submitting'))
                              : Text(l10n.translate('submit_application')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ).animate().fadeIn(260.ms).moveY(begin: 20, end: 0);
      },
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context);
    final trainerController = AppScope.of(context).trainerController;

    final languages = _languagesController.text
        .split(',')
        .map((lang) => lang.trim())
        .where((lang) => lang.isNotEmpty)
        .toList();
    final certifications = _certificationsController.text
        .split(',')
        .map((cert) => cert.trim())
        .where((cert) => cert.isNotEmpty)
        .toList();
    final preferredClubs = _clubsController.text
        .split(',')
        .map((club) => club.trim())
        .where((club) => club.isNotEmpty)
        .toList();

    final application = TrainerApplication(
      name: _nameController.text,
      specialty: _specialtyController.text,
      bio: _bioController.text,
      languages: languages,
      experienceYears: int.tryParse(_experienceController.text) ?? 3,
      certifications: certifications,
      preferredClubs: preferredClubs,
      contactEmail: _emailController.text,
      contactPhone: _phoneController.text,
    );

    await trainerController.submitApplication(application);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('application_received'))),
      );
    }
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    this.helper,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String? helper;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          helperText: helper,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}
