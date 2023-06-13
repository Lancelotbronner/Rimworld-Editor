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

struct TextureContentsField<Label: View>: View {
	@Bindable private var texture: Texture
	@State private var isImportPresented = false

	private let label: Label

	init(_ texture: Texture, @ViewBuilder label: () -> Label) {
		self.texture = texture
		self.label = label()
	}

	init(_ texture: Texture) where Label == EmptyView {
		self.init(texture) { EmptyView() }
	}

	init(_ title: LocalizedStringKey, texture: Texture) where Label == Text {
		self.init(texture) { Text(title) }
	}

	init(_ title: String, texture: Texture) where Label == Text {
		self.init(texture) { Text(title) }
	}

	var body: some View {
		LabeledContent {
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
			}
		} label: {
			label
		}
	}

}

struct TextureSelectionSheet: View {
	@Query private var textures: [Texture]
	@Binding private var previouslySelected: [Texture]
	@State private var selection: Set<Texture.ID>

	init(textures: Binding<[Texture]>) {
		_previouslySelected = textures
		let selection = Set(textures.wrappedValue.map(\.id))
		_selection = State(initialValue: selection)
	}

	var body: some View {
		List(textures, selection: $selection) { texture in
			texture.label
		}
		.onChange(of: selection) {
			previouslySelected = textures.filter { texture in
				selection.contains(texture.id)
			}
			print("from \(selection)")
		}
	}

}
