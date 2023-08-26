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

struct TaskListView: View {
  @ObservedObject var taskManager = TaskManager.shared
  @State var showNotificationSettingsUI = false

  var body: some View {
    ZStack {
      VStack {
        HStack {
          Spacer()
          Text("Organizer Plus")
            .font(.title)
            .foregroundColor(.pink)
          Spacer()
          Button(
            action: {
              NotificationManager.shared.requestAuthorization { granted in
                if granted {
                  showNotificationSettingsUI = true
                }
              }
            },
            label: {
              Image(systemName: "bell")
                .font(.title)
                .accentColor(.pink)
            })
            .padding(.trailing)
            .sheet(isPresented: $showNotificationSettingsUI) {
              NotificationSettingsView()
            }
        }
        .padding()
        if taskManager.tasks.isEmpty {
          Spacer()
          Text("No Tasks!")
            .foregroundColor(.pink)
            .font(.title3)
          Spacer()
        } else {
          List(taskManager.tasks) { task in
            TaskCell(task: task)
          }
          .padding()
        }
      }
      AddTaskView()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    TaskListView()
  }
}

struct TaskCell: View {
  var task: Task

  var body: some View {
    HStack {
      Button(
        action: {
          TaskManager.shared.markTaskComplete(task: task)
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            TaskManager.shared.remove(task: task)
          }
        }, label: {
          Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 20, height: 20)
            .accentColor(.pink)
        })
      if task.completed {
        Text(task.name)
          .strikethrough()
          .foregroundColor(.pink)
      } else {
        Text(task.name)
          .foregroundColor(.pink)
      }
    }
  }
}

struct AddTaskView: View {
  @State var showCreateTaskView = false

  var body: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Button(
          action: {
            showCreateTaskView = true
          }, label: {
            Text("+")
              .font(.largeTitle)
              .multilineTextAlignment(.center)
              .frame(width: 30, height: 30)
              .foregroundColor(Color.white)
              .padding()
          })
          .background(Color.pink)
          .cornerRadius(40)
          .padding()
          .sheet(isPresented: $showCreateTaskView) {
            CreateTaskView()
          }
      }
      .padding(.bottom)
    }
  }
}
