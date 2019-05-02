//
//  ViewController.swift
//  720Synth
//
//  Created by callum strange on 23/02/2019.
//  Copyright © 2019 callum strange. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI
import ARKit
import SceneKit

class ViewController: UIViewController{
  
    var conductor = Conductor.sharedInstance
    
    
    // Create Scene nodes
    
    let vcoOneIndex = SCNBox()
    let vcoTwoIndex = SCNBox()
    let vcoOneIndexBox = SCNNode()
    let vcoTwoIndexBox = SCNNode()
    let detuneBox = SCNBox()
    let detuneBoxNode = SCNNode()
    let fmVol = SCNBox()
    let fmVolNode = SCNNode()
    let fmMod = SCNBox()
    let fmModNode = SCNNode()
    let delayTime = SCNBox()
    let delayFb = SCNBox()
    let delayMix = SCNBox()
    let delayTimeNode = SCNNode()
    let delayFbNode = SCNNode()
    let delayMixNode = SCNNode()
    let box = SCNBox()
    let box2 = SCNBox()
    let box3 = SCNBox()
    let box4 = SCNBox()
    var boxNode = SCNNode()
    var boxNode2 = SCNNode()
    var boxNode3 = SCNNode()
    var boxNode4 = SCNNode()
    var reverbCutOff = SCNBox()
    var reverbFeedback = SCNBox()
    var rcoBox = SCNNode()
    var rfbBox = SCNNode()
    
    // Storyboard Outlets
    
    @IBOutlet weak var ArkitView: ARSCNView!
    @IBOutlet weak var StartStop: UILabel!
    // Create colours and SCNMaterials
    
    var greenThree = UIColor.init(red: 0.69, green: 1.21, blue: 0.47, alpha: 1)
    let amber = UIColor.init(red: 2.03, green: 1.50, blue: 0, alpha: 1)
    let red = UIColor.init(red: 1.94, green: 0.36, blue: 0.36, alpha: 1)
    let teal = UIColor.init(red: 0, green: 1.83, blue: 1.45, alpha: 1)
    let purple = UIColor.init(red: 0.98, green: 0.21, blue: 1.73, alpha: 1)
    let pink = UIColor.init(red: 2.03, green: 0.32, blue: 1.47, alpha: 1)
    
    let ampMaterialOne = SCNMaterial()
    let ampMaterialTwo = SCNMaterial()
    let ampMaterialThree = SCNMaterial()
    let ampMaterialFour = SCNMaterial()
    let material2 = SCNMaterial()
    let material3 = SCNMaterial()
    let material4 = SCNMaterial()
    let material5 = SCNMaterial()
    let material6 = SCNMaterial()
    
    // Keyboard variables
    
    var midiNotesHeld = [MIDINoteNumber]()
    var keyboardOctavePosition: Int = 0
    let blackKeys = [49, 51, 54, 56, 58, 61, 63, 66, 68, 70]
    var monoMode: Bool = false
    var lastKey: UIButton?
    var holdMode: Bool = false
    
    // Create SCNNodes for text labels
    
    let node = SCNNode()
    let node2 = SCNNode()
    let node3 = SCNNode()
    let node4 = SCNNode()
    let node5 = SCNNode()
    let node6 = SCNNode()
    let node7 = SCNNode()
    let node8 = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setup Text Labels
        
        let title = SCNText(string: "amp envelope", extrusionDepth: 1)
        title.materials = [material2]
        node.position = SCNVector3(x: 0.02, y: 0.16, z: -0.2)
        node.scale = SCNVector3(x: 0.001, y: 0.001, z: 0.001)
        node.geometry = title
        
        let rvbTitle = SCNText(string: "Reverb", extrusionDepth: 1)
        rvbTitle.materials = [material2]
        node2.position = SCNVector3(0.30, 0.16, -0.10)
        node2.scale = SCNVector3(x: 0.001, y: 0.001, z: 0.001)
        node2.eulerAngles = SCNVector3(0, -0.8, 0)
        node2.geometry = rvbTitle
        
        let indexTitle = SCNText(string: "Index", extrusionDepth: 1)
        indexTitle.materials = [material2]
        node3.position = SCNVector3(0.45, 0.16, 0.09)
        node3.scale = SCNVector3(x: 0.001, y: 0.001, z: 0.001)
        node3.eulerAngles = SCNVector3(0, -1.5, 0)
        node3.geometry = indexTitle

        let indexSubOne = SCNText(string: "vco 1", extrusionDepth: 1)
        indexSubOne.materials = [material2]
        node4.position = SCNVector3(0.45, 0.14, 0.09)
        node4.scale = SCNVector3(x: 0.001, y: 0.001, z: 0.001)
        node4.eulerAngles = SCNVector3(0, -1.5, 0)
        node4.geometry = indexSubOne
        
