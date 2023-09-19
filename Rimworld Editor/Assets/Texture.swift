//
//  Texture.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-12.
//

import SwiftUI
import SwiftData

@Model public final class Texture: EditableModel {

	public var title: String

	@Attribute(.externalStorage) public var contents: Data?

	public init(_ title: String) {
		self.title = title
	}

	public static var label: some View {
		Label("Texture", systemImage: "photo")
	}

	public var label: some View {
		Label {
			Text(title)
		} icon: {
			TextureLabel(self)
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
			TextureContentsField(texture)
		}
		.formStyle(.grouped)
	}
}
