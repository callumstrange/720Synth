//
//  conductor.swift
//  720Synth
//  Created by Matthew Fecher on 1/5/16.
//  Copyright © 2016 AudioKit. All rights reserved.

//  Modified by callum strange on 23/02/2019.
//  Copyright © 2019 callum strange. All rights reserved.
//

import AudioKit

class Conductor: AKMIDIListener {
    /// Globally accessible singleton
    static let sharedInstance = Conductor()
    
    var core = GeneratorBank()
    var bitCrusher: AKBitCrusher
    var fatten: Fatten
    var filterSection: FilterSection
    var multiDelay: MultiDelay
    var multiDelayMixer: AKDryWetMixer
    
    var masterVolume = AKMixer()
    var reverb: AKCostelloReverb
    var reverbMixer: AKDryWetMixer
    
    var midiBendRange: Double = 2.0
    
    init() {
        AKSettings.audioInputEnabled = true
        bitCrusher = AKBitCrusher(core)
        bitCrusher.stop()
        
        filterSection = FilterSection(bitCrusher)
        filterSection.output.stop()
        
        fatten = Fatten(filterSection)
        multiDelay = MultiDelay(fatten)
        multiDelayMixer = AKDryWetMixer(fatten, multiDelay, balance: 0.0)
        
        masterVolume = AKMixer(multiDelayMixer)
        reverb = AKCostelloReverb(masterVolume)
        reverb.stop()
        
        reverbMixer = AKDryWetMixer(masterVolume, reverb, balance: 0.0)
        
        // uncomment this to allow background operation
        // AKSettings.playbackWhileMuted = true
        AudioKit.output = reverbMixer
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
     //   Audiobus.start()
        
        let midi = AudioKit.midi
        midi.createVirtualPorts()
        midi.openInput("Session 1")
        midi.addListener(self)
    }
    
    // MARK: - AKMIDIListener protocol functions
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber,
                            velocity: MIDIVelocity,
                            channel: MIDIChannel) {
        core.play(noteNumber: noteNumber, velocity: velocity)
    }
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber,
                             velocity: MIDIVelocity,
                             channel: MIDIChannel) {
        core.stop(noteNumber: noteNumber)
    }
    func receivedMIDIPitchWheel(_ pitchWheelValue: MIDIWord, channel: MIDIChannel) {
        let bendSemi = (Double(pitchWheelValue - 8_192) / 8_192.0) * midiBendRange
        core.globalbend = bendSemi
    }
    
}
