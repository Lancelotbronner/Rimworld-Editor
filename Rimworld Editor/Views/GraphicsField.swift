//
//  Graphics.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-13.
//

import SwiftUI
import SwiftData

struct GraphicsView: View {
	@Binding private var textures: [Texture]
	@Binding private var mode: GraphicsClass

	init(
		selection mode: Binding<GraphicsClass>,
		using textures: Binding<[Texture]>
	) {
		_textures = textures
		_mode = mode
	}

	var body: some View {
		Picker("Class", selection: $mode) {
			ForEach(GraphicsClass.allCases) {
				$0.label
			}
		}
		//TODO: Advanced only?
		TextField("Custom Class", text: $mode.rawValue, prompt: Text("Graphic_"))
			.textFieldStyle(.roundedBorder)
		switch mode {
		case .none:
			EmptyView()
		default:
			ModelsField(selection: $textures) { texture in
				texture.label
			} label: { textures in
				LabeledContent {
					HStack {
						ForEach(textures) { texture in
							texture.icon
								.clipShape(RoundedRectangle(cornerRadius: 8))
						}
					}
					.frame(height: 80)
				} label: {
					Text("Textures")
				}
			}
		}
	}

}
