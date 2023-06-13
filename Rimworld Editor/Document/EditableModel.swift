//
//  Definition.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-24.
//

import SwiftUI
import SwiftData

public protocol EditableModel: PersistentModel {

	associatedtype IdentityView: View
	associatedtype LabelView: View
	associatedtype EditorView: View

	init(_ title: String)

	var label: LabelView { get }
	var editor: EditorView { get }

	static var label: IdentityView { get }

}
