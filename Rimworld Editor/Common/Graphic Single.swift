//
//  Graphic Single.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-07-13.
//

import SwiftData
import SwiftUI

@Model public final class GraphicSingle: GraphicClass {

	public var texture: Texture?

	public init() {
		self.texture = texture
	}

	public static var label: some View {
		Label("Single", systemImage: "photo")
	}

	public var editor: some View {
		SingleGraphicEditor(self)
	}

	public func populate(xml: XMLElement, at path: String) {
		xml.addChild(XMLElement(name: "texPath", stringValue: path))
	}

	public func write(to url: URL, at path: String) throws {
		try texture?.contents?.write(to: url.appending(path: path).appendingPathExtension("png"))
	}

}

struct SingleGraphicEditor: View {
	@Bindable private var graphic: GraphicSingle

	init(_ graphic: GraphicSingle) {
		self.graphic = graphic
	}

	var body: some View {
		TextureField("Texture", selection: $graphic.texture)
	}
}
