//
//  Texture.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-12.
//

import SwiftUI
import SwiftData

@Model public final class Texture: EditableModel {

	/// The unique identifier of the texture
	public var uuid = UUID()

	public var title: String

	public var identifier = ""

	@Attribute(.externalStorage) public var contents: Data?

	public init(_ title: String, as identifier: String = "") {
		self.title = title
		self.identifier = identifier
	}

	public convenience init(_ title: String) {
		self.init(title, as: title)
	}

	public static var label: some View {
		Label("Texture", systemImage: "photo")
	}

	@ViewBuilder public var icon: some View {
		if let icon = contents.flatMap(Image.init) {
			icon
				.resizable()
				.interpolation(.none)
				.aspectRatio(contentMode: .fit)
		} else {
			Image(systemName: "photo")
		}
	}

	public var label: some View {
		Label {
			Text(title)
		} icon: {
			icon
		}

	}

	public var editor: some View {
		TextureEditor(texture: self)
	}

}

struct TextureEditor: View {
	@Bindable var texture: Texture

	var body: some View {
		Form {
			TextField("Title", text: $texture.title)
			TextField("Identifier", text: $texture.identifier, prompt: Text(texture.uuid.uuidString))
			TextureContentsField(texture)
		}
		.formStyle(.grouped)
	}
}
