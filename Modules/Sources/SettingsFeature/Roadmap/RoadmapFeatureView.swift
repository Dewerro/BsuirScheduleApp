import SwiftUI
import Roadmap
import ComposableArchitecture

struct RoadmapFeatureView: View {
    let store: StoreOf<RoadmapFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            let configuration = RoadmapConfiguration(
                roadmapJSONURL: viewStore.jsonURL,
                voter: FeatureVoterTallyAPI(namespace: viewStore.namespace),
                namespace: viewStore.namespace,
                style: .bsuir
            )

            RoadmapView(configuration: configuration)
        }
        .navigationTitle("screen.settings.roadmap.navigation.title")
    }
}

private extension RoadmapStyle {
    static let bsuir = RoadmapStyle(
        upvoteIcon: Image(systemName: "arrow.up"),
        unvoteIcon: Image(systemName: "arrow.down"),
        titleFont: .title3,
        numberFont: .callout,
        statusFont: .footnote,
        statusTintColor: { status in
            switch status {
            case "next_release": .green
            case "planned": .blue
            case "idea": .yellow
            default: .secondary
            }
        },
        cornerRadius: 16,
        cellColor: Color(uiColor: .secondarySystemBackground),
        selectedColor: .white,
        tint: .purple
    )
}
