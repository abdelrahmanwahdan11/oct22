import 'package:flutter/material.dart';

class EnhancementOption {
  const EnhancementOption({
    required this.id,
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
    required this.chipKey,
    this.defaultEnabled = false,
  });

  final String id;
  final IconData icon;
  final String titleKey;
  final String subtitleKey;
  final String chipKey;
  final bool defaultEnabled;
}

const enhancementCatalog = <EnhancementOption>[
  EnhancementOption(
    id: 'vacation_mode',
    icon: Icons.flight_takeoff,
    titleKey: 'feature_vacation_mode_title',
    subtitleKey: 'feature_vacation_mode_subtitle',
    chipKey: 'feature_vacation_mode_chip',
  ),
  EnhancementOption(
    id: 'night_lighting',
    icon: Icons.nightlight_round,
    titleKey: 'feature_night_lighting_title',
    subtitleKey: 'feature_night_lighting_subtitle',
    chipKey: 'feature_night_lighting_chip',
  ),
  EnhancementOption(
    id: 'energy_saver',
    icon: Icons.eco_outlined,
    titleKey: 'feature_energy_saver_title',
    subtitleKey: 'feature_energy_saver_subtitle',
    chipKey: 'feature_energy_saver_chip',
  ),
  EnhancementOption(
    id: 'auto_lock',
    icon: Icons.lock_clock,
    titleKey: 'feature_auto_lock_title',
    subtitleKey: 'feature_auto_lock_subtitle',
    chipKey: 'feature_auto_lock_chip',
  ),
  EnhancementOption(
    id: 'presence_simulation',
    icon: Icons.visibility_outlined,
    titleKey: 'feature_presence_simulation_title',
    subtitleKey: 'feature_presence_simulation_subtitle',
    chipKey: 'feature_presence_simulation_chip',
  ),
  EnhancementOption(
    id: 'air_quality_watch',
    icon: Icons.cloud_outlined,
    titleKey: 'feature_air_quality_watch_title',
    subtitleKey: 'feature_air_quality_watch_subtitle',
    chipKey: 'feature_air_quality_watch_chip',
  ),
  EnhancementOption(
    id: 'pet_monitor',
    icon: Icons.pets,
    titleKey: 'feature_pet_monitor_title',
    subtitleKey: 'feature_pet_monitor_subtitle',
    chipKey: 'feature_pet_monitor_chip',
  ),
  EnhancementOption(
    id: 'leak_alerts',
    icon: Icons.water_damage_outlined,
    titleKey: 'feature_leak_alerts_title',
    subtitleKey: 'feature_leak_alerts_subtitle',
    chipKey: 'feature_leak_alerts_chip',
  ),
  EnhancementOption(
    id: 'device_health',
    icon: Icons.stacked_bar_chart,
    titleKey: 'feature_device_health_title',
    subtitleKey: 'feature_device_health_subtitle',
    chipKey: 'feature_device_health_chip',
  ),
  EnhancementOption(
    id: 'battery_watch',
    icon: Icons.battery_full,
    titleKey: 'feature_battery_watch_title',
    subtitleKey: 'feature_battery_watch_subtitle',
    chipKey: 'feature_battery_watch_chip',
  ),
  EnhancementOption(
    id: 'security_patrol',
    icon: Icons.shield_moon,
    titleKey: 'feature_security_patrol_title',
    subtitleKey: 'feature_security_patrol_subtitle',
    chipKey: 'feature_security_patrol_chip',
  ),
  EnhancementOption(
    id: 'guest_pass',
    icon: Icons.badge_outlined,
    titleKey: 'feature_guest_pass_title',
    subtitleKey: 'feature_guest_pass_subtitle',
    chipKey: 'feature_guest_pass_chip',
  ),
  EnhancementOption(
    id: 'voice_assistant',
    icon: Icons.settings_voice,
    titleKey: 'feature_voice_assistant_title',
    subtitleKey: 'feature_voice_assistant_subtitle',
    chipKey: 'feature_voice_assistant_chip',
  ),
  EnhancementOption(
    id: 'geo_fencing',
    icon: Icons.gps_fixed,
    titleKey: 'feature_geo_fencing_title',
    subtitleKey: 'feature_geo_fencing_subtitle',
    chipKey: 'feature_geo_fencing_chip',
  ),
  EnhancementOption(
    id: 'cleaning_cycle',
    icon: Icons.cleaning_services,
    titleKey: 'feature_cleaning_cycle_title',
    subtitleKey: 'feature_cleaning_cycle_subtitle',
    chipKey: 'feature_cleaning_cycle_chip',
  ),
  EnhancementOption(
    id: 'smart_notifications',
    icon: Icons.notifications_active_outlined,
    titleKey: 'feature_smart_notifications_title',
    subtitleKey: 'feature_smart_notifications_subtitle',
    chipKey: 'feature_smart_notifications_chip',
  ),
  EnhancementOption(
    id: 'routine_suggestions',
    icon: Icons.auto_mode,
    titleKey: 'feature_routine_suggestions_title',
    subtitleKey: 'feature_routine_suggestions_subtitle',
    chipKey: 'feature_routine_suggestions_chip',
  ),
  EnhancementOption(
    id: 'peak_protection',
    icon: Icons.flash_on,
    titleKey: 'feature_peak_protection_title',
    subtitleKey: 'feature_peak_protection_subtitle',
    chipKey: 'feature_peak_protection_chip',
  ),
  EnhancementOption(
    id: 'solar_sync',
    icon: Icons.sunny,
    titleKey: 'feature_solar_sync_title',
    subtitleKey: 'feature_solar_sync_subtitle',
    chipKey: 'feature_solar_sync_chip',
  ),
  EnhancementOption(
    id: 'green_tips',
    icon: Icons.grass,
    titleKey: 'feature_green_tips_title',
    subtitleKey: 'feature_green_tips_subtitle',
    chipKey: 'feature_green_tips_chip',
  ),
  EnhancementOption(
    id: 'insights_digest',
    icon: Icons.article_outlined,
    titleKey: 'feature_insights_digest_title',
    subtitleKey: 'feature_insights_digest_subtitle',
    chipKey: 'feature_insights_digest_chip',
  ),
  EnhancementOption(
    id: 'scene_learning',
    icon: Icons.auto_awesome_motion,
    titleKey: 'feature_scene_learning_title',
    subtitleKey: 'feature_scene_learning_subtitle',
    chipKey: 'feature_scene_learning_chip',
  ),
  EnhancementOption(
    id: 'firmware_auto',
    icon: Icons.system_update_alt,
    titleKey: 'feature_firmware_auto_title',
    subtitleKey: 'feature_firmware_auto_subtitle',
    chipKey: 'feature_firmware_auto_chip',
  ),
  EnhancementOption(
    id: 'backup_restore',
    icon: Icons.backup_outlined,
    titleKey: 'feature_backup_restore_title',
    subtitleKey: 'feature_backup_restore_subtitle',
    chipKey: 'feature_backup_restore_chip',
  ),
  EnhancementOption(
    id: 'mfa',
    icon: Icons.verified_user_outlined,
    titleKey: 'feature_mfa_title',
    subtitleKey: 'feature_mfa_subtitle',
    chipKey: 'feature_mfa_chip',
  ),
  EnhancementOption(
    id: 'privacy_mode',
    icon: Icons.visibility_off_outlined,
    titleKey: 'feature_privacy_mode_title',
    subtitleKey: 'feature_privacy_mode_subtitle',
    chipKey: 'feature_privacy_mode_chip',
  ),
  EnhancementOption(
    id: 'shared_alerts',
    icon: Icons.family_restroom,
    titleKey: 'feature_shared_alerts_title',
    subtitleKey: 'feature_shared_alerts_subtitle',
    chipKey: 'feature_shared_alerts_chip',
  ),
  EnhancementOption(
    id: 'automation_sandbox',
    icon: Icons.science_outlined,
    titleKey: 'feature_automation_sandbox_title',
    subtitleKey: 'feature_automation_sandbox_subtitle',
    chipKey: 'feature_automation_sandbox_chip',
  ),
  EnhancementOption(
    id: 'energy_budget_guard',
    icon: Icons.account_balance_wallet_outlined,
    titleKey: 'feature_energy_budget_guard_title',
    subtitleKey: 'feature_energy_budget_guard_subtitle',
    chipKey: 'feature_energy_budget_guard_chip',
  ),
  EnhancementOption(
    id: 'maintenance_scheduler',
    icon: Icons.build_circle_outlined,
    titleKey: 'feature_maintenance_scheduler_title',
    subtitleKey: 'feature_maintenance_scheduler_subtitle',
    chipKey: 'feature_maintenance_scheduler_chip',
  ),
];
