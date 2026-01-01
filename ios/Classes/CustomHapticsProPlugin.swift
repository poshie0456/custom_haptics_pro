import Flutter
import UIKit
import CoreHaptics

public class CustomHapticsProPlugin: NSObject, FlutterPlugin {
    private var hapticEngine: CHHapticEngine?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "custom_haptics_pro", binaryMessenger: registrar.messenger())
        let instance = CustomHapticsProPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)

        case "supportsHaptics":
            result(CHHapticEngine.capabilitiesForHardware().supportsHaptics)

        case "startEngine":
            startEngine(result: result)

        case "stopEngine":
            stopEngine(result: result)

        case "playPatternFromJson":
            guard let args = call.arguments as? [String: Any],
                  let jsonString = args["json"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS",
                                  message: "JSON string required",
                                  details: nil))
                return
            }
            playPatternFromJson(jsonString: jsonString, result: result)

        case "currentTime":
            if let engine = hapticEngine {
                result(engine.currentTime)
            } else {
                result(0.0)
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Engine Management

    private func startEngine(result: @escaping FlutterResult) {
        // Check if device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            result(FlutterError(code: "UNSUPPORTED",
                              message: "Device does not support haptics",
                              details: nil))
            return
        }

        do {
            // Create haptic engine if it doesn't exist
            if hapticEngine == nil {
                hapticEngine = try CHHapticEngine()

                // Set up engine stopped handler
                hapticEngine?.stoppedHandler = { [weak self] reason in
                    print("Haptic engine stopped: \(reason)")
                    // Try to restart the engine
                    self?.restartEngine()
                }

                // Set up engine reset handler
                hapticEngine?.resetHandler = { [weak self] in
                    print("Haptic engine reset")
                    self?.restartEngine()
                }
            }

            // Start the engine
            try hapticEngine?.start()
            result(nil)
        } catch {
            result(FlutterError(code: "ENGINE_ERROR",
                              message: "Failed to start haptic engine: \(error.localizedDescription)",
                              details: nil))
        }
    }

    private func stopEngine(result: @escaping FlutterResult) {
        hapticEngine?.stop(completionHandler: { error in
            if let error = error {
                result(FlutterError(code: "ENGINE_ERROR",
                                  message: "Failed to stop haptic engine: \(error.localizedDescription)",
                                  details: nil))
            } else {
                result(nil)
            }
        })
    }

    private func restartEngine() {
        do {
            try hapticEngine?.start()
        } catch {
            print("Failed to restart haptic engine: \(error)")
        }
    }

    // MARK: - Pattern Playback

    private func playPatternFromJson(jsonString: String, result: @escaping FlutterResult) {
        // Ensure engine is started
        if hapticEngine == nil {
            startEngine { [weak self] engineResult in
                if engineResult is FlutterError {
                    result(engineResult)
                    return
                }
                self?.playPatternFromJson(jsonString: jsonString, result: result)
            }
            return
        }

        do {
            // Parse JSON
            guard let jsonData = jsonString.data(using: .utf8),
                  let patternDict = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                  let pattern = patternDict["Pattern"] as? [[String: Any]] else {
                result(FlutterError(code: "INVALID_JSON",
                                  message: "Invalid pattern JSON format",
                                  details: nil))
                return
            }

            // Convert to CHHapticEvent array
            var events: [CHHapticEvent] = []

            for eventDict in pattern {
                guard let eventType = eventDict["EventType"] as? String,
                      let time = eventDict["Time"] as? Double,
                      let parameters = eventDict["EventParameters"] as? [[String: Any]] else {
                    continue
                }

                // Extract parameters
                var intensity: Float = 1.0
                var sharpness: Float = 0.5

                for param in parameters {
                    if let paramID = param["ParameterID"] as? String,
                       let paramValue = param["ParameterValue"] as? Double {
                        if paramID == "HapticIntensity" {
                            intensity = Float(paramValue)
                        } else if paramID == "HapticSharpness" {
                            sharpness = Float(paramValue)
                        }
                    }
                }

                // Create haptic event
                if eventType == "HapticTransient" {
                    let event = CHHapticEvent(
                        eventType: .hapticTransient,
                        parameters: [
                            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                        ],
                        relativeTime: time
                    )
                    events.append(event)
                } else if eventType == "HapticContinuous" {
                    let duration = eventDict["EventDuration"] as? Double ?? 1.0
                    let event = CHHapticEvent(
                        eventType: .hapticContinuous,
                        parameters: [
                            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                        ],
                        relativeTime: time,
                        duration: duration
                    )
                    events.append(event)
                }
            }

            // Create and play pattern
            let hapticPattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: hapticPattern)
            try player?.start(atTime: CHHapticTimeImmediate)

            result(nil)
        } catch {
            result(FlutterError(code: "PLAYBACK_ERROR",
                              message: "Failed to play haptic pattern: \(error.localizedDescription)",
                              details: nil))
        }
    }
}
