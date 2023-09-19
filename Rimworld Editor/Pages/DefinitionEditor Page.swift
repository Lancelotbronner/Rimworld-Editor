//
//  DefinitionEditor Page.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-09-18.
//

import SwiftUI

struct DefinitionEditorPage<Model: EditableModel>: View {
	private let definition: Model

	init(_ definition: Model) {
		self.definition = definition
	}

	var body: some View {
		Form {
			definition.editor
		}
		.formStyle(.grouped)
	}
}

extension View {

	public func navigationDestination<Model: EditableModel>(definition: Model.Type) -> some View {
		navigationDestination(for: Model.self, destination: DefinitionEditorPage.init)
	}

}
