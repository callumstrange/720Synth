//
//  SynthViewController.swift
//  720Synth
//
//  Created by callum strange on 01/04/2019.
//  Copyright © 2019 callum strange. All rights reserved.
//

import UIKit

class SynthViewController: UIViewController {

    var conductor = Conductor.sharedInstance

    @IBOutlet weak var AttackKnob: Knob!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupKnobValues() {
        AttackKnob.maximum = 3.0
        AttackKnob.minimum = 0.2
        AttackKnob.value = conductor.core.releaseDuration
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func reverb(_ sender: UIButton) {
        conductor.reverb.start()
    }
}

extension SynthViewController: KnobDelegate {
    
    func updateKnobValue(_ value: Double, tag: Int) {
        conductor.core.releaseDuration = Double(AttackKnob.knobValue)
        
        
        
        
    }
}

