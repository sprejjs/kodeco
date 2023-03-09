/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import UserNotifications
import CoreLocation

enum NotificationManagerConstants {
  static let timeBasedNotificationThreadId =
    "TimeBasedNotificationThreadId"
  static let calendarBasedNotificationThreadId =
    "CalendarBasedNotificationThreadId"
  static let locationBasedNotificationThreadId =
    "LocationBasedNotificationThreadId"
}

class NotificationManager: ObservableObject {
  static let shared = NotificationManager()
  @Published var settings: UNNotificationSettings?

  func requestAuthorization(completion: @escaping  (Bool) -> Void) {
    UNUserNotificationCenter.current()
      .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
        self.fetchNotificationSettings()
        completion(granted)
      }
  }

  func fetchNotificationSettings() {
    // 1
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      // 2
      DispatchQueue.main.async {
        self.settings = settings
      }
    }
  }

  func removeScheduledNotification(task: Task) {
    UNUserNotificationCenter.current()
      .removePendingNotificationRequests(withIdentifiers: [task.id])
  }

  // 1
  func scheduleNotification(task: Task) {
    // 2
    let content = UNMutableNotificationContent()
    content.title = task.name
    content.body = "Gentle reminder for your task!"
    content.categoryIdentifier = "OrganizerPlusCategory"
    let taskData = try? JSONEncoder().encode(task)
    if let taskData = taskData {
      content.userInfo = ["Task": taskData]
    }

    // 3
    var trigger: UNNotificationTrigger?
    switch task.reminder.reminderType {
    case .time:
      if let timeInterval = task.reminder.timeInterval {
        trigger = UNTimeIntervalNotificationTrigger(
          timeInterval: timeInterval,
          repeats: task.reminder.repeats)
      }
      content.threadIdentifier =
        NotificationManagerConstants.timeBasedNotificationThreadId
    case .calendar:
      if let date = task.reminder.date {
        trigger = UNCalendarNotificationTrigger(
          dateMatching: Calendar.current.dateComponents(
            [.day, .month, .year, .hour, .minute],
            from: date),
          repeats: task.reminder.repeats)
      }
      content.threadIdentifier =
        NotificationManagerConstants.calendarBasedNotificationThreadId
    case .location:
      // 1
      guard CLLocationManager().authorizationStatus == .authorizedWhenInUse else {
        return
      }
      // 2
      if let location = task.reminder.location {
        // 3
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = CLCircularRegion(center: center, radius: location.radius, identifier: task.id)
        trigger = UNLocationNotificationTrigger(region: region, repeats: task.reminder.repeats)
      }
      content.threadIdentifier =
        NotificationManagerConstants.locationBasedNotificationThreadId
    }

    // 4
    if let trigger = trigger {
      let request = UNNotificationRequest(
        identifier: task.id,
        content: content,
        trigger: trigger)
      // 5
      UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
          print(error)
        }
      }
    }
  }
}
