import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../controllers/properties_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/animations.dart';

class PropertySubmissionScreen extends StatefulWidget {
  const PropertySubmissionScreen({super.key});

  @override
  State<PropertySubmissionScreen> createState() => _PropertySubmissionScreenState();
}

class _PropertySubmissionScreenState extends State<PropertySubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _currencyController = TextEditingController(text: 'USD');
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _bedsController = TextEditingController(text: '2');
  final _bathsController = TextEditingController(text: '2');
  final _areaController = TextEditingController(text: '120');
  final _latController = TextEditingController(text: '31.95');
  final _lngController = TextEditingController(text: '35.18');
  final List<TextEditingController> _imageControllers =
      List.generate(3, (_) => TextEditingController());

  String _status = 'for_sale';
  String _type = 'apartments';
  final Set<String> _selectedFeatures = {'Smart Home', 'Balcony'};

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _currencyController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _bedsController.dispose();
    _bathsController.dispose();
    _areaController.dispose();
    _latController.dispose();
    _lngController.dispose();
    for (final controller in _imageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final properties = NotifierProvider.of<PropertiesController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.t('submit_property')), 
      ),
      body: Container(
        decoration:
            AppDecorations.gradientBackground(dark: Theme.of(context).brightness == Brightness.dark),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(strings.t('basic_info'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: strings.t('title'),
                    prefixIcon: const FaIcon(FontAwesomeIcons.pen, size: 16),
                  ),
                  validator: (value) => value != null && value.length >= 4
                      ? null
                      : strings.t('title_required'),
                ).fadeMove(),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _status,
                  items: const [
                    DropdownMenuItem(value: 'for_sale', child: Text('For Sale')),
                    DropdownMenuItem(value: 'for_rent', child: Text('For Rent')),
                  ],
                  onChanged: (value) => setState(() => _status = value ?? _status),
                  decoration: InputDecoration(
                    labelText: strings.t('status'),
                    prefixIcon: const FaIcon(FontAwesomeIcons.tag, size: 16),
                  ),
                ).fadeMove(delay: 40),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _type,
                  items: const [
                    DropdownMenuItem(value: 'apartments', child: Text('Apartments')),
                    DropdownMenuItem(value: 'villas', child: Text('Villas')),
                    DropdownMenuItem(value: 'cabins', child: Text('Cabins')),
                    DropdownMenuItem(value: 'commercial', child: Text('Commercial')),
                  ],
                  onChanged: (value) => setState(() => _type = value ?? _type),
                  decoration: InputDecoration(
                    labelText: strings.t('property_type'),
                    prefixIcon: const FaIcon(FontAwesomeIcons.building, size: 16),
                  ),
                ).fadeMove(delay: 60),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: strings.t('price'),
                    prefixIcon: const FaIcon(FontAwesomeIcons.moneyBill, size: 16),
                  ),
                  validator: (value) =>
                      value != null && double.tryParse(value) != null ? null : strings.t('price_required'),
                ).fadeMove(delay: 80),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _currencyController,
                  decoration: InputDecoration(
                    labelText: strings.t('currency'),
                    prefixIcon: const FaIcon(FontAwesomeIcons.coins, size: 16),
                  ),
                ).fadeMove(delay: 100),
                const SizedBox(height: 24),
                Text(strings.t('location'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: strings.t('city'),
                    prefixIcon: const FaIcon(FontAwesomeIcons.locationDot, size: 16),
                  ),
                  validator: (value) =>
                      value != null && value.isNotEmpty ? null : strings.t('city_required'),
                ).fadeMove(delay: 120),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: strings.t('address'),
                    prefixIcon: const FaIcon(FontAwesomeIcons.locationArrow, size: 16),
                  ),
                  validator: (value) =>
                      value != null && value.isNotEmpty ? null : strings.t('address_required'),
                ).fadeMove(delay: 140),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latController,
                        decoration: InputDecoration(
                          labelText: strings.t('latitude'),
                          prefixIcon: const FaIcon(FontAwesomeIcons.mapLocation, size: 16),
                        ),
                        validator: (value) =>
                            value != null && double.tryParse(value) != null ? null : strings.t('latitude_required'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _lngController,
                        decoration: InputDecoration(
                          labelText: strings.t('longitude'),
                          prefixIcon: const FaIcon(FontAwesomeIcons.mapPin, size: 16),
                        ),
                        validator: (value) =>
                            value != null && double.tryParse(value) != null ? null : strings.t('longitude_required'),
                      ),
                    ),
                  ],
                ).fadeMove(delay: 160),
                const SizedBox(height: 24),
                Text(strings.t('property_details'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _bedsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: strings.t('beds'),
                          prefixIcon: const FaIcon(FontAwesomeIcons.bed, size: 16),
                        ),
                        validator: (value) =>
                            value != null && int.tryParse(value) != null ? null : strings.t('beds_required'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _bathsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: strings.t('baths'),
                          prefixIcon: const FaIcon(FontAwesomeIcons.bath, size: 16),
                        ),
                        validator: (value) =>
                            value != null && int.tryParse(value) != null ? null : strings.t('baths_required'),
                      ),
                    ),
                  ],
                ).fadeMove(delay: 180),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _areaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: strings.t('area'),
                    prefixIcon: const FaIcon(FontAwesomeIcons.rulerCombined, size: 16),
                  ),
                  validator: (value) =>
                      value != null && int.tryParse(value) != null ? null : strings.t('area_required'),
                ).fadeMove(delay: 200),
                const SizedBox(height: 12),
                Text(strings.t('upload_photos')),
                const SizedBox(height: 8),
                ..._imageControllers.map(
                  (controller) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: strings.t('image_url'),
                        prefixIcon: const FaIcon(FontAwesomeIcons.image, size: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(strings.t('select_features')),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final feature in _featureLibrary)
                      FilterChip(
                        label: Text(feature),
                        selected: _selectedFeatures.contains(feature),
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              _selectedFeatures.add(feature);
                            } else {
                              _selectedFeatures.remove(feature);
                            }
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () async {
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    final images = _imageControllers
                        .map((controller) => controller.text)
                        .where((url) => url.isNotEmpty)
                        .toList();
                    if (images.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(strings.t('image_required'))),
                      );
                      return;
                    }
                    final property = await properties.submitProperty(
                      title: _titleController.text,
                      type: _type,
                      status: _status,
                      price: double.parse(_priceController.text),
                      currency: _currencyController.text,
                      city: _cityController.text,
                      address: _addressController.text,
                      lat: double.parse(_latController.text),
                      lng: double.parse(_lngController.text),
                      beds: int.parse(_bedsController.text),
                      baths: int.parse(_bathsController.text),
                      areaM2: int.parse(_areaController.text),
                      images: images,
                      features: _selectedFeatures.toList(),
                      description: strings.t('custom_listing_desc'),
                    );
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.t('property_submitted'))),
                    );
                    Navigator.of(context).pushReplacementNamed(
                      'property.details',
                      arguments: property.id,
                    );
                  },
                  icon: const FaIcon(FontAwesomeIcons.paperPlane, size: 16),
                  label: Text(strings.t('submit_property')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> get _featureLibrary => const [
        'Smart Home',
        'Balcony',
        'Pool',
        'Garden',
        'Workspace',
        'Solar panels',
        'Gym',
        'Concierge',
        'Cinema room',
        'Playground',
      ];
}
