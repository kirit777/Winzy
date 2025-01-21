//
//  MediaGalleryScreen.swift
//  Winzy
//
//  Created by HKinfoway Tech. on 27/12/24.
//

import SwiftUI

struct MediaGalleryScreen: View {
    @State private var selectedFilter: String = "Images"
    @State private var mediaItems = [
        MediaItem(type: "Image", name: "Beach.jpg", url: "image_url_1"),
        MediaItem(type: "Video", name: "Vacation.mp4", url: "video_url_1"),
        MediaItem(type: "Audio", name: "Song.mp3", url: "audio_url_1"),
        MediaItem(type: "Image", name: "Sunset.jpg", url: "image_url_2"),
        MediaItem(type: "Video", name: "Trip.mp4", url: "video_url_2")
    ]
    
    var filteredItems: [MediaItem] {
        mediaItems.filter { item in
            selectedFilter == "All" || item.type == selectedFilter
        }
    }
    
    var body: some View {
        ZStack {
            // Background with gradient theme
//            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.pink]), startPoint: .top, endPoint: .bottom)
//                .edgesIgnoringSafeArea(.all)
            
            GradientBackgroundView()
            
            FloatingShapes()

            
            VStack {
                // Navigation Bar
                HStack {
                    Button(action: {
                        // Back action
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Media Gallery")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        // More options or settings
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                // Filter Options
                HStack {
                    FilterButton(title: "All", selectedFilter: $selectedFilter)
                    FilterButton(title: "Images", selectedFilter: $selectedFilter)
                    FilterButton(title: "Videos", selectedFilter: $selectedFilter)
                    FilterButton(title: "Audio", selectedFilter: $selectedFilter)
                }
                .padding(.top, 10)
                
                // Media Gallery Grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(filteredItems, id: \.name) { item in
                            MediaItemView(mediaItem: item)
                        }
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            
            // Floating action buttons for download and share options
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Share media
                    }) {
                        Image(systemName: "square.and.arrow.up.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 20)
                    
                    Button(action: {
                        // Download media
                    }) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct MediaItem: Identifiable {
    var id = UUID()
    var type: String
    var name: String
    var url: String
}

struct MediaItemView: View {
    var mediaItem: MediaItem
    
    var body: some View {
        VStack {
            // Image or video thumbnail (Placeholder for demo)
            if mediaItem.type == "Image" {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else if mediaItem.type == "Video" {
                Image(systemName: "video.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else if mediaItem.type == "Audio" {
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
                    .padding()
                    .background(Color.white.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            // Media Item Name
            Text(mediaItem.name)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.top, 5)
        }
        .frame(width: 140, height: 150)
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 10)
    }
}

struct FilterButton: View {
    var title: String
    @Binding var selectedFilter: String
    
    var body: some View {
        Button(action: {
            selectedFilter = title
        }) {
            Text(title)
                .fontWeight(.bold)
                .padding(10)
                .background(selectedFilter == title ? Color.white : Color.gray.opacity(0.3))
                .foregroundColor(selectedFilter == title ? Color.black : Color.white)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
        .padding(.horizontal)
    }
}

struct MediaGalleryScreen_Previews: PreviewProvider {
    static var previews: some View {
        MediaGalleryScreen()
    }
}
