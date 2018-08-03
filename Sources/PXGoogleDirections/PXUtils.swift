//
//  PXUtils.swift
//  PXGoogleDirections
//
//  Created by Romain on 06/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
	// MARK: Initializers
	
	/**
	Creates a new instance of `UIColor` with the specified 0x###### hex string.
	
	- parameter hexColor: The desired color as an hexadecimal string (can be 3, 4, 6 or 8 characters long depending on the desired color and alpha values wanted - by default alpha is 100%)
	*/
	public convenience init?(hexColor: String) {
		var red: CGFloat?
		var green: CGFloat?
		var blue: CGFloat?
		var alpha: CGFloat = 1.0
		
		if hexColor.hasPrefix("#") {
			let index = hexColor.index(hexColor.startIndex, offsetBy: 1)
			let hex = String(hexColor.suffix(from: index))
			let scanner = Scanner(string: hex)
			var hexValue: CUnsignedLongLong = 0
			if scanner.scanHexInt64(&hexValue) {
				switch hex.lengthOfBytes(using: String.Encoding.utf8) {
				case 3:
					red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
					green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
					blue  = CGFloat(hexValue & 0x00F)              / 15.0
				case 4:
					red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
					green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
					blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
					alpha = CGFloat(hexValue & 0x000F)             / 15.0
				case 6:
					red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
					green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
					blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
				case 8:
					red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
					green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
					blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
					alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
				default:
					break
				}
			}
		}
		if let r = red, let g = green, let b = blue {
			self.init(red: r, green: g, blue: b, alpha: alpha)
		} else {
			self.init()
			return nil
		}
	}
}
