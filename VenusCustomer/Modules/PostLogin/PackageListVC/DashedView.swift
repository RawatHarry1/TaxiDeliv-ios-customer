//
//  DashedView.swift
//  VenusCustomer
//
//  Created by TechBuilder on 23/01/25.
//

import Foundation
import UIKit
class RectangularDashedView: UIView {
    
    @IBInspectable override var cornerRadius: CGFloat{
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 2
    @IBInspectable var dashColor: UIColor = VCColors.buttonSelectedOrange.color
    @IBInspectable var dashLength: CGFloat = 6
    @IBInspectable var betweenDashesSpace: CGFloat = 3
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
