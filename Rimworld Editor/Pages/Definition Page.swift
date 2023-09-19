//
//  Definitions Page.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-27.
//

import SwiftUI
import SwiftData

struct DefinitionPage<Model: EditableModel>: View {
	@Environment(Navigation<AppRoutes>.self) private var navigation
	@Environment(\.modelContext) private var context
	@State private var selection: Set<Model> = []

	@Query private var definitions: [Model]

	var body: some View {
		NavigationStack {
			List(selection: $selection) {
				ForEach(definitions) { definition in
					definition.label
						.tag(definition)
				}
			}
		}
		.toolbar {
			ToolbarItem {
				Button {
					let placeholder = Model("Placeholder \(definitions.count)")
					context.insert(placeholder)
					navigation.path.append(placeholder)
				} label: {
					Label("New", systemImage: "plus")
				}
			}
		}
	}

}
