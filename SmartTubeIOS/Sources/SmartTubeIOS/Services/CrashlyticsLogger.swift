import Foundation
import os
import SmartTubeIOSCore

/// Logs to `os.Logger`.
/// Crash reporting is intentionally disabled; this type preserves the existing
/// call sites without linking runtime behavior to Firebase.
struct CrashlyticsLogger: Sendable {
    private let logger: Logger
    private let category: String

    init(subsystem: String = appSubsystem, category: String) {
        logger = Logger(subsystem: subsystem, category: category)
        self.category = category
    }

    func notice(_ message: @autoclosure () -> String) {
        let msg = message()
        logger.notice("\(msg, privacy: .public)")
    }

    func error(_ message: @autoclosure () -> String) {
        let msg = message()
        logger.error("\(msg, privacy: .public)")
    }

    func debug(_ message: @autoclosure () -> String) {
        let msg = message()
        logger.debug("\(msg, privacy: .public)")
        // Not forwarded — too verbose for crash reports
    }

    /// Records a non-fatal-style error locally with additional key-value context.
    func recordNonFatal(_ error: Error, userInfo: [String: String] = [:]) {
        let nsError = error as NSError
        let msg = "[\(category)] \(nsError.domain)(\(nsError.code)): \(nsError.localizedDescription)"
        logger.error("\(msg, privacy: .public)")
        for (key, value) in userInfo {
            logger.error("\(key, privacy: .public)=\(value, privacy: .public)")
        }
    }

    /// Preserved as a no-op while crash reporting is disabled.
    static func setVideoContext(id: String, title: String) {
    }

    /// Preserved as a no-op while crash reporting is disabled.
    static func sendDiagnosticReport() {
    }
}
