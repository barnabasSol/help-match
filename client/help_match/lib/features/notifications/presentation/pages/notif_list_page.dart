import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_match/core/secrets/secrets.dart';
import 'package:help_match/features/notifications/dto/volunteer_notif_dto.dart';
import 'package:help_match/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:help_match/features/notifications/presentation/widgets/notif_card.dart';
import 'package:help_match/shared/widgets/app_bar.dart';
import 'package:help_match/shared/widgets/loading_indicator.dart';

class NotificationListPage extends StatelessWidget {
  const NotificationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          const CustomAppbar(),
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationFetchLoading) {
                return const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                    child: LoadingIndicator(),
                  ),
                );
              } else if (state is VolunteerNotificationFetchLoaded) {
                return SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final notif = state.notifList[index];
                        final notification = VolunteerNotificationDto(
                          orgId: notif.orgId,
                          profileIcon: notif.profileIcon == ""
                              ? Secrets.DummyImage
                              : notif.profileIcon,
                          orgType: notif.orgType,
                          orgName: notif.orgName,
                          message: notif.message,
                          isVerified: index % 2 == 0,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: NotificationCard(notification: notification),
                        );
                      },
                      childCount: state.notifList.length,
                    ),
                  ),
                );
              } else if (state is OrgNotificationFetchLoaded) {
                return SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final notif = state.notifList[index];
                        final notification = VolunteerNotificationDto(
                          orgId: notif.volunteerId,
                          profileIcon: Secrets.DummyImage,
                          orgType: "",
                          orgName: notif.volunteerName,
                          message: notif.message,
                          isVerified: false,
                        );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: NotificationCard(notification: notification),
                        );
                      },
                      childCount: state.notifList.length,
                    ),
                  ),
                );
              } else if (state is NotificationFetchError) {
                // Wrap Center in SliverToBoxAdapter
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(state.error),
                  ),
                );
              } else {
                // Wrap Center in SliverToBoxAdapter
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text('Im lost'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
