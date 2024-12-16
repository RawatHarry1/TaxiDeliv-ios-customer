import UIKit

class ConfettiView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        let confettiLayer = CAEmitterLayer()
        confettiLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        confettiLayer.emitterSize = CGSize(width: 1, height: 1) // Small size for burst effect
        confettiLayer.emitterShape = .point
        confettiLayer.renderMode = .additive
        confettiLayer.emitterCells = generateEmitterCells()

        layer.addSublayer(confettiLayer)

        // Add the burst animation
        let burstAnimation = CABasicAnimation(keyPath: "emitterCells.confetti.birthRate")
        burstAnimation.fromValue = 1.0
        burstAnimation.toValue = 0.0
        burstAnimation.duration = 0.5 // Duration of the burst effect
        burstAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        burstAnimation.isRemovedOnCompletion = false
        burstAnimation.fillMode = .forwards
        confettiLayer.add(burstAnimation, forKey: "burstAnimation")

        // Add the position animation to make sparkles move downwards
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values = [
            NSValue(cgPoint: confettiLayer.emitterPosition),
            NSValue(cgPoint: CGPoint(x: confettiLayer.emitterPosition.x, y: bounds.size.height))
        ]
        positionAnimation.keyTimes = [0, 1]
        positionAnimation.duration = 1.0 // Duration of the downward movement
        positionAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        confettiLayer.add(positionAnimation, forKey: "position")

        // Set up the completion block
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.removeFromSuperview()
        }
        confettiLayer.add(burstAnimation, forKey: "burstAnimation")
        confettiLayer.add(positionAnimation, forKey: "position")
        CATransaction.commit()
    }

    private func generateEmitterCells() -> [CAEmitterCell] {
        var cells: [CAEmitterCell] = []

        for _ in 0..<20 {
            let cell = CAEmitterCell()
            cell.birthRate = 10
            cell.lifetime = 2.0 // Shorter lifetime for a burst effect
            cell.velocity = CGFloat(300) // Speed of particles
            cell.velocityRange = CGFloat(100) // Variability in speed
            cell.emissionLongitude = CGFloat.pi * 2.0 // Emit particles in all directions
            cell.emissionRange = CGFloat.pi * 2.0 // Full circle
            cell.scale = 0.2 // Size of particles
            cell.scaleRange = 0.1 // Variability in size
            cell.contents = UIImage(named: "confetti")?.cgImage
            cell.contentsScale = UIScreen.main.scale
            cell.color = randomColor().cgColor
            cells.append(cell)
        }

        return cells
    }

    private func randomColor() -> UIColor {
        let colors: [UIColor] = [
            .red, .green, .blue, .yellow, .orange, .purple, .cyan
        ]
        return colors[Int(arc4random_uniform(UInt32(colors.count)))]
    }
}
