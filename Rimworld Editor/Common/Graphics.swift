//
//  Graphics.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-07-18.
//

import SwiftData
import SwiftUI

@Model public final class Graphics {

	var identifier: String?

	var single: GraphicSingle?
	var multi: GraphicMulti?
	var random: GraphicRandom?

	var rawMode = ""

	init() { }

	public var mode: GraphicsClass? {
		get { GraphicsClass(rawValue: rawMode) }
		set { rawMode = newValue?.rawValue ?? "" }
	}

	internal var _mode: (any GraphicClass)? {
		switch mode {
		case .cardinal: return multi
		case .random: return random
		case .single: return single
		case .none: return nil
		}
	}

	public func xml(at path: String) -> XMLElement {
		let root = XMLElement(name: "graphicData")
		root.addChild(XMLElement(name: "graphicClass", stringValue: rawMode))
		_mode?.populate(xml: root, at: identifier ?? path)
		return root
	}

}

public struct GraphicsEditor: View {
	@Bindable private var graphics: Graphics

	public init(_ graphics: Graphics) {
		self.graphics = graphics
	}

	public var body: some View {
		TextField("Identifier", text: $graphics.identifier ?? "", prompt: Text("infer from definition"))
		Picker("Class", selection: $graphics.rawMode) {
			ForEach(GraphicsClass.allCases, id: \.rawValue) { mode in
				mode.label
			}
		}
		.onChange(of: graphics.mode) { previousValue, newValue in
			//			newValue.migrate(&slots, from: previousValue, using: context)
			// TODO: Migrate modes
		}
		TextField("Custom Class", text: $graphics.rawMode, prompt: Text("Graphic_"))
			.textFieldStyle(.roundedBorder)

		if let mode = graphics.mode {
			Section {
				graphics._mode?._editor
			} header: {
				mode.label
			}
		} else {
			Text("This graphic class isn't supported.")
				.font(.caption)
				.foregroundStyle(.secondary)
		}

		// TODO: Common graphics fields
	}
}
