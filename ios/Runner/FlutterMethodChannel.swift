////
////  FlutterMethodChannel.swift
////  Runner
////
////  Created by 순형 on 3/25/25.
////
//import Flutter
//
//class FlutterMethodChannel {
//    let flutterChannelName = "com.koreanhole.pluto.dropspot.flutterChannel"
//    let flutterMethodName = "com.koreanhole.pluto.dropspot.methodName"
//    
//    func callFlutterMethod(arguments: [String: Any]?) async throws -> [String: Any] {
//        guard let appDelegate = await UIApplication.shared.delegate as? AppDelegate else {
//            throw NSError(domain: "MyAppError", code: 1, userInfo: [NSLocalizedDescriptionKey: "AppDelegate를 찾을 수 없습니다."])
//        }
//        
//        
//        return try await withCheckedThrowingContinuation { continuation in
//            DispatchQueue.main.async {
//                let flutterEngine = appDelegate.flutterEngine
//                let channel = FlutterMethodChannel(name: flutterChannelName, binaryMessenger: flutterEngine.binaryMessenger)
//                channel.invokeMethod(flutterMethodName, arguments: arguments) { result in
//                    if let flutterError = result as? FlutterError {
//                        let nsError = NSError(
//                            domain: flutterError.code,
//                            code: 1,
//                            userInfo: [
//                                NSLocalizedDescriptionKey: flutterError.message ?? "Flutter error",
//                                "details": flutterError.details ?? ""
//                            ]
//                        )
//                        continuation.resume(throwing: nsError)
//                    } else if let error = result as? Error {
//                        continuation.resume(throwing: error)
//                    } else if let jsonResult = result as? [String: Any] {
//                        continuation.resume(returning: jsonResult)
//                    } else {
//                        continuation.resume(throwing: NSError(domain: "MyAppError", code: 2, userInfo: [NSLocalizedDescriptionKey: "결과가 JSON 형식이 아닙니다."]))
//                    }
//                }
//            }
//        }
//    }
//}
