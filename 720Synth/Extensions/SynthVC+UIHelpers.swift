//
//  SynthViewController+UIHelpers.swift
//  AnalogSynthX
//
//  Created by Matthew Fecher on 1/15/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import UIKit

extension ViewController {

    //*****************************************************************
    // MARK: - Synth UI Helpers
    //*****************************************************************
 
    func cutoffFreqFromValue(_ value: Double) -> Double {
        // Logarithmic scale: knobvalue to frequency
        let scaledValue = Double.scaleRangeLog(value, rangeMin: 30, rangeMax: 7_000)
        return scaledValue * 4
    }

    func crusherFreqFromValue(_ value: Double) -> Double {
        // Logarithmic scale: reverse knobvalue to frequency
        let value = 1 - value
        let scaledValue = Double.scaleRangeLog(value, rangeMin: 50, rangeMax: 8_000)
        return scaledValue
    }

}
