//
//  Sidebar.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-02-24.
//

import SwiftUI

struct Sidebar: View {
	@Bindable private var navigation: Navigation<AppRoutes>

	init(_ navigation: Navigation<AppRoutes>) {
		self.navigation = navigation
	}

	var body: some View {
		List(selection: navigation.bindable.route) {
			Section("Project") {
				AppRoutes.manifest.link
				AppRoutes.publishing.link
			}
			Section("Definitions") {
				AppRoutes.projectile.link
				AppRoutes.researchProjects.link
			}
		}
	}

}
