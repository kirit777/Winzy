//
//  Untitled.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 06/01/25.
//

import Foundation
import Photos
import AVFoundation
import UIKit
import Contacts

// Enum for various permission types
enum PermissionType {
    case photoLibrary
    case camera
    case microphone
    case videoRecording
    case contacts
}

class PermissionsHelper {
    
    // Static function to request permissions
    static func requestPermission(for type: PermissionType, completion: @escaping (Bool) -> Void) {
        switch type {
        case .photoLibrary:
            requestPhotoLibraryPermission(completion: completion)
        case .camera:
            requestCameraPermission(completion: completion)
        case .microphone:
            requestMicrophonePermission(completion: completion)
        case .videoRecording:
            requestVideoRecordingPermission(completion: completion)
        case .contacts:
            requestContactsPermission(completion: completion)
        }
    }
    
    // Request Photo Library Permission
    private static func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                completion(true)
            case .denied, .restricted:
                completion(false)
            case .notDetermined:
                completion(false) // Or handle accordingly
            @unknown default:
                completion(false)
            }
        }
    }
    
    // Request Camera Permission
    private static func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { response in
            completion(response)
        }
    }
    
    // Request Microphone Permission
    private static func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { response in
            completion(response)
        }
    }
    
    // Request Video Recording Permission
    private static func requestVideoRecordingPermission(completion: @escaping (Bool) -> Void) {
        // Video recording requires camera and microphone permission, so we request both
        requestCameraPermission { cameraGranted in
            if cameraGranted {
                requestMicrophonePermission { microphoneGranted in
                    completion(microphoneGranted)
                }
            } else {
                completion(false)
            }
        }
    }
    
    // Request Contacts Permission
    private static func requestContactsPermission(completion: @escaping (Bool) -> Void) {
        CNContactStore().requestAccess(for: .contacts) { granted, error in
            completion(granted)
        }
    }
}
