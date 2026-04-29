import '../../../../core/shared_widgets/main_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 3,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 200),
          child: Column(
            children: [
              const ProfileAppBarWidget(),
              const SizedBox(height: 20),
              const ProfileHeaderWidget(),
              const SizedBox(height: 24),
              const StatsRowWidget(),
              const SizedBox(height: 20),
              const SubscriptionCardWidget(),
              const SizedBox(height: 24),
              const RecentActivityWidget(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
