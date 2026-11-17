//PlantoApp.swift - Entry point of the Planto application.
//
// Contains:
// - Main app structure.
// - Root HomeView.
// - Notification delegate registration.
// - Foreground notification presentation.
//
// Used by: iOS system to launch the app.
//
// Learn: @main, App protocol, WindowGroup,
// UIApplicationDelegateAdaptor,
// UIApplicationDelegate, UNUserNotificationCenterDelegate.
//

import SwiftUI
import UserNotifications

// MARK: - Planto App

@main
struct PlantoApp: App {

    // MARK: - Notification Delegate

    @UIApplicationDelegateAdaptor(PlantoNotificationDelegate.self)
    private var notificationDelegate

    // MARK: - App Scene

    var body: some Scene {

        WindowGroup {

            HomeView()
        }
    }
}

// MARK: - App Notification Delegate

final class PlantoNotificationDelegate: NSObject,
    UIApplicationDelegate,
    UNUserNotificationCenterDelegate {

    // MARK: - App Launch

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        UNUserNotificationCenter.current().delegate = self

        print("✅ Notification delegate registered")

        return true
    }

    // MARK: - Foreground Notifications

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {

        print("📬 Foreground notification received")
        print("📬 ID: \(notification.request.identifier)")

        return [.banner, .list, .sound]
    }
}

// MARK: - Preview

#Preview("Planto") {
    HomeView()
}
