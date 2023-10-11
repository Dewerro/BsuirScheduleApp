import SwiftUI
import BsuirUI
import ComposableArchitecture

struct ScheduleListView: View {
    let store: StoreOf<ScheduleListFeature>

    var body: some View {
        WithViewStore(store, observe: \.hasSchedule) { viewStore in
            if viewStore.state {
                ScheduleContentListView(store: store)
            } else {
                ScheduleEmptyView()
            }
        }
    }
}

private struct ScheduleContentListView: View {
    let store: StoreOf<ScheduleListFeature>
    @State var presentsPairDetailsPopover: Bool = false

    var body: some View {
        WithViewStore(store, observe: \.isOnTop) { viewStore in
            ScrollableToTopList(isOnTop: viewStore.binding(send: { .setIsOnTop($0) })) {
                Group {
                    ForEachStore(
                        store.scope(
                            state: \.days,
                            action: { .day(id: $0, action: $1) }
                        ),
                        content: DaySectionView.init
                    )

                    WithViewStore(store, observe: \.loading) { viewStore in
                        switch viewStore.state {
                        case .loadMore:
                            ShimmeringPairPlaceholder()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .onAppear { viewStore.send(.loadingIndicatorAppeared) }
                        case .finished:
                            NoMorePairsIndicator()
                        case .never:
                            EmptyView()
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .onPreferenceChange(PresentsPairDetailsPopoverPreferenceKey.self) { presentsPairDetailsPopover = $0 }
            .environment(\.presentsPairDetailsPopover, presentsPairDetailsPopover)
        }
    }
}

struct NoMorePairsIndicator: View {
    var body: some View {
        Text("screen.schedule.noMorePairs.title")
            .font(.headline)
            .frame(minWidth: 0, maxWidth: .infinity)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
