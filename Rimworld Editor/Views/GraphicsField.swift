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
	@Binding private var mode: GraphicMode

	init(
		selection mode: Binding<GraphicMode>,
		using textures: Binding<[Texture]>
	) {
		_textures = textures
		_mode = mode
	}

	var body: some View {
		Picker("Mode", selection: $mode) {
			ForEach(GraphicMode.allCases) { $0 }
		}
		NavigationLink {
			TextureSelectionSheet(textures: $textures)
		} label: {
			Label {
				Text("Textures")
			} icon: {
				ForEach(textures) { texture in
					texture.icon
				}
			}
		}
	}

}
