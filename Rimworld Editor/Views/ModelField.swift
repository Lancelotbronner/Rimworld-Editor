//
//  ModelField.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-15.
//

import SwiftUI
import SwiftData

struct ModelField<Model: PersistentModel, Content: View>: View {
	@Binding private var selection: Model?
	@State private var isImportPresented = false

	private let content: (Model) -> Content

	init(selection: Binding<Model?>, @ViewBuilder content: @escaping (Model) -> Content) {
		_selection = selection
		self.content = content
	}

	init(selection: Binding<Model>, @ViewBuilder content: @escaping (Model) -> Content) {
		_selection = Binding { selection.wrappedValue } set: { selection.wrappedValue = $0 ?? selection.wrappedValue }
		self.content = content
	}

	var body: some View {
		Button {
			isImportPresented = true
		} label: {
			if let selection {
				content(selection)
			} else {
				Text("Select...")
			}
		}
		.sheet(isPresented: $isImportPresented) {
			ModelSheet(selection: $selection, content: content)
		}
	}

}

struct ModelSheet<Model: PersistentModel, Content: View>: View {
	@Environment(\.dismiss) private var dismiss
	@Query private var models: [Model]
	@Binding private var result: Model?
	@State private var selection: Model?

	private let content: (Model) -> Content

	init(selection: Binding<Model?>, @ViewBuilder content: @escaping (Model) -> Content) {
		_result = selection
		self.content = content
	}

	var body: some View {
		List(models, selection: $selection) { model in
			content(model)
				.tag(model)
				.disabled(model == selection)
		}
		.frame(minWidth: 240, minHeight: 180)
		.navigationTitle("Selection")
		.toolbar {
			Button("Cancel", role: .cancel) {
				dismiss()
			}
			Button("Confirm") {
				result = selection
				dismiss()
			}
			.disabled(selection == nil)
		}
	}
}

struct ModelsField<Model: PersistentModel, Contents: View, Content: View>: View {
	@Binding private var selection: [Model]

	private let contents: ([Model]) -> Contents
	private let content: (Model) -> Content

	init(
		selection: Binding<[Model]>,
		@ViewBuilder content: @escaping (Model) -> Content,
		@ViewBuilder label: @escaping ([Model]) -> Contents
	) {
		_selection = selection
		self.contents = label
		self.content = content
	}

	var body: some View {
		NavigationLink {
			ModelsSheet(selection: $selection, content: content)
		} label: {
			contents(selection)
		}
	}
}

struct ModelsSheet<Model: PersistentModel, Content: View>: View {
	@Environment(\.dismiss) private var dismiss
	@Query private var models: [Model]
	@Binding private var value: [Model]
	@State private var modelSelection: Set<Model.ID> = []
	@State private var valueSelection: Set<Model.ID> = []

	private let content: (Model) -> Content

	init(selection: Binding<[Model]>, @ViewBuilder content: @escaping (Model) -> Content) {
		_value = selection
		self.content = content
	}

	private var available: [Model] {
		models.filter { model in
			!value.contains { $0 == model }
		}
	}

	private func append(selection: Set<Model.ID>) {
		guard !selection.isEmpty else { return }
		value.append(contentsOf: models.filter { model in
			selection.contains(model.id)
		})
	}

	private func appendSelected() {
		guard !modelSelection.isEmpty else { return }
		append(selection: modelSelection)
		modelSelection.removeAll(keepingCapacity: true)
	}

	var body: some View {
		HStack(spacing: 0) {
			List(available, selection: $modelSelection) { model in
				content(model)
			}
			.contextMenu(forSelectionType: Model.ID.self) { ids in
				if !ids.isEmpty {
					Button("Add") {
						append(selection: ids)
					}
				}
			} primaryAction: { ids in
				append(selection: ids)
			}
			.padding()

			List($value, selection: $valueSelection) { $model in
				content(model)
			}
			.padding()
		}
		.listStyle(.bordered)
		.navigationTitle("Selections")
		.toolbar {
			Button("Confirm") {
				dismiss()
			}
		}
	}

}