        let indexSubTwo = SCNText(string: "vco 2", extrusionDepth: 1)
        indexSubTwo.materials = [material2]
        node5.position = SCNVector3(0.45, 0.14, 0.2)
        node5.scale = SCNVector3(x: 0.001, y: 0.001, z: 0.001)
        node5.eulerAngles = SCNVector3(0, -1.5, 0)
        node5.geometry = indexSubTwo
        
        let detuneTitle = SCNText(string: "Detune", extrusionDepth: 1)
        detuneTitle.materials = [material2]
        node6.position = SCNVector3(-0.25, 0.16, -0.10)
        node6.scale = SCNVector3(x: 0.001, y: 0.001, z: 0.001)
        node6.eulerAngles = SCNVector3(0, 0.8, 0)
        node6.geometry = detuneTitle
        
        let fmTitle = SCNText(string: "Fm mod", extrusionDepth: 1)
        fmTitle.materials = [material2]
        node7.position = SCNVector3(-0.25, 0.16, 0.2)
        node7.scale = SCNVector3(x: 0.001, y: 0.001, z: 0.001)
        node7.eulerAngles = SCNVector3(0, 1.5, 0)
        node7.geometry = fmTitle
        
        let delayTitle = SCNText(string: "Delay", extrusionDepth: 1)
        delayTitle.materials = [material2]
        node8.position = SCNVector3(-0.20, 0.16, 0.5)
        node8.scale = SCNVector3(x: 0.001, y: 0.001, z: 0.001)
        node8.eulerAngles = SCNVector3(0, 1.5, 0)
        node8.geometry = delayTitle
        
        
        // Apply Colours to materials
       
        ampMaterialOne.diffuse.contents = greenThree
        ampMaterialTwo.diffuse.contents = greenThree
        ampMaterialThree.diffuse.contents = greenThree
        ampMaterialFour.diffuse.contents = greenThree
        material2.diffuse.contents = amber
        material3.diffuse.contents = red
        material4.diffuse.contents = teal
        material5.diffuse.contents = purple
        material6.diffuse.contents = pink

        // Setup initial Scene nodes dimensions
        
        box.chamferRadius = 0
        box.width = 0.05
        box.height = 0.05
        box.length = 0.05
        boxNode = SCNNode()
        boxNode.geometry = box
        
        box2.chamferRadius = 0
        box2.width = 0.05
        box2.height = 0.05
        box2.length = 0.05
        boxNode2 = SCNNode()
        boxNode2.geometry = box2

        box3.chamferRadius = 0
        box3.width = 0.05
        box3.height = 0.05
        box3.length = 0.05
        boxNode3 = SCNNode()
        boxNode3.geometry = box3
      
        box4.chamferRadius = 0
        box4.width = 0.05
        box4.height = 0.05
        box4.length = 0.05
        boxNode4 = SCNNode()
        boxNode4.geometry = box4
        
        reverbCutOff.chamferRadius = 0
        reverbCutOff.width = 0.05
        reverbCutOff.height = 0.05
        reverbCutOff.length = 0.05
        rcoBox = SCNNode()
        rcoBox.geometry = reverbFeedback
       
        reverbFeedback.chamferRadius = 0
        reverbFeedback.width = 0.05
        reverbFeedback.height = 0.05
        reverbFeedback.length = 0.05
        rfbBox = SCNNode()
        rfbBox.geometry = reverbFeedback
        
        vcoOneIndex.chamferRadius = 0
        vcoOneIndex.width = 0.05
        vcoOneIndex.height = 0.05
        vcoOneIndex.length = 0.05
        vcoOneIndexBox.geometry = vcoOneIndex
        
        vcoTwoIndex.chamferRadius = 0
        vcoTwoIndex.width = 0.05
        vcoTwoIndex.height = 0.05
        vcoTwoIndex.length = 0.05
        vcoTwoIndexBox.geometry = vcoTwoIndex
        
        detuneBox.chamferRadius = 0
        detuneBox.width = 0.05
        detuneBox.height = 0.05
        detuneBox.length = 0.05
        detuneBoxNode.geometry = detuneBox
        
        fmMod.chamferRadius = 0
        fmMod.width = 0.05
        fmMod.height = 0.05
        fmMod.length = 0.05
        fmModNode.geometry = fmMod
        
        fmVol.chamferRadius = 0
        fmVol.width = 0.05
        fmVol.height = 0.05
        fmVol.length = 0.05
        fmVolNode.geometry = fmVol
        
