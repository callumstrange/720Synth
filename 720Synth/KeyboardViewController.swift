//
//  KeyboardViewController.swift
//  720Synth
//
//  Created by callum strange on 29/03/2019.
//  
//  Copyright © 2019 callum strange. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class KeyboardViewController: UIViewController {
    
  var conductor = Conductor.sharedInstance
    
    // Keyboard variables
    var midiNotesHeld = [MIDINoteNumber]()
    var keyboardOctavePosition: Int = 0
    let blackKeys = [49, 51, 54, 56, 58, 61, 63, 66, 68, 70, 73, 75, 78, 80]
    var monoMode: Bool = false
    var lastKey: UIButton?
    var holdMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
