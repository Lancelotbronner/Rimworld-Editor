//
//  Bullet Definition.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-24.
//

import SwiftUI
import SwiftData

@Model public final class Projectile: EditableModel {

	/// The name of the bullet
	public var identifier: String
	// defName

	/// The bullet's display name
	public var title: String
	// label

//	public var graphics: Graphics
	// graphicData

	/// The type of damage this bullet inflicts
	public var kind = ""
	// projectile/damageDef

	/// How much damage this bullet inflicts
	public var damage = 0
	// projectile/damageAmountBase

	public var stoppingPower = 0
	// projectile/stoppingPower

	/// How fast this bullet travels
	public var speed = 0
	// projectile/speed

	public init(_ title: String) {
		self.identifier = "projectile:\(title)"
		self.title = title
	}

	public static var label: some View {
		Label("Projectile", systemImage: "soccerball")
	}

	public var label: some View {
		Label(title, systemImage: "soccerball")
	}

	public var editor: some View {
		ProjectileEditor(self)
	}

}

public struct ProjectileEditor: View {

	@Bindable private var definition: Projectile

	public init(_ definition: Projectile) {
		self.definition = definition
	}

	public var body: some View {
		Form {
			TextField("Identifier", text: $definition.identifier)
			TextField("Title", text: $definition.title)
			Section("Projectile") {
				TextField("Kind", text: $definition.kind)
				TextField("Damage", value: $definition.damage, format: .number)
				TextField("Stopping Power", value: $definition.stoppingPower, format: .number)
				TextField("Speed", value: $definition.speed, format: .number)
			}
		}
	}

}
