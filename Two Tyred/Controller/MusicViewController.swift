//
//  MusicViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 08/11/2018.
//  Copyright © 2018 Michael Christie. All rights reserved.
//

import UIKit
import MediaPlayer

class MusicViewController: UIViewController, MPMediaPickerControllerDelegate {

    let mediaPlayer : MPMusicPlayerController = MPMusicPlayerController.applicationMusicPlayer
    
    
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    
    
    @IBOutlet weak var playPause: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let item = mediaPlayer.nowPlayingItem{
            if let AlbumImage = item.artwork?.image(at: CGSize(width: 100, height: 100)){
                albumArt.image = AlbumImage
                
                if let AlbumTitle = item.artist{
                    artistName.text = AlbumTitle
                }
            }
        }
    }
    
    
    @IBAction func choose(_ sender: Any) {
        let mediapicker = MPMediaPickerController(mediaTypes: .music)
        
        mediapicker.allowsPickingMultipleItems = false
        mediapicker.popoverPresentationController?.sourceView = view
        mediapicker.delegate = self
        present(mediapicker, animated: true, completion:nil)
        
    }
   
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        for item in mediaItemCollection.items{
            if let AlbumImage = item.artwork?.image(at: CGSize(width: 100, height: 100)){
                albumArt.image = AlbumImage
                
                if let AlbumTitle = item.artist{
                    artistName.text = AlbumTitle
                    playPause.setTitle("Pause", for: .normal)
                }
            }
        }
        mediaPicker.dismiss(animated: true, completion: nil)
        mediaPlayer.setQueue(with: mediaItemCollection)
        mediaPlayer.play()
    }
    
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func playPause(_ sender: Any) {
        print("HEHE")
        if mediaPlayer.playbackState == .playing{
            mediaPlayer.pause()
            playPause.setTitle("Play", for: .normal)
        }
        else{
            mediaPlayer.play()
            playPause.setTitle("Pause", for: .normal)
            
        }
    }
    
    
  
}





