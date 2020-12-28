//
//  GradientView.swift
//  Oniony
//
//  Created by Георгий Черемных on 28.12.2020.
//

import UIKit

final class GradientView: UIView {
    
    @IBInspectable var firstColor: UIColor = Asset.main.color
    @IBInspectable var secondColor: UIColor = Asset.second.color
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gradient = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = CGRect(origin: .zero, size: frame.size)
        layer.addSublayer(gradient)
    }
}
