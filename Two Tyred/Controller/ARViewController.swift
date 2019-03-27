//
//  ARViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 10/11/2018.
//  Copyright © 2018 Michael Christie. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    
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
            
            configuration.maximumNumberOfTrackedImages = 3
        }
        
        // Run the view's session
        ARView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        ARView.session.pause()
    }
    
    /*func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor{
            
            let videoNode = SKVideoNode(fileNamed: "TwoTyred.mp4")
            
            videoNode.play()
            
            let videoScene = SKScene(size: CGSize(width: 1080, height:720 ))
            
            videoScene.addChild(videoNode)
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
            
            videoNode.yScale = -1.0
            
            plane.firstMaterial?.diffuse.contents = videoScene
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi/2
            
            node.addChildNode(planeNode)
            
            
        }
        
        return node
    }*/
    
    
    
   /* func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        //1. If Out Target Image Has Been Detected Than Get The Corresponding Anchor
        guard let currentImageAnchor = anchor as? ARImageAnchor else { return }
        
        //2. Store The ARImageAnchors
        anchors.append(currentImageAnchor)
        
        //3. Get The Targets Name
        let name = currentImageAnchor.referenceImage.name!
        
        print("Image Name = \(name)")
        
        //4. Increase The Count If The Reference Image Is Called Target
        if name == "Lady_Erin"{
            
            countOfDetectedImages += 1
            
            print("\(name) Has Been Detected \(countOfDetectedImages)")
            
            
            guard let refImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) else {
                fatalError("Missing expected asset catalog resources.")
            }
            
            // Create a session configuration
            let configuration = ARImageTrackingConfiguration()
            configuration.trackingImages = refImages
            configuration.maximumNumberOfTrackedImages = 1
            
            // Run the view's session
            ARView.session.run(configuration, options: ARSession.RunOptions(arrayLiteral: [.resetTracking, .removeExistingAnchors]))
        
            
        }
        
     
        }*/
    
        
    }
    
   
    
   
    
    