        delayTime.chamferRadius = 0
        delayTime.width = 0.05
        delayTime.height = 0.05
        delayTime.length = 0.05
        delayTimeNode.geometry = delayTime
        
        delayFb.chamferRadius = 0
        delayFb.width = 0.05
        delayFb.height = 0.05
        delayFb.length = 0.05
        delayFbNode.geometry = delayFb
        
        delayMix.chamferRadius = 0
        delayMix.width = 0.05
        delayMix.height = 0.05
        delayMix.length = 0.05
        delayMixNode.geometry = delayMix
        
        boxNode.geometry?.materials = [ampMaterialOne]
        boxNode2.geometry?.materials = [ampMaterialTwo]
        boxNode3.geometry?.materials = [ampMaterialThree]
        boxNode4.geometry?.materials = [ampMaterialFour]
        rfbBox.geometry?.materials = [material2]
        rcoBox.geometry?.materials = [material2]
        vcoOneIndexBox.geometry?.materials = [material3]
        vcoTwoIndexBox.geometry?.materials = [material3]
        detuneBoxNode.geometry?.materials = [material4]
        fmModNode.geometry?.materials = [material5]
        fmVolNode.geometry?.materials = [material5]
        delayFbNode.geometry?.materials = [material6]
        delayTimeNode.geometry?.materials = [material6]
        delayMixNode.geometry?.materials = [material6]

        boxNode.position=SCNVector3(0.05, 0.1, -0.2)
        boxNode2.position = SCNVector3(0.05, 0, -0.2)
        boxNode3.position = SCNVector3(0.15, 0.1, -0.2)
        boxNode4.position = SCNVector3(0.15, 0, -0.2)
        rcoBox.position = SCNVector3(0.40, 0.1, -0.05)
        rcoBox.eulerAngles = SCNVector3(0, -0.8, 0)
        rfbBox.position = SCNVector3(0.35, 0.1, -0.10)
        rfbBox.eulerAngles = SCNVector3(0, -0.8, 0)
        vcoOneIndexBox.position = SCNVector3(0.45, 0.1, 0.1)
        vcoOneIndexBox.eulerAngles = SCNVector3(0, -1.5, 0)
        vcoTwoIndexBox.position = SCNVector3(0.45, 0.1, 0.2)
        vcoTwoIndexBox.eulerAngles = SCNVector3(0, -1.5, 0)
        detuneBoxNode.position  = SCNVector3(-0.20, 0.1, -0.10)
        detuneBoxNode.eulerAngles = SCNVector3(0, 0.8, 0)
        fmVolNode.position = SCNVector3(-0.25, 0.1, 0.1)
        fmVolNode.eulerAngles = SCNVector3(0, 1.5, 0)
        fmModNode.position = SCNVector3(-0.25, 0.1, 0.2)
        fmModNode.eulerAngles = SCNVector3(0, 1.5, 0)
        delayTimeNode.position = SCNVector3(-0.20, 0.1, 0.4)
        delayTimeNode.eulerAngles = SCNVector3(0, 1.5, 0)
        delayFbNode.position = SCNVector3(-0.20, 0.1, 0.5)
        delayFbNode.eulerAngles = SCNVector3(0, 1.5, 0)
        delayMixNode.position = SCNVector3(-0.20, 0, 0.5)
        delayMixNode.eulerAngles = SCNVector3(0, 1.5, 0)
   
 
    conductor.masterVolume.volume = 0
    conductor.fatten.dryWetMix.balance = 0.9
        
    addPinchGestureToSceneView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
     
