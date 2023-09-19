//
//  Graphics.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-13.
//

import SwiftUI
import SwiftData

struct GraphicsView: View {
	@Environment(\.modelContext) private var context
	@Bindable private var graphics: Graphics

	init(_ graphics: Graphics) {
		self.graphics = graphics
	}

	var body: some View {
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
		if let mode = graphics._mode {
			mode._editor
		} else {
			Text("This graphic mode isn't supported.")
				.font(.caption)
				.foregroundStyle(.secondary)
		}
	}

}
