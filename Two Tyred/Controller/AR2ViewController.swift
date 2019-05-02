//
//  AR2ViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 29/04/2019.
//  Copyright © 2019 Michael Christie. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class AR2ViewController: UIViewController, ARSCNViewDelegate {
    
    var anchors = [ARImageAnchor]()
    var countOfDetectedImages = 0
    let updateQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).serialSCNQueue")
    

    @IBOutlet weak var ARView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        ARView.delegate = self
        
        // Show statistics such as FPS and timing information (useful during development)
        ARView.showsStatistics = true
        
        // Enable environment-based lighting
        ARView.autoenablesDefaultLighting = true
        ARView.automaticallyUpdatesLighting = true
        // Set the view's delegate
        ARView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "TwoTyredImages", bundle: Bundle.main){
            configuration.trackingImages = trackedImages
            configuration.maximumNumberOfTrackedImages = 2
        }
        
        // Run the view's session
        ARView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        ARView.session.pause()
    }
}

