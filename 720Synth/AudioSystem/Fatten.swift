//
//  Fatten.swift
//  720Synth
//  Created by Matthew Fecher on 1/5/16.
//  Copyright © 2016 AudioKit. All rights reserved.

//  Modified by callum strange on 23/02/2019.
//  Copyright © 2019 callum strange. All rights reserved.
//

import AudioKit

class Fatten: AKNode, AKInput {
    var dryWetMix: AKDryWetMixer
    var delay: AKDelay
    var pannedDelay: AKPanner
    var pannedSource: AKPanner
    var wet: AKMixer
    var inputMixer = AKMixer()
    
    var inputNode: AVAudioNode {
        return inputMixer.avAudioNode
    }
    
     init(_ input: AKNode) {
        input.connect(to: inputMixer)
        delay = AKDelay(inputMixer, time: 0.05, dryWetMix: 1)
        pannedDelay = AKPanner(delay, pan: 1)
        pannedSource = AKPanner(inputMixer, pan: -1)
        wet = AKMixer(pannedDelay, pannedSource)
        dryWetMix = AKDryWetMixer(inputMixer, wet, balance: 0)
        super.init()
        self.avAudioNode = dryWetMix.avAudioNode
    }
    
}
