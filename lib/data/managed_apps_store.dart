
import 'package:flutter/material.dart';
import 'package:softlock/theme.dart';

@immutable
class ManagedApp {
  const ManagedApp({required this.id, required this.name, required this.iconBg, required this.dailyLimitMinutes, required this.detoxTotalDays, required this.detoxCurrentDay, required this.startedLabel, required this.endsLabel});

  final String id;
  final String name;
  final Color iconBg;
  final int dailyLimitMinutes;
  final int detoxTotalDays;
  final int detoxCurrentDay;
  final String startedLabel;
  final String endsLabel;

  String get initial => name.trim().isEmpty ? '?' : name.trim().characters.first.toUpperCase();

  ManagedApp copyWith({int? dailyLimitMinutes}) => ManagedApp(
    id: id,
    name: name,
    iconBg: iconBg,
    dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
    detoxTotalDays: detoxTotalDays,
    detoxCurrentDay: detoxCurrentDay,
    startedLabel: startedLabel,
    endsLabel: endsLabel,
  );
}

/// Lightweight in-memory store used by settings screens.
/// (No backend connected yet.)
class ManagedAppsStore {
  ManagedAppsStore._();

  static final ValueNotifier<List<ManagedApp>> apps = ValueNotifier<List<ManagedApp>>([
    const ManagedApp(
      id: 'instagram',
      name: 'Instagram',
      iconBg: SoftlockBrandColors.instagram,
      dailyLimitMinutes: 30,
      detoxTotalDays: 14,
      detoxCurrentDay: 8,
      startedLabel: 'March 1 2026',
      endsLabel: 'March 15 2026',
    ),
    const ManagedApp(
      id: 'tiktok',
      name: 'TikTok',
      iconBg: SoftlockBrandColors.tiktok,
      dailyLimitMinutes: 60,
      detoxTotalDays: 14,
      detoxCurrentDay: 8,
      startedLabel: 'March 1 2026',
      endsLabel: 'March 15 2026',
    ),
    const ManagedApp(
      id: 'youtube',
      name: 'YouTube',
      iconBg: SoftlockBrandColors.youtube,
      dailyLimitMinutes: 90,
      detoxTotalDays: 14,
      detoxCurrentDay: 8,
      startedLabel: 'March 1 2026',
      endsLabel: 'March 15 2026',
    ),
    const ManagedApp(
      id: 'x',
      name: 'X',
      iconBg: SoftlockBrandColors.twitterX,
      dailyLimitMinutes: 30,
      detoxTotalDays: 14,
      detoxCurrentDay: 8,
      startedLabel: 'March 1 2026',
      endsLabel: 'March 15 2026',
    ),
  ]);

  static bool containsId(String id) => apps.value.any((a) => a.id == id);

  static ManagedApp? byId(String id) {
    for (final a in apps.value) {
      if (a.id == id) return a;
    }
    return null;
  }

  static void add(ManagedApp app) {
    if (containsId(app.id)) return;
    apps.value = [...apps.value, app];
  }

  static void update(ManagedApp app) {
    apps.value = [
      for (final a in apps.value) a.id == app.id ? app : a,
    ];
  }
}
