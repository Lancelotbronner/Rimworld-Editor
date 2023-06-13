//
//  Extensions.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-09.
//

import SwiftUI

extension Image {

	public init?(data: Data) {
#if canImport(AppKit)
		guard let nsimage = NSImage(data: data) else {
			return nil
		}
		self.init(nsImage: nsimage)
#elseif canImport(UIKit)
		guard let uiimage = UIImage(data: data) else {
			return nil
		}
		self.init(uiImage: uiimage)
#endif
	}

}

func ??<T: Equatable>(base: Binding<Optional<T>>, defaultValue: T) -> Binding<T> {
	Binding(
		get: { base.wrappedValue ?? defaultValue },
		set: { base.wrappedValue = $0 == defaultValue ? nil : $0 }
	)
}

func ??<T>(base: Binding<Optional<T>>, defaultValue: T) -> Binding<T> {
	Binding(
		get: { base.wrappedValue ?? defaultValue },
		set: { base.wrappedValue = $0 }
	)
}
