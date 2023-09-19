//
//  GraphicClass.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-13.
//

import SwiftUI
import SwiftData

public protocol GraphicClass: PersistentModel {
	associatedtype IdentityView: View
	associatedtype EditorView: View

	init()

	func populate(xml: XMLElement, at path: String)
	func write(to url: URL, at path: String) throws

	@ViewBuilder var editor: EditorView { get }

	@ViewBuilder static var label: IdentityView { get }
}

extension GraphicClass {

	internal static var _label: AnyView {
		AnyView(label)
	}

	internal var _editor: AnyView {
		AnyView(editor)
	}

}

public enum GraphicsClass: String, Hashable, Codable, CaseIterable {

//	case appearances = "Graphic_Appearances"
//	case cluster = "Graphic_Cluster"
//	case fleck = "Graphic_Fleck"
//	case flash = "Graphic_FleckFlash"
//	case pulse = "Graphic_FleckPulse"
//	case flicker = "Graphic_Flicker"
//	case meals = "Graphic_MealVariants"
//	case mote = "Graphic_Mote"
//	case ages = "Graphic_MoteWithAgeSecs"
	case cardinal = "Graphic_Multi"
//	case pawn = "Graphic_PawnBodySilouhette"
	case random = "Graphic_Random"
	case single = "Graphic_Single"
//	case stack = "Graphic_StackCount"

	internal var type: any GraphicClass.Type {
		switch self {
		case .cardinal: return GraphicMulti.self
		case .random: return GraphicRandom.self
		case .single: return GraphicSingle.self
		}
	}

	public var label: some View {
		type._label
	}

//	public func migrate(_ slots: inout [TextureSlot], from previous: GraphicsClass, using context: ModelContext) {
//		switch self {
//		case .single:
//			if slots.count == 0 {
//				let slot = TextureSlot(slot: "single")
//				context.insert(slot)
//				slots.append(slot)
//			} else {
//				slots.min()?.slot = "single"
//			}
//		default: return
//		}
//	}

//	public func write(slots: [TextureSlot], to url: URL) throws {
//		switch self {
//		case .none: return
//		case .single:
//			let slot = slots.first { $0.slot == "single" }
//			try slot?.texture?.contents?.write(to: url.appendingPathExtension("png"))
//		default:
//			try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
//			for slot in slots {
//				guard let texture = slot.texture else { continue }
//				try texture.contents?.write(to: url.appending(component: texture.uuid.uuidString + ".png", directoryHint: .notDirectory))
//			}
//		}
//	}

}
