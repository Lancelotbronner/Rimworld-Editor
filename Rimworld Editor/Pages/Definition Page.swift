//
//  Definitions Page.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-27.
//

import SwiftUI
import SwiftData

struct DefinitionPage<Def: Definition>: View {

	@Environment(Navigation<AppRoutes>.self) private var navigation
	@Environment(\.modelContext) private var context

	@Query private var definitions: [Def]

	var body: some View {
		NavigationStack {
			List {
				ForEach(definitions) { definition in
					NavigationLink(value: definition) {
						definition.label
					}
				}
			}
			.navigationDestination(for: Def.self) { definition in
				definition.editor
					.formStyle(.grouped)
			}
		}
		.toolbar {
			ToolbarItem {
				Button {
					let placeholder = Def("MyNamespace:\(Def.self)-\(definitions.count)", title: "New \(Def.self)")
					context.insert(placeholder)
					navigation.path.append(placeholder)
				} label: {
					Label("New", systemImage: "plus")
				}
			}
		}
	}

}
