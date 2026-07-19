import 'package:alhakim/core/error/failures.dart';
import 'package:alhakim/core/usecases/usecase.dart';
import 'package:alhakim/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:alhakim/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:alhakim/features/notifications/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:alhakim/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:alhakim/features/notifications/domain/usecases/params/mark_notification_as_read_params.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;

  NotificationsCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
    required this.markAllNotificationsAsReadUseCase,
  }) : super(const NotificationsState());

  Future<void> getNotifications({bool showLoading = true}) async {
    if (state.status == NotificationsStatus.loading) {
      return;
    }

    if (showLoading) {
      emit(
        state.copyWith(
          status: NotificationsStatus.loading,
          clearErrorMessage: true,
          clearActionMessage: true,
        ),
      );
    }

    final Either<Failure, List<AppNotification>> result =
        await getNotificationsUseCase(NoParams());

    result.fold(
      (Failure failure) {
        emit(
          state.copyWith(
            status: NotificationsStatus.failure,
            errorMessage: failure.message ?? '',
            clearActionMessage: true,
          ),
        );
      },
      (List<AppNotification> notifications) {
        final sortedNotifications = [
          ...notifications,
        ]..sort((first, second) => second.createdAt.compareTo(first.createdAt));

        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            notifications: sortedNotifications,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> refreshNotifications() {
    return getNotifications(showLoading: false);
  }

  Future<void> markAsRead(String notificationId) async {
    final trimmedId = notificationId.trim();
    if (trimmedId.isEmpty) {
      return;
    }

    AppNotification? existing;
    for (final notification in state.notifications) {
      if (notification.id == trimmedId) {
        existing = notification;
        break;
      }
    }

    if (existing == null || existing.isRead) {
      return;
    }

    if (state.isMarkingNotificationAsRead(trimmedId)) {
      return;
    }

    emit(
      state.copyWith(
        readingNotificationIds: {...state.readingNotificationIds, trimmedId},
        clearErrorMessage: true,
        clearActionMessage: true,
      ),
    );

    final Either<Failure, String> result = await markNotificationAsReadUseCase(
      MarkNotificationAsReadParams(notificationId: trimmedId),
    );

    result.fold(
      (Failure failure) {
        final updatedIds = {...state.readingNotificationIds}..remove(trimmedId);
        emit(
          state.copyWith(
            readingNotificationIds: updatedIds,
            errorMessage: failure.message ?? '',
          ),
        );
      },
      (String message) {
        final readAt = DateTime.now().toUtc();
        final updatedNotifications = state.notifications.map((notification) {
          if (notification.id != trimmedId) {
            return notification;
          }
          return notification.copyWith(readAt: readAt);
        }).toList();

        final updatedIds = {...state.readingNotificationIds}..remove(trimmedId);

        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            notifications: updatedNotifications,
            readingNotificationIds: updatedIds,
            actionMessage: message.isEmpty ? null : message,
            clearErrorMessage: true,
            clearActionMessage: message.isEmpty,
          ),
        );
      },
    );
  }

  Future<void> markAllAsRead() async {
    if (state.isMarkingAllAsRead || !state.hasUnreadNotifications) {
      return;
    }

    emit(
      state.copyWith(
        isMarkingAllAsRead: true,
        clearErrorMessage: true,
        clearActionMessage: true,
      ),
    );

    final Either<Failure, String> result =
        await markAllNotificationsAsReadUseCase(NoParams());

    result.fold(
      (Failure failure) {
        emit(
          state.copyWith(
            isMarkingAllAsRead: false,
            errorMessage: failure.message ?? '',
          ),
        );
      },
      (String message) {
        final readAt = DateTime.now().toUtc();
        final updatedNotifications = state.notifications.map((notification) {
          if (notification.isRead) {
            return notification;
          }
          return notification.copyWith(readAt: readAt);
        }).toList();

        emit(
          state.copyWith(
            status: NotificationsStatus.success,
            notifications: updatedNotifications,
            isMarkingAllAsRead: false,
            actionMessage: message.isEmpty ? null : message,
            clearErrorMessage: true,
            clearActionMessage: message.isEmpty,
          ),
        );
      },
    );
  }
}
