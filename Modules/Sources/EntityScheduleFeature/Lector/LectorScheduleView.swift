import SwiftUI
import ScheduleFeature
import ComposableArchitecture
import ComposableArchitectureUtils

public struct LectorScheduleView: View {
    let store: StoreOf<LectorScheduleFeature>
    
    public init(store: StoreOf<LectorScheduleFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            ScheduleFeatureView(
                store: store.scope(state: \.schedule, reducerAction: { .schedule($0) }),
                schedulePairDetails: .groups {
                    viewStore.send(.groupTapped($0))
                }
            )
            .sheet(item: viewStore.binding(\.$groupSchedule)) { _ in
                ModalNavigationStack {
                    IfLetStore(
                        store.scope(state: \.groupSchedule, reducerAction: { .groupSchedule($0) })
                    ) { store in
                        GroupScheduleView(store: store)
                    }
                }
            }
        }
    }
}
