//
//  OnionyButton.swift
//  Oniony
//
//  Created by Георгий Черемных on 28.12.2020.
//

import UIKit

final class OnionyButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let title = titleLabel else { fatalError() }
        title.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        
        backgroundColor = Asset.mainButton.color
        
        layer.cornerRadius = frame.height / 2
        layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += 32
        return size
    }
}
