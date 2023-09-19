//
//  Graphic Random.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-07-18.
//

import SwiftData
import SwiftUI

@Model public final class GraphicRandom: GraphicClass {

	public var textures: [Texture]

	public init() {
		textures = []
	}

	public static var label: some View {
		Label("Random", systemImage: "photo.stack")
	}

	public var editor: some View {
		RandomGraphicEditor(self)
	}

	public func populate(xml: XMLElement, at path: String) {
		xml.addChild(XMLElement(name: "texPath", stringValue: path))
	}

	public func write(to url: URL, at path: String) throws {
		let destination = url.appending(component: path)
		let identifier = path.lastIndex(of: "/").flatMap { String(path.suffix(from: $0)) } ?? path
		var suffix: Character = "A"
		for texture in textures {
			try texture.contents?.write(to: destination.appending(component: "\(identifier)\(suffix)"))
			suffix = Character(UnicodeScalar(suffix.asciiValue! + 1))
		}
	}

}

struct RandomGraphicEditor: View {
	@Bindable private var graphic: GraphicRandom

	init(_ graphic: GraphicRandom) {
		self.graphic = graphic
	}

	var body: some View {
		TexturesField("Textures", selection: $graphic.textures)
	}
}
