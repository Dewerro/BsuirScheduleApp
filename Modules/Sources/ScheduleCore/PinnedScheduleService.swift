import Foundation
import Dependencies
import Combine
import BsuirCore

public struct PinnedScheduleService {
    public var currentSchedule: @Sendable () -> ScheduleSource?
    public var setCurrentSchedule: @Sendable (ScheduleSource?) -> Void
    public var schedule: @Sendable () -> AnyPublisher<ScheduleSource?, Never>
}

// MARK: - Dependency

extension DependencyValues {
    public var pinnedScheduleService: PinnedScheduleService {
        get { self[PinnedScheduleService.self] }
        set { self[PinnedScheduleService.self] = newValue }
    }
}

extension PinnedScheduleService: DependencyKey {
    public static let liveValue: PinnedScheduleService = {
        @Dependency(\.widgetService) var widgetService
        @Dependency(\.cloudSyncService) var cloudSyncService
        return .live(storage: .asiliukShared, widgetService: widgetService, cloudSyncService: cloudSyncService)
    }()

    public static let previewValue: PinnedScheduleService = .constant(.group(name: "151004"))
}

// MARK: - Live

extension PinnedScheduleService {
    static func live(
        storage: UserDefaults,
        widgetService: WidgetService,
        cloudSyncService: CloudSyncService
    ) -> Self {
        let pinnedScheduleStorage = storage
            .persistedDictionary(forKey: "pinned-schedule")
            .sync(with: cloudSyncService, forKey: "cloud-pinned-schedule", shouldSyncInitialLocalValue: true)
            .codable(ScheduleSource.self)
            .withPublisher()

        return Self(
            currentSchedule: {
                pinnedScheduleStorage.persisted.value
            },
            setCurrentSchedule: { newValue in
                pinnedScheduleStorage.persisted.value = newValue
                // Make sure widget UI is also updated
                widgetService.reloadAll()
            },
            schedule: {
                pinnedScheduleStorage.publisher
            }
        )
    }

    static func constant(_ source: ScheduleSource) -> Self {
        Self(
            currentSchedule: { source },
            setCurrentSchedule: { _ in },
            schedule: { Just(source).eraseToAnyPublisher() }
        )
    }
}
