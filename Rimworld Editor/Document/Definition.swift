//
//  Definition.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-24.
//

import SwiftUI
import SwiftData

public protocol Definition: PersistentModel {

	associatedtype DefinitionLabelView: View
	associatedtype LabelView: View
	associatedtype EditorView: View

	init(_ identifier: String, title: String)

	var label: LabelView { get }
	var editor: EditorView { get }

	static var label: DefinitionLabelView { get }

}
