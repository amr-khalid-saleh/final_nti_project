import 'package:flutter/material.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.scaffoldBgTop, AppColors.scaffoldBgBottom],
          stops: [0.6, 0.95],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Top Bar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back,
                          color: AppColors.textPrimary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Text('Settings', style: AppTextStyles.heading2),
                  ],
                ),

                const SizedBox(height: 24),

                SettingsTile(
                  icon: Icons.person_outline,
                  label: 'Account',
                  onTap: () {},
                ),
                const SizedBox(height: 10),
                SettingsTile(
                  icon: Icons.music_note_outlined,
                  label: 'Audio Quality',
                  onTap: () {},
                ),
                const SizedBox(height: 10),


                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_outlined,
                          color: AppColors.textSecondary, size: 20),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text('Notifications',
                            style: AppTextStyles.bodyMedium),
                      ),
                      Switch(
                        value: notificationsEnabled,
                        onChanged: (v) =>
                            setState(() => notificationsEnabled = v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                SettingsTile(
                  icon: Icons.storage_outlined,
                  label: 'Storage',
                  onTap: () {},
                ),

                const SizedBox(height: 32),

                // Logout
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout,
                            color: AppColors.textPrimary, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

               // const Spacer(),
                const SizedBox(height: 16),

                Center(
                  child: Text('Version 4.12.0 (Premium)',
                      style: AppTextStyles.caption),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
