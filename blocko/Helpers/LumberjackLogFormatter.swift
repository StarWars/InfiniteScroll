import CocoaLumberjack

@objcMembers
class LumberjackLogFormatter: NSObject, DDLogFormatter {
    func format(message logMessage: DDLogMessage) -> String? {
        var level = "[UNKNOWN]"
        let time = logMessage.timestamp.timeIntervalSince1970.timestampToString(format: DateFormatString.hhmmss)

        switch logMessage.flag {
        case .debug:
            level = "[💚][DBG]\t"
        case .error:
            level = "[💔][ERR]\t"
        case .info:
            level = "[🖤][INF]\t"
        case .verbose:
            level = "[💚][VRB]\t"
        case .warning:
            level = "[💛][WRN]\t"
        default:
            level = "[💚][LOG]\t"
        }

        if logMessage.level == .off {
            return nil
        } else {
            return "[dxc](\(time)) \(level) \(logMessage.message)"
        }
    }
}
