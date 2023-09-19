//
//  ModelField.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-15.
//

import SwiftUI
import SwiftData

struct ModelField<Model: PersistentModel, Content: View, Label: View>: View {

	@Binding private var selection: Model?
	@State private var isSheetPresented = false
	private let content: (Model) -> Content
	private let label: Label

	init(
		selection: Binding<Model?>,
		@ViewBuilder content: @escaping (Model) -> Content,
		@ViewBuilder label: @escaping () -> Label
	) {
		_selection = selection
		self.content = content
		self.label = label()
	}

	init(
		selection: Binding<Model>,
		@ViewBuilder content: @escaping (Model) -> Content,
		@ViewBuilder label: @escaping () -> Label
	) {
		self.init(selection: Binding<Model?> { selection.wrappedValue } set: { selection.wrappedValue = $0 ?? selection.wrappedValue }, content: content, label: label)
	}

	var body: some View {
		Button {
			isSheetPresented = true
		} label: {
			label
		}
		.sheet(isPresented: $isSheetPresented) {
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

	init(
		selection: Binding<Model?>,
		@ViewBuilder content: @escaping (Model) -> Content
	) {
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

struct ModelsField<Model: PersistentModel, Content: View, Label: View>: View {
	@Binding private var selection: [Model]

	private let content: (Model) -> Content
	private let label: Label

	init(
		selection: Binding<[Model]>,
		@ViewBuilder content: @escaping (Model) -> Content,
		@ViewBuilder label: @escaping () -> Label
	) {
		_selection = selection
		self.content = content
		self.label = label()
	}

	var body: some View {
		NavigationLink {
			ModelsSheet(selection: $selection, content: content)
		} label: {
			label
		}
	}
}

struct ModelsSheet<Model: PersistentModel, Content: View>: View {
	@Environment(\.dismiss) private var dismiss
	@Query private var models: [Model]
	@Binding private var value: [Model]
	@State private var selection: Set<Model> = []

	private let content: (Model) -> Content

	init(selection: Binding<[Model]>, @ViewBuilder content: @escaping (Model) -> Content) {
		_value = selection
		self.content = content
	}

	private func contains(_ model: Model) -> Bool {
		value.contains { $0.id == model.id }
	}

	private func firstIndex(of model: Model) -> Int? {
		value.firstIndex { $0.id == model.id }
	}

	private func set(_ model: Model, to selection: Bool) {
		if selection {
			value.append(model)
		} else if let i = value.firstIndex(where: { $0.id == model.id }) {
			value.remove(at: i)
		}
	}

	private func toggle(_ model: Model) {
		if let i = firstIndex(of: model) {
			value.remove(at: i)
		} else {
			value.append(model)
		}
	}

	var body: some View {
		HStack(spacing: 0) {
			List(models, selection: $selection) { model in
				Toggle(isOn: Binding {
					contains(model)
				} set: {
					set(model, to: $0)
				}) {
					content(model)
				}
				.keyboardShortcut(.space)
				.tag(model)
			}
			.contextMenu(forSelectionType: Model.self) { models in
				if !models.isEmpty {
					Button("Select") {
						let selected = Set(value.lazy.map(\.id))
						for model in models where !selected.contains(model.id) {
							set(model, to: true)
						}
					}
					Button("Deselect") {
						for model in models {
							if let i = firstIndex(of: model) {
								value.remove(at: i)
							}
						}
					}
					Button("Toggle selection") {
						for model in models {
							toggle(model)
						}
					}
				}
			} primaryAction: { models in
				for model in models {
					toggle(model)
				}
			}
			.padding()

			List($value, editActions: .all) { $model in
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
