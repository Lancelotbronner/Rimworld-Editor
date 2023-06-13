//
//  Research Definition.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-07.
//

import SwiftUI
import SwiftData

@Model public final class ResearchProject: EditableModel {

	/// The name of the research project
	public var identifier = ""

	/// The display name of the research project
	public var title = ""

	/// The description of the research project
	public var summary = ""

	private var rawGraphics = 0

	/// The icon's graphic mode
	public var graphics: GraphicMode {
		get { GraphicMode(rawValue: rawGraphics) ?? .none }
		set { rawGraphics = newValue.rawValue }
	}

	/// The textures associated with the project
	public var textures: [Texture] = []

	/// How much work must go into this project in order to complete it
	public var cost = 0

	/// The technology level of this research project
	public var level = ""

	/// The identifiers of the research project's prerequisites
//	public var prerequisites: [String] = []

	/// The X position of the project in the research view
	public var x = 0.0

	/// The X position of the project in the research view
	public var y = 0.0

	public init(_ title: String) {
		self.identifier = "research_project:\(title)"
		self.title = title
	}

	public static var label: some View {
		Label("Research Project", systemImage: "flask")
	}

	@Transient public var label: some View {
		Label(title, systemImage: "flask")
	}

	@Transient public var editor: some View {
		ResearchProjectEditor(self)
	}

	public var xml: XMLElement {
		let root = XMLElement(name: "ThingDef")
		root.addChild(XMLElement(name: "defName", stringValue: identifier))
		root.addChild(XMLElement(name: "label", stringValue: title))
		root.addChild(XMLElement(name: "description", stringValue: summary))
		root.addChild(XMLElement(name: "baseCost", stringValue: cost.description))
		root.addChild(XMLElement(name: "techLevel", stringValue: level))
		root.addChild(XMLElement(name: "researchViewX", stringValue: x.description))
		root.addChild(XMLElement(name: "researchViewY", stringValue: y.description))
		return root
	}

}

public struct ResearchProjectEditor: View {

	@Bindable private var definition: ResearchProject
	@State private var prerequisites: Set<String> = []

	public init(_ definition: ResearchProject) {
		self.definition = definition
	}

	public var body: some View {
		Form {
			Section("Definition") {
				TextField("Identifier", text: $definition.identifier)
				TextField("Title", text: $definition.title)
				TextField("Summary", text: $definition.summary)
			}

			Section("Research") {
				TextField("Technology Level", text: $definition.level)
				TextField("Work", value: $definition.cost, format: .number)
				LabeledContent("Prerequisites") {
//					List($definition.prerequisites, id: \.self) { prerequisite in
//						TextField("Prerequisite", text: prerequisite)
//					}
//					.onDeleteCommand {
//						definition.prerequisites.removeAll(where: prerequisites.contains)
//					}
					HStack {
						Spacer()
						Button {
//							definition.prerequisites.append("")
						} label: {
							Label("Add", systemImage: "plus")
						}
					}
				}
				LabeledContent("Position") {
					HStack {
						TextField("X", value: $definition.x, format: .number)
						TextField("Y", value: $definition.y, format: .number)
					}
				}
			}

			Section("Graphics") {
				GraphicsView(selection: $definition.graphics, using: $definition.textures)
			}
		}
		.formStyle(.grouped)
	}

}

#Preview {
	ResearchProjectEditor(ResearchProject("Preview Technologies"))
}
