//
//  GraphicClass.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-13.
//

import SwiftUI

public enum GraphicMode: Int, Hashable, Identifiable, CaseIterable, View {

	case none = 0

	case single = 1
	case cardinal = 2
	case random = 3

	public var id: GraphicMode {
		self
	}

	public var body: some View {
		switch self {
		case .none: Label("None", systemImage: "rectangle")
		case .single: Label("Single", systemImage: "photo")
		case .cardinal: Label("Cardinal", systemImage: "photo.on.rectangle")
		case .random: Label("Random", systemImage: "photo.stack")
		}
	}

}
