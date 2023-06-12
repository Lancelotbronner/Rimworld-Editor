//
//  AppNavigation.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-07.
//

import SwiftUI

public enum AppRoutes: Routes, CaseIterable {

	case manifest
	case publishing

	case projectile
	case researchProjects

	public var id: AppRoutes { self }
}

extension AppRoutes {

	@ViewBuilder
	public var label: some View {
		switch self {
		case .manifest: Label("Manifest", systemImage: "doc.text")
		case .publishing: Label("Publishing", systemImage: "network")
		case .projectile: Projectile.label
		case .researchProjects: ResearchProject.label
		}
	}

	public var link: some View {
		NavigationLink(value: self) {
			label
		}
	}

	public var tab: some View {
		destination
			.tag(self as AppRoutes?)
			.tabItem { label }
	}

	@ViewBuilder
	public var destination: some View {
		switch self {
		case .manifest: ManifestPage()
		case .publishing: PublishingPage()
		case .projectile: DefinitionPage<Projectile>()
		case .researchProjects: DefinitionPage<ResearchProject>()
		}
	}

}
