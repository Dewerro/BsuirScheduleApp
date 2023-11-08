import WidgetKit
import BsuirCore
import BsuirUI
import ScheduleCore
import Foundation
import Deeplinking

struct ExamsScheduleEntry: TimelineEntry {
    var date = Date()
    var relevance: TimelineEntryRelevance? = nil
    var config: ExamsScheduleWidgetConfiguration
}

extension ExamsScheduleEntry {
    static let placeholder = ExamsScheduleEntry(config: .placeholder)
    static let noPinned = ExamsScheduleEntry(config: .noPinned(deeplink: deeplinkRouter.url(for: .groups)))
    static let premiumLocked = ExamsScheduleEntry(config: .noPinned(deeplink: deeplinkRouter.url(for: .pinned())))
    static let preview = ExamsScheduleEntry(config: .preview)
    
    static func emptyPinned(title: String) -> ExamsScheduleEntry {
        ExamsScheduleEntry(
            config: .empty(
                title: title,
                deeplink: deeplinkRouter.url(for: .pinned(displayType: .exams))
            )
        )
    }
}