        ArkitView.autoenablesDefaultLighting = true
       // configuration.planeDetection = .horizontal
        ArkitView.session.run(configuration)
        ArkitView.delegate = self
       //ArkitView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        ArkitView.automaticallyUpdatesLighting = true
   
    }

    // Function to create the nodes and start the synthesiser/ Remove nodes and stop the synth
    
    @IBAction func startSynth(_ sender: UIButton) {
        if sender.isSelected == false {
            
            sender.isSelected = true
            
            ArkitView.scene.rootNode.addChildNode(boxNode)
            ArkitView.scene.rootNode.addChildNode(boxNode2)
            ArkitView.scene.rootNode.addChildNode(boxNode3)
            ArkitView.scene.rootNode.addChildNode(boxNode4)
            ArkitView.scene.rootNode.addChildNode(rcoBox)
            ArkitView.scene.rootNode.addChildNode(rfbBox)
            ArkitView.scene.rootNode.addChildNode(vcoOneIndexBox)
            ArkitView.scene.rootNode.addChildNode(vcoTwoIndexBox)
            ArkitView.scene.rootNode.addChildNode(detuneBoxNode)
            ArkitView.scene.rootNode.addChildNode(fmVolNode)
            ArkitView.scene.rootNode.addChildNode(fmModNode)
            ArkitView.scene.rootNode.addChildNode(delayTimeNode)
            ArkitView.scene.rootNode.addChildNode(delayFbNode)
            ArkitView.scene.rootNode.addChildNode(delayMixNode)
            
            ArkitView.scene.rootNode.addChildNode(node)
            ArkitView.scene.rootNode.addChildNode(node2)
            ArkitView.scene.rootNode.addChildNode(node3)
            ArkitView.scene.rootNode.addChildNode(node4)
            ArkitView.scene.rootNode.addChildNode(node5)
            ArkitView.scene.rootNode.addChildNode(node6)
            ArkitView.scene.rootNode.addChildNode(node7)
            ArkitView.scene.rootNode.addChildNode(node8)
            conductor.masterVolume.volume = 1
            
            
            StartStop.text = "Stop"
            
        } else if sender.isSelected == true {
            
            conductor.masterVolume.volume = 0
            ArkitView.scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode() }
            sender.isSelected = false
            StartStop.text = "Start"
        }
        
    }
  
 //function adding the pinch gesture the the view
    
    func addPinchGestureToSceneView() {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.handlePinch(withGestureRecognizer:)))
        
        ArkitView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    //Function creating a pinch gesture recognizer within the AR view
    
    @objc func handlePinch(withGestureRecognizer recognizer: UIPinchGestureRecognizer) {
        let tapLocation = recognizer.location(in: ArkitView)
        let hitTestResults = ArkitView.hitTest(tapLocation)
        
        guard let hitTestResult = hitTestResults.first else { return }

        hitTestResult.node.scale.z = Float((recognizer.scale))
        
        conductor.core.attackDuration = Double(boxNode.scale.z)
        conductor.core.decayDuration = Double(boxNode2.scale.z)
        conductor.core.sustainLevel = Double(boxNode3.scale.z)
        conductor.core.releaseDuration = Double(boxNode4.scale.z)
        conductor.reverb.cutoffFrequency = (Double(rcoBox.scale.z) / 2)
        conductor.reverb.feedback = (Double(rfbBox.scale.z) / 2)
        conductor.core.vco1.index = (Double(vcoOneIndexBox.scale.z) / 2)
        conductor.core.vco2.index = (Double(vcoTwoIndexBox.scale.z) / 2)
        conductor.core.globalbend = (Double(detuneBoxNode.scale.z) / 2)
        conductor.core.fmOsc.modulatingMultiplier = (Double(fmModNode.scale.z) / 2)
        conductor.core.fmOscMixer.volume = (Double(fmVolNode.scale.z) / 2)
        conductor.multiDelay.time = (Double(delayTimeNode.scale.z) / 2)
        conductor.multiDelayMixer.balance = (Double(delayMixNode.scale.z) / 2)
        conductor.multiDelay.mix = (Double(delayFbNode.scale.z) / 2)
            
        print("feedback", conductor.reverb.feedback)
        
        print("cutoff", conductor.reverb.cutoffFrequency)
        
    }


    // The commented out code below is for the horizontal plan detection mentioned in the video
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        
        /*
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        // 3
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
        
    }
    
*/
    }

}

extension ViewController: ARSCNViewDelegate, UIGestureRecognizerDelegate {
    
    // The commented out code below is for the horizontal plan detection mentioned in the video
    
    /*
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        // 3
        plane.materials.first?.diffuse.contents = UIColor.lightGray.withAlphaComponent(0.75)
        
        // 4
        let planeNode = SCNNode(geometry: plane)
        
        // 5
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
  
     boxNode.boundingBox.max = SCNVector3(0.05, 0.05, 3.0)
        
        /*
        planeNode.addChildNode(boxNode)
        planeNode.addChildNode(boxNode2)
          planeNode.addChildNode(boxNode3)
          planeNode.addChildNode(boxNode4)
        planeNode.addChildNode(rcoBox)
        planeNode.addChildNode(rfbBox)
    planeNode.addChildNode(vcoOneIndexBox)
        planeNode.addChildNode(vcoTwoIndexBox)
        planeNode.addChildNode(detuneBoxNode)

        node.addChildNode(planeNode)
   */
    }
 */
    
    // Extension allowing for multiple nodes to be interacted with
    
    private func gestureRecognizer(_ gestureRecognizer: UIPinchGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIPinchGestureRecognizer) -> Bool {
        return true
    }
    
    
}
