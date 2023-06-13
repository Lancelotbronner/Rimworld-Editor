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

	public var path: String

	@Attribute(.externalStorage) public var contents: Data?

	public init(_ title: String, at path: String) {
		self.title = title
		self.path = path
	}

	public convenience init(_ title: String) {
		self.init(title, at: title)
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

	@Transient public var label: some View {
		Label {
			Text(title)
		} icon: {
			icon
		}

	}

	@Transient public var editor: some View {
		TextureEditor(texture: self)
	}

}

struct TextureEditor: View {
	@Bindable var texture: Texture
	@State private var isImageImportEnabled = false

	var body: some View {
		Form {
			TextField("Title", text: $texture.title)
			TextureContentsField(texture)
		}
		.formStyle(.grouped)
		.fileImporter(isPresented: $isImageImportEnabled, allowedContentTypes: [.image]) { result in
			if case let .success(url) = result, let data = try? Data(contentsOf: url) {
				texture.contents = data
			}
		}
	}
}
