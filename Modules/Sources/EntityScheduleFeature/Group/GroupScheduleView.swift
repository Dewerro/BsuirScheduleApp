import SwiftUI
import ScheduleFeature
import ComposableArchitecture
import ComposableArchitectureUtils

public struct GroupScheduleView: View {
    let store: StoreOf<GroupScheduleFeature>
    
    public init(store: StoreOf<GroupScheduleFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            ScheduleFeatureView(
                store: store.scope(state: \.schedule, reducerAction: { .schedule($0) }),
                schedulePairDetails: .lecturers {
                    viewStore.send(.lectorTapped($0))
                }
            )
            .sheet(item: viewStore.binding(\.$lectorSchedule)) { _ in
                ModalNavigationStack {
                    IfLetStore(
                        store.scope(state: \.lectorSchedule?.value, reducerAction: { .lectorSchedule($0) })
                    ) { store in
                        LectorScheduleView(store: store)
                    }
                }
            }
        }
    }
}
