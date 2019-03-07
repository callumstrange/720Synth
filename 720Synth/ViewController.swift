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
    
    
    let NoteOne = SCNNode(geometry: SCNBox())
    
    let box = SCNBox()
    
    var boxNode = SCNNode()
    
    
    @IBOutlet weak var ArkitView: ARSCNView!
    
    
    @IBOutlet weak var button: glossButton!
    
    let material = SCNMaterial()
    let material2 = SCNMaterial()
    
    // Keyboard variables
    var midiNotesHeld = [MIDINoteNumber]()
    var keyboardOctavePosition: Int = 0
    let blackKeys = [49, 51, 54, 56, 58, 61, 63, 66, 68, 70]
    var monoMode: Bool = false
    var lastKey: UIButton?
    var holdMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        material.diffuse.contents = UIColor.green
        material.emission.contents = UIColor.purple
        
        material2.diffuse.contents = UIColor.orange
        material2.diffuse.contents = UIColor.yellow
        
        box.chamferRadius = 0
        box.width = 0.05
        box.height = 0.05
        box.length = 0.05
        boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(0, 0, -0.2)
        
        boxNode.geometry?.materials = [material]
        
  //    addBox()
       addTapGestureToSceneView()
        ArkitView.autoenablesDefaultLighting = true
        ArkitView.scene.rootNode.addChildNode(boxNode)
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        ArkitView.session.run(configuration)
    }
    
   /* func addBox() {
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        
        boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(0, 0, -0.2)
        
        boxNode.geometry?.materials = [material]
        
        ArkitView.scene.rootNode.addChildNode(boxNode)
        
        let box2 = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
        
        let boxNode2 = SCNNode()
        boxNode2.geometry = box2
        boxNode2.position = SCNVector3(0.4, 0, -0.2)
        
        ArkitView.scene.rootNode.addChildNode(boxNode2)
    }
 
 */
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        
        
        ArkitView.addGestureRecognizer(tapGestureRecognizer)
    }
    

 
    @objc func didTap(withGestureRecognizer recognizer: UILongPressGestureRecognizer) {
        let tapLocation = recognizer.location(in: ArkitView)
        let hitTestResults = ArkitView.hitTest(tapLocation)
        guard (hitTestResults.first?.node) != nil else { return}
        
        
        if recognizer.state == .began{
            
           self.keyPressed(button)
             self.boxNode.geometry?.materials = [material2]
        } else
            if  recognizer.state == .ended {
         
                self.keyReleased(button)
                 self.boxNode.geometry?.materials = [material]
        }
        
 
    
        
    }
    
   

    
    // Keyboard Controls
    
    @IBAction func keyPressed(_ sender: UIButton) {
        let key = sender
        // Turn off last key press in Mono
        if monoMode {
            if let lastKey = lastKey {
                turnOffKey(lastKey)
            }
        }
        // Toggle key if in Hold mode
        if holdMode {
            if midiNotesHeld.contains(midiNoteFromTag(key.tag)) {
                turnOffKey(key)
                return
            }
        }
        turnOnKey(key)
        lastKey = key
    }
    @IBAction func keyReleased(_ sender: UIButton) {
        
        let key = sender
        
        if holdMode && monoMode {
            toggleMonoKeyHeld(key)
        } else if holdMode && !monoMode {
            toggleKeyHeld(key)
            
        } else {
            turnOffKey(key)
        }
    }
    
    @IBAction func hold(_ sender: glossButton) {
        
        
        if sender.isSelected {
            sender.isSelected = false
            holdMode = false
            turnOffHeldKeys()
        } else {
            sender.isSelected = true
            holdMode = true
        }
    }
    
    @IBAction func mono(_ sender: glossButton) {
        if sender.isSelected {
            sender.isSelected = false
            monoMode = false
        } else {
            sender.isSelected = true
            
            monoMode = true
            turnOffHeldKeys()
        }
    }
    
    @IBAction func octaveUpPressed(_ sender: glossButton) {
        
        guard keyboardOctavePosition < 3 else {
            return
        }
        
        keyboardOctavePosition += 1
        redisplayHeldKeys()
    }
    
    @IBAction func octaveDownPressed(_ sender: glossButton){
        
        guard keyboardOctavePosition > -2 else {
            
            return
        }
        
        keyboardOctavePosition += -1
        
        redisplayHeldKeys()
    }
    
    
    // 🎹 Key UI/UX Helpers
    
    
    func turnOnKey(_ key: UIButton) {
        updateKeyToDownPosition(key)
        let midiNote = midiNoteFromTag(key.tag)
        
        conductor.core.play(noteNumber: midiNote, velocity: 127)
        
    }
    
    func turnOffKey(_ key: UIButton) {
        updateKeyToUpPosition(key)
       conductor.core.stop(noteNumber: midiNoteFromTag(key.tag))
        
    }
    
    func turnOffHeldKeys() {
        updateAllKeysToUpPosition()
        
        for note in 0...127 {
            conductor.core.stop(noteNumber: MIDINoteNumber(note))
            
        }
        midiNotesHeld.removeAll(keepingCapacity: false)
    }
    
    func updateAllKeysToUpPosition() {
        // Key up all keys shown on display
        for tag in 248...272 {
            guard let key = self.view.viewWithTag(tag) as? UIButton else {
                return
            }
            updateKeyToUpPosition(key)
        }
    }
    
    func redisplayHeldKeys() {
        
        // Determine new keyboard bounds
        let lowerMidiNote = MIDINoteNumber(48 + (keyboardOctavePosition * 12))
        let upperMidiNote = lowerMidiNote + 24
        
        
        guard !monoMode else {
            turnOffHeldKeys()
            return
        }
        
        // Refresh keyboard
        updateAllKeysToUpPosition()
        
        // Check notes currently in view and turn on if held
        for note in lowerMidiNote...upperMidiNote {
            if midiNotesHeld.contains(note) {
                let keyTag = (Int(note) - (keyboardOctavePosition * 12)) + 200
                guard let key = self.view.viewWithTag(keyTag) as? UIButton else {
                    return
                }
                updateKeyToDownPosition(key)
            }
        }
    }
    
    func toggleKeyHeld(_ key: UIButton) {
        if let i = midiNotesHeld.index(of: midiNoteFromTag(key.tag)) {
            midiNotesHeld.remove(at: i)
        } else {
            midiNotesHeld.append(midiNoteFromTag(key.tag))
        }
    }
    
    func toggleMonoKeyHeld(_ key: UIButton) {
        if midiNotesHeld.contains(midiNoteFromTag(key.tag)) {
            midiNotesHeld.removeAll()
        } else {
            midiNotesHeld.removeAll()
            midiNotesHeld.append(midiNoteFromTag(key.tag))
        }
    }
    
    func updateKeyToUpPosition(_ key: UIButton) {
        let index = key.tag - 200
        if blackKeys.contains(index) {
            key.setImage(#imageLiteral(resourceName: "blkKeyUp_1"), for: UIControl.State())
        } else {
            key.setImage(#imageLiteral(resourceName: "keyUp_1"), for: UIControl.State())
        }
    }
    
    func updateKeyToDownPosition(_ key: UIButton) {
        let index = key.tag - 200
        if blackKeys.contains(index) {
            key.setImage(#imageLiteral(resourceName: "blkKeyDown_1"), for: UIControl.State())
        } else {
            key.setImage(#imageLiteral(resourceName: "keyDown_1"), for: UIControl.State())
        }
    }
    
    func midiNoteFromTag(_ tag: Int) -> MIDINoteNumber {
        return MIDINoteNumber((tag - 200) + (keyboardOctavePosition * 12))
    }
    
    
    


}

extension ViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UILongPressGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UILongPressGestureRecognizer) -> Bool {
        return true
    }
    
}

