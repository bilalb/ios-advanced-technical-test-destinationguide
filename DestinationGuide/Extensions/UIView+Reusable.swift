//
//  UIView+Reusable.swift
//  DestinationGuide
//
//  Created by Bilal on 14/08/2022.
//

import UIKit

extension UIView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
