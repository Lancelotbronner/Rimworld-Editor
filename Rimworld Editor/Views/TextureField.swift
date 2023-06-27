//
//  TextureField.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-13.
//

import SwiftUI
import SwiftData

struct TextureField<Label: View>: View {
	@Binding private var texture: Texture?
	@State private var isImportPresented = false

	private let label: Label

	init(_ texture: Binding<Texture?>, @ViewBuilder label: () -> Label) {
		_texture = texture
		self.label = label()
	}

	init(_ texture: Binding<Texture?>) where Label == EmptyView {
		self.init(texture) { EmptyView() }
	}

	init(_ title: LocalizedStringKey, texture: Binding<Texture?>) where Label == Text {
		self.init(texture) { Text(title) }
	}

	init(_ title: String, texture: Binding<Texture?>) where Label == Text {
		self.init(texture) { Text(title) }
	}

	var body: some View {
		LabeledContent {
			Button("Select Texture...") {
				isImportPresented = true
			}
			.buttonStyle(.link)
		} label: {
			label
		}
		.sheet(isPresented: $isImportPresented) {
			List {

			}
			.navigationTitle("Select a Texture")
		}
	}

}

struct TextureContentsField: View {
	@Bindable private var texture: Texture
	@State private var isImportPresented = false

	init(_ texture: Texture) {
		self.texture = texture
	}

	var body: some View {
		if let data = texture.contents, let image = Image(data: data) {
			image
				.resizable()
				.interpolation(.none)
				.aspectRatio(contentMode: .fit)
				.allowedDynamicRange(.constrainedHigh)
				.clipShape(RoundedRectangle(cornerRadius: 12))
				.overlay(alignment: .topTrailing) {
					Button(role: .destructive) {
						texture.contents = nil
					} label: {
						SwiftUI.Label("Clear", systemImage: "x.circle.fill")
					}
					.foregroundStyle(.red)
				}
		} else {
			Button("Import image") {
				isImportPresented = true
			}
			.buttonStyle(.link)
			.fileImporter(isPresented: $isImportPresented, allowedContentTypes: [.image]) { result in
				if case let .success(url) = result, let data = try? Data(contentsOf: url) {
					texture.contents = data
				}
			}
		}
	}

}

struct TextureSelectionSheet: View {
	@Query private var textures: [Texture]
	@Binding private var selected: [Texture]
	@State private var selection: Set<Texture.ID>

	init(textures: Binding<[Texture]>) {
		_selected = textures
		let selection = Set(textures.wrappedValue.map(\.id))
		_selection = State(initialValue: selection)
	}

	private var available: [Texture] {
		textures.filter { texture in
			!selected.contains { $0.id == texture.id }
		}
	}

	private var currentlySelected: [Texture] {
		textures.filter { texture in
			selection.contains(texture.id)
		}
	}

	var body: some View {
		HStack {
			List(available, selection: $selection) { texture in
				texture.label
			}
			.onMoveCommand { direction in
				switch direction {
				case .right:
					selected.append(contentsOf: currentlySelected)
				default:
					break
				}
			}
			List($selected, editActions: .all) { $texture in
				texture.label
			}
		}
	}

}
