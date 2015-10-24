//
//  PXUtils.swift
//  PXGoogleDirections
//
//  Created by Romain on 06/03/2015.
//  Copyright (c) 2015 RLT. All rights reserved.
//

import Foundation

public extension UIColor {
	public convenience init?(hexColor: String) {
		var red: CGFloat?
		var green: CGFloat?
		var blue: CGFloat?
		var alpha: CGFloat = 1.0
		
		if hexColor.hasPrefix("#") {
			let index = hexColor.startIndex.advancedBy(1)
			let hex = hexColor.substringFromIndex(index)
			let scanner = NSScanner(string: hex)
			var hexValue: CUnsignedLongLong = 0
			if scanner.scanHexLongLong(&hexValue) {
				switch hex.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
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
		if let r = red, g = green, b = blue {
			self.init(red: r, green: g, blue: b, alpha: alpha)
		} else {
			self.init()
			return nil
		}
	}
}
