//
//  Extensions.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-09.
//

import SwiftUI

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
