//
//  MenuBarTimelineView.swift
//  Aware
//
//  Created by Joshua Peek on 3/7/24.
//

#if os(macOS)

import SwiftUI

// Using TimelineView within MenuBarExtra content seems to beachball on macOS Sonoma 14.4.
// Reported Feedback FB13678902 on Mar 7, 2024.
struct MenuBarTimelineView<Schedule, Content>: View
    where Schedule: TimelineSchedule, Content: View
{
    let schedule: Schedule
    let content: (MenuBarTimelineViewDefaultContext) -> Content

    private let startDate = Date()

    @State private var context: MenuBarTimelineViewDefaultContext = .init(date: .now)

    init(
        _ schedule: Schedule,
        @ViewBuilder content: @escaping (MenuBarTimelineViewDefaultContext) -> Content
    ) {
        self.schedule = schedule
        self.content = content
    }

    var body: some View {
        content(context)
            .task(id: startDate) {
                for date in schedule.entries(from: startDate, mode: .normal) {
                    let duration: Duration = .init(timeInterval: date.timeIntervalSinceNow)
                    if duration > .zero {
                        do {
                            try await Task.sleep(for: duration)
                        } catch is CancellationError {
                            return
                        } catch {
                            assertionFailure("sleep threw unknown error")
                            return
                        }
                    }
                    assert(date <= Date.now, "didn't sleep long enough")
                    context = .init(date: date)
                }
            }
    }
}

struct MenuBarTimelineViewDefaultContext {
    let date: Date
}

#endif
