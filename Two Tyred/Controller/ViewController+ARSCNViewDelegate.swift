//
//  LoginViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 27/03/2018.
//  Copyright © 2018 Michael Christie. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


extension ARViewController {
    
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        //1. If Out Target Image Has Been Detected Than Get The Corresponding Anchor
        guard let currentImageAnchor = anchor as? ARImageAnchor else { return }
        
        //2. Store The ARImageAnchors
        anchors.append(currentImageAnchor)
        
        //3. Get The Targets Name
        let name = currentImageAnchor.referenceImage.name!
        
        print("Image Name = \(name)")
        
        if name == "wb_yeats_red"{
            
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            
            updateQueue.async {
                let physicalWidth = imageAnchor.referenceImage.physicalSize.width
                let physicalHeight = imageAnchor.referenceImage.physicalSize.height
                
                // Create a plane geometry to visualize the initial position of the detected image
                let mainPlane = SCNPlane(width: physicalWidth, height: physicalHeight)
                mainPlane.firstMaterial?.colorBufferWriteMask = .alpha
                
                // Create a SceneKit root node with the plane geometry to attach to the scene graph
                // This node will hold the virtual UI in place
                let mainNode = SCNNode(geometry: mainPlane)
                mainNode.eulerAngles.x = -.pi / 2
                mainNode.renderingOrder = -1
                mainNode.opacity = 1
                
                // Add the plane visualization to the scene
                node.addChildNode(mainNode)
                
                // Perform a quick animation to visualize the plane on which the image was detected.
                // We want to let our users know that the app is responding to the tracked image.
                self.highlightDetection(on: mainNode, width: physicalWidth, height: physicalHeight, completionHandler: {
                    
                    // Introduce virtual content
                    self.displayDetailView(on: mainNode, xOffset: physicalWidth)
                    
                    // Animate the WebView to the right
                    self.displayWebView(on: mainNode, xOffset: physicalWidth)
                    
                })
            }
        }
            
        else if name == "it_sligo" {
            
            if let imageAnchor = anchor as? ARImageAnchor{
                
                //let videoNode = SKVideoNode(fileNamed: "TwoTyred.mp4")
                
                let videoNode = SKVideoNode(url: URL(fileURLWithPath: "https://s3-eu-west-1.amazonaws.com/twotyred/IMG_7245.MOV"))
                
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
            
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // MARK: - SceneKit Helpers
    func displayDetailView(on rootNode: SCNNode, xOffset: CGFloat) {
        
        let detailPlane = SCNPlane(width: xOffset, height: xOffset * 1.4)
        detailPlane.cornerRadius = 0.25
        
        let detailNode = SCNNode(geometry: detailPlane)
        detailNode.geometry?.firstMaterial?.diffuse.contents = SKScene(fileNamed: "DetailScene")
        
        let image = UIImage(named: "wb_real")
        let node = SCNNode(geometry: SCNPlane(width: 4, height: 2))
        node.geometry?.firstMaterial?.diffuse.contents = image
        
        detailNode.addChildNode(node)
        
        // Due to the origin of the iOS coordinate system, SCNMaterial's content appears upside down, so flip the y-axis.
        detailNode.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        detailNode.position.z -= 0.5
        detailNode.opacity = 0
        
        
        rootNode.addChildNode(detailNode)
        detailNode.runAction(.sequence([
            .wait(duration: 1.0),
            .fadeOpacity(to: 1.0, duration: 1.5),
            .moveBy(x: xOffset * -1.1, y: 0, z: -0.05, duration: 1.5),
            .moveBy(x: 0, y: 0, z: -0.05, duration: 0.2)
            ])
        )
        
    }
    
    func displayWebView(on rootNode: SCNNode, xOffset: CGFloat) {
        // Xcode yells at us about the deprecation of UIWebView in iOS 12.0, but there is currently
        // a bug that does now allow us to use a WKWebView as a texture for our webViewNode
        // Note that UIWebViews should only be instantiated on the main thread!
        DispatchQueue.main.async {
    
            let request = URLRequest(url: URL(string: "https://www.yeatssociety.com/")!)
            let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 400, height: 672))
            webView.loadRequest(request)
            
            let webViewPlane = SCNPlane(width: xOffset, height: xOffset * 1.4)
            webViewPlane.cornerRadius = 0.25
            
            let webViewNode = SCNNode(geometry: webViewPlane)
            webViewNode.geometry?.firstMaterial?.diffuse.contents = webView
            webViewNode.position.z -= 0.5
            webViewNode.opacity = 0
            
            rootNode.addChildNode(webViewNode)
            webViewNode.runAction(.sequence([
                .wait(duration: 3.0),
                .fadeOpacity(to: 1.0, duration: 1.5),
                .moveBy(x: xOffset * 1.1, y: 0, z: -0.05, duration: 1.5),
                .moveBy(x: 0, y: 0, z: -0.05, duration: 0.2)
                ])
            )
        }
    }
    
    func highlightDetection(on rootNode: SCNNode, width: CGFloat, height: CGFloat, completionHandler block: @escaping (() -> Void)) {
        let planeNode = SCNNode(geometry: SCNPlane(width: width, height: height))
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        planeNode.position.z += 0.1
        planeNode.opacity = 0
        
        rootNode.addChildNode(planeNode)
        planeNode.runAction(self.imageHighlightAction) {
            block()
        }
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
}

