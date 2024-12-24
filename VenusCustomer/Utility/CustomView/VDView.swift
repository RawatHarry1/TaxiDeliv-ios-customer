//
//  VDView.swift
//  VenusDriver
//
//  Created by Amit on 22/07/23.
//

import Foundation
import UIKit

@IBDesignable
class VDView: UIView {

    // Define the colors for the gradient
    @IBInspectable var startColor: UIColor = VCColors.buttonSelectedOrange.color {
        didSet {
            updateGradient()
        }
    }
    @IBInspectable var endColor: UIColor = VCColors.buttonGreen.color {
        didSet {
            updateGradient()
        }
    }

    @IBInspectable var viewCornerRadius: Double = 5.0 {
        didSet {
            updateGradient()
        }
    }

    // Create gradient layer
    let gradientLayer = CAGradientLayer()

    override func draw(_ rect: CGRect) {
        // Set the gradient frame
        gradientLayer.frame = rect

        // Set the colors
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        // Gradient is linear from left to right
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        // Add gradient layer into the button
        layer.insertSublayer(gradientLayer, at: 0)
        // Round the button corners
        layer.cornerRadius = viewCornerRadius
        clipsToBounds = true
    }

    func updateGradient() {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
