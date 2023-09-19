//
//  TextureField.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-13.
//

import SwiftUI
import SwiftData

public struct TextureLabel: View {
	private let texture: Texture?

	public init(_ texture: Texture?) {
		self.texture = texture
	}

	public var body: some View {
		Group {
			if let icon = texture?.contents.flatMap(Image.init) {
				icon
					.resizable()
					.interpolation(.none)
			} else {
				Image(systemName: "photo")
					.resizable()
					.redacted(reason: .placeholder)
			}
		}
		.aspectRatio(contentMode: .fit)
		.clipShape(RoundedRectangle(cornerRadius: 4, style: .circular))
	}

}

public struct TexturesLabel: View {
	private let textures: [Texture]

	public init(_ textures: [Texture]) {
		self.textures = textures
	}

	public var body: some View {
		if textures.isEmpty {
			TextureLabel(nil)
		} else {
			HStack {
				ForEach(textures, content: TextureLabel.init)
			}
		}
	}
}

public struct TextureField<Label: View>: View {

	@Binding private var selection: Texture?
	private let label: Label

	public init(selection: Binding<Texture?>, @ViewBuilder label: () -> Label) {
		_selection = selection
		self.label = label()
	}

	public init(_ title: LocalizedStringKey, selection: Binding<Texture?>) where Label == Text {
		self.init(selection: selection) { Text(title) }
	}

	public init(_ title: String, selection: Binding<Texture?>) where Label == Text {
		self.init(selection: selection) { Text(title) }
	}

	public init(selection: Binding<Texture>, @ViewBuilder label: () -> Label) {
		_selection = Binding { selection.wrappedValue } set: { selection.wrappedValue = $0 ?? selection.wrappedValue }
		self.label = label()
	}

	public init(_ title: LocalizedStringKey, selection: Binding<Texture>) where Label == Text {
		self.init(selection: selection) { Text(title) }
	}

	public init(_ title: String, selection: Binding<Texture>) where Label == Text {
		self.init(selection: selection) { Text(title) }
	}

	public var body: some View {
		ModelField(selection: $selection, content: TextureLabel.init) {
			LabeledContent {
				TextureLabel(selection)
			} label: {
				label
			}
		}
	}

}

public struct TexturesField<Label: View>: View {

	@Binding private var selection: [Texture]
	private let label: Label

	public init(selection: Binding<[Texture]>, @ViewBuilder label: () -> Label) {
		_selection = selection
		self.label = label()
	}

	public init(_ title: LocalizedStringKey, selection: Binding<[Texture]>) where Label == Text {
		self.init(selection: selection) { Text(title) }
	}

	public init(_ title: String, selection: Binding<[Texture]>) where Label == Text {
		self.init(selection: selection) { Text(title) }
	}

	public var body: some View {
		ModelsField(selection: $selection, content: TextureLabel.init) {
			LabeledContent {
				TexturesLabel(selection)
			} label: {
				label
			}
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
