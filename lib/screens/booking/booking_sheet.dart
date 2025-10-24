import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/localization/app_localizations.dart';

class BookingSheet extends StatefulWidget {
  const BookingSheet({super.key, required this.propertyId});

  final String propertyId;

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _date;
  TimeOfDay? _time;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('book_visit')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.calendar, size: 18),
                title: Text(_date == null
                    ? strings.t('date')
                    : '${_date!.year}/${_date!.month}/${_date!.day}'),
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: now,
                    lastDate: now.add(const Duration(days: 365)),
                    initialDate: now,
                  );
                  if (picked != null) {
                    setState(() => _date = picked);
                  }
                },
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.clock, size: 18),
                title: Text(_time == null
                    ? strings.t('time')
                    : _time!.format(context)),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() => _time = picked);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: strings.t('name_hint')),
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : strings.t('name_hint'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: strings.t('phone_hint')),
                validator: (value) =>
                    value != null && value.length >= 8 ? null : strings.t('phone_hint'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(labelText: strings.t('note')),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (_date == null || _time == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.t('date'))),
                    );
                    return;
                  }
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(strings.t('booked_locally'))),
                  );
                  Navigator.of(context).pop();
                },
                child: Text(strings.t('book')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
