//
//  Goal.swift
//  HealthAppTest
//
//  Created by Martin Varga on 23/02/2022.
//

import Foundation

struct Goal: Hashable, Identifiable {
    var id: String { name }
    var name: String
}
