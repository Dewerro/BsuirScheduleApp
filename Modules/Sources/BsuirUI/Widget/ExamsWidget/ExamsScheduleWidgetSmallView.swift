import SwiftUI
import BsuirCore
import ScheduleCore

public struct ExamsScheduleWidgetSmallView: View {
    var config: ExamsScheduleWidgetConfiguration

    @Environment(\.widgetRenderingMode) var renderingMode
    @Environment(\.showsWidgetContainerBackground) var showsWidgetBackground

    public init(config: ExamsScheduleWidgetConfiguration) {
        self.config = config
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ExamsScheduleWidgetHeader(
                config: config,
                showMainDate: false,
                showBackground: hasBackground
            )

            switch config.content {
            case .noPinned:
                NoPinnedScheduleView()
                    .padding(.horizontal)
            case .noSchedule:
                NoScheduleView()
                    .padding(.horizontal)
            case .exams(days: []):
                NoPairsView()
                    .padding(.horizontal)
            case .exams(let days):
                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 0) {
                    let exams = ExamsToDisplay(
                        days: days,
                        maxVisiblePairsCount: 1
                    )

                    ForEach(exams.visible, id: \.pair.id) { (date, pair) in
                        LabeledContent {
                            PairView(
                                pair: pair,
                                distribution: .vertical,
                                isCompact: showsWidgetBackground,
                                spellForm: renderingMode == .vibrant,
                                showWeeks: false
                            )
                        } label: {
                            if let date {
                                Text(date.formatted(.compactExamDay))
                            }
                        }
                    }

                    Spacer(minLength: 0)

                    RemainingScheduleView(
                        subjects: exams.upcomingInvisible.compactMap(\.pair.subject),
                        visibleCount: 1
                    )
                }
                .padding(.leading, hasBackground ? 12 : 4)
                .padding(.trailing, hasBackground ? 4 : 0)
                .padding(.bottom, hasBackground ? 10 : 4)
            }
        }
        .labeledContentStyle(.mainExamsSection)
        .widgetBackground(Color(uiColor: .systemBackground))
    }

    private var hasBackground: Bool {
        renderingMode == .fullColor && showsWidgetBackground
    }
}
