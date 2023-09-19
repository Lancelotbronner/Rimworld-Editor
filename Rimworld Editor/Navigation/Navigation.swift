//
//  Navigation.swift
//  Rimworld Editor
//
//  Created by Christophe Bronner on 2023-06-07.
//

import SwiftUI
import SwiftData

public protocol Routes: Codable, Hashable, Identifiable where ID == Self {

}

@Observable public final class Navigation<Route: Routes> {

	public var route: Route? = nil
	public var path = NavigationPath()

	public init() { }

}
