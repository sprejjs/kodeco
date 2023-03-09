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

import SwiftUI
import MapKit

struct CreateTaskView: View {
  @State var taskName: String = ""
  @State var reminderEnabled = false
  @State var selectedTrigger = ReminderType.time
  @State var timeDurationIndex: Int = 0
  @State private var dateTrigger = Date()
  @State private var shouldRepeat = false
  @State private var latitude: String = ""
  @State private var longitude: String = ""
  @State private var radius: String = ""
  @Environment(\.presentationMode) var presentationMode

  let triggers = ["Time", "Calendar", "Location"]
  let timeDurations: [Int] = Array(1...59)
  var body: some View {
    NavigationView {
      Form {
        Section {
          HStack {
            Spacer()
            Text("Add Task")
              .font(.title)
              .padding()
            Spacer()
            Button("Save") {
              TaskManager.shared.addNewTask(taskName, makeReminder())
              presentationMode.wrappedValue.dismiss()
            }
            .disabled(taskName.isEmpty ? true : false)
            .padding()
          }
          VStack {
            TextField("Enter name for the task", text: $taskName)
              .padding(.vertical)
            Toggle(isOn: $reminderEnabled) {
              Text("Add Reminder")
            }
            .padding(.vertical)

            if reminderEnabled {
              ReminderView(
                selectedTrigger: $selectedTrigger,
                timeDurationIndex: $timeDurationIndex,
                triggerDate: $dateTrigger,
                shouldRepeat: $shouldRepeat,
                latitude: $latitude,
                longitude: $longitude,
                radius: $radius)
                .navigationBarHidden(true)
                .navigationTitle("")
            }
            Spacer()
          }
          .padding()
        }
      }
      .navigationBarTitle("")
      .navigationBarHidden(true)
    }
  }

  func makeReminder() -> Reminder? {
    guard reminderEnabled else {
      return nil
    }
    var reminder = Reminder()
    reminder.reminderType = selectedTrigger
    switch selectedTrigger {
    case .time:
      reminder.timeInterval = TimeInterval(timeDurations[timeDurationIndex] * 60)
    case .calendar:
      reminder.date = dateTrigger
    case .location:
      if let latitude = Double(latitude),
        let longitude = Double(longitude),
        let radius = Double(radius) {
        reminder.location = LocationReminder(
          latitude: latitude,
          longitude: longitude,
          radius: radius)
      }
    }
    reminder.repeats = shouldRepeat
    return reminder
  }
}

struct CreateTaskView_Previews: PreviewProvider {
  static var previews: some View {
    CreateTaskView()
  }
}

struct ReminderView: View {
  @Binding var selectedTrigger: ReminderType
  @Binding var timeDurationIndex: Int
  @Binding var triggerDate: Date
  @Binding var shouldRepeat: Bool
  @Binding var latitude: String
  @Binding var longitude: String
  @Binding var radius: String
  @StateObject var locationManager = LocationManager()

  var body: some View {
    VStack {
      Picker("Notification Trigger", selection: $selectedTrigger) {
        Text("Time").tag(ReminderType.time)
        Text("Date").tag(ReminderType.calendar)
        Text("Location").tag(ReminderType.location)
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding(.vertical)
      if selectedTrigger == ReminderType.time {
        Picker("Time Interval", selection: $timeDurationIndex) {
          ForEach(1 ..< 59) { i in
            if i == 1 {
              Text("\(i) minute").tag(i)
            } else {
              Text("\(i) minutes").tag(i)
            }
          }
          .navigationBarHidden(true)
          .padding(.vertical)
        }
      } else if selectedTrigger == ReminderType.calendar {
        DatePicker("Please enter a date", selection: $triggerDate)
          .labelsHidden()
          .padding(.vertical)
      } else {
        VStack {
          if !locationManager.authorized {
            Button(
              action: {
                // TODO: Request location authorization
              },
              label: {
                Text("Request Location Authorization")
              })
          } else {
            TextField("Enter Latitude", text: $latitude)
            TextField("Enter Longitude", text: $longitude)
            TextField("Enter Radius", text: $radius)
          }
        }
        .padding(.vertical)
      }
      Toggle(isOn: $shouldRepeat) {
        Text("Repeat Notification")
      }
    }
  }
}
