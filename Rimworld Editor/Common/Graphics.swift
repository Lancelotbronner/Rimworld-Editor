//
//  GraphicClass.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-13.
//

import SwiftUI

public struct GraphicsClass: Hashable, Codable, RawRepresentable, Identifiable, CaseIterable {

	public static let allCases: [GraphicsClass] = [
		.none,
		.appearances, .cluster, .fleck, .flash, .pulse, .flicker, .meals, .mote, .ages, .cardinal, .pawn, .random, .single, .stack,
	]

	public static let none = GraphicsClass(rawValue: "")

	public static let appearances = GraphicsClass(rawValue: "Graphic_Appearances")
	public static let cluster = GraphicsClass(rawValue: "Graphic_Cluster")
	public static let fleck = GraphicsClass(rawValue: "Graphic_Fleck")
	public static let flash = GraphicsClass(rawValue: "Graphic_FleckFlash")
	public static let pulse = GraphicsClass(rawValue: "Graphic_FleckPulse")
	public static let flicker = GraphicsClass(rawValue: "Graphic_Flicker")
	public static let meals = GraphicsClass(rawValue: "Graphic_MealVariants")
	public static let mote = GraphicsClass(rawValue: "Graphic_Mote")
	public static let ages = GraphicsClass(rawValue: "Graphic_MoteWithAgeSecs")
	public static let cardinal = GraphicsClass(rawValue: "Graphic_Multi")
	public static let pawn = GraphicsClass(rawValue: "Graphic_PawnBodySilouhette")
	public static let random = GraphicsClass(rawValue: "Graphic_Random")
	public static let single = GraphicsClass(rawValue: "Graphic_Single")
	public static let stack = GraphicsClass(rawValue: "Graphic_StackCount")

	public var rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	public var id: GraphicsClass {
		self
	}

	@ViewBuilder public var label: some View {
		switch self {
		case .none: Label("None", systemImage: "rectangle")
		case .single: Label("Single", systemImage: "photo")
		case .cardinal: Label("Multi", systemImage: "photo.on.rectangle")
		case .random: Label("Random", systemImage: "photo.stack")
		default: Text(rawValue)
		}
	}

	public func write(textures: [Texture], to url: URL) throws {
		switch self {
		case .none: return
		case .single:
			try textures.first?.contents?.write(to: url.appendingPathExtension("png"))
		default:
			try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
			for texture in textures {
				try texture.contents?.write(to: url.appending(component: texture.uuid.uuidString + ".png", directoryHint: .notDirectory))
			}
		}
	}

}
