//
//  Player.swift
//  MovieList
//
//  Created by Negar Moshtaghi on 8/22/24.
//

import Foundation
import AVFoundation

class HLSAudioStreamer {

    private var player: AVPlayer?

    // Initialize the streamer with a HLS URL
    init(url: URL) {
        setupPlayer(with: url)
    }

    // Set up the AVPlayer with the provided URL
    private func setupPlayer(with url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
    }

    // Start the audio stream
    func play() {
        player?.play()
    }

    // Pause the audio stream
    func pause() {
        player?.pause()
    }

    // Stop the audio stream
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }

    // Check if the audio is currently playing
    var isPlaying: Bool {
        return player?.timeControlStatus == .playing
    }

    // Deinitialize the player
    deinit {
        player?.pause()
        player = nil
    }
}
