import Foundation
import SwiftData

@Model
class UserProgress {
    var currentQuestion: Int
    var hearts: Int
    var skips: Int
    var hasSeenIntroVideos: Bool

    init(currentQuestion: Int = 0, hearts: Int = 3, skips: Int = 3, hasSeenIntroVideos: Bool = false) {
        self.currentQuestion = currentQuestion
        self.hearts = hearts
        self.skips = skips
        self.hasSeenIntroVideos = hasSeenIntroVideos
    }
} 