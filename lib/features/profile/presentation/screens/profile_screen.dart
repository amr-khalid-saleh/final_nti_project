import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared_widgets/main_scaffold.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';
import '../widgets/profile_app_bar_widget.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/recent_activity_widget.dart';
import '../widgets/stats_row_widget.dart';
import '../widgets/subscription_card_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 3,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.textPrimary));
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.font16WhiteSemiBold),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<ProfileCubit>().fetchProfile(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 200),
                child: Column(
                  children: [
                    const ProfileAppBarWidget(),
                    const SizedBox(height: 20),
                    ProfileHeaderWidget(profile: state.profile),
                    const SizedBox(height: 24),
                    StatsRowWidget(profile: state.profile),
                    const SizedBox(height: 20),
                    SubscriptionCardWidget(profile: state.profile),
                    const SizedBox(height: 24),
                    RecentActivityWidget(recentTracks: state.recentTracks),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

