//
//  ImagePicker.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 06/01/25.
//

import SwiftUI
import PhotosUI
import UIKit


// Custom view to wrap PHPickerViewController
struct MediaPickerViewChat: View {
    @Binding var selectedMedia: [MediaItem]

    var body: some View {
        VStack {
            // Placeholder for the picker
            MediaPickerControllerView(selectedMedia: $selectedMedia)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MediaPickerControllerView: UIViewControllerRepresentable {
    @Binding var selectedMedia: [MediaItem]
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: MediaPickerControllerView
        
        init(parent: MediaPickerControllerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            var mediaItems: [MediaItem] = []
            
            let dispatchGroup = DispatchGroup()
            
            for result in results {
                dispatchGroup.enter()
                
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                    if let url = url {
                        // Video selected
                        let mediaItem = MediaItem(type: "video", name: url.lastPathComponent, url: url.path)
                        mediaItems.append(mediaItem)
                    } else {
                        result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                            if let image = image as? UIImage {
                                // Image selected
                                let imageURL = self.saveImageToTemporaryDirectory(image)
                                let mediaItem = MediaItem(type: "image", name: imageURL.lastPathComponent, url: imageURL.path)
                                mediaItems.append(mediaItem)
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.parent.selectedMedia = mediaItems
            }
            
            picker.dismiss(animated: true)
        }
        
        func pickerDidCancel(_ picker: PHPickerViewController) {
            picker.dismiss(animated: true)
        }
        
        // Function to save image to a temporary URL
        func saveImageToTemporaryDirectory(_ image: UIImage) -> URL {
            let data = image.jpegData(compressionQuality: 1.0)!
            let tempDirectory = FileManager.default.temporaryDirectory
            let tempURL = tempDirectory.appendingPathComponent(UUID().uuidString + ".jpg")
            try? data.write(to: tempURL)
            return tempURL
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0 // 0 means no limit on selection
        configuration.filter = .any(of: [.images, .videos]) // Allow both images and videos
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}


