//
//  Tag.swift
//  ChipsViewApp
//
//  Created by Bilal Durnagöl on 4.06.2023.
//

import SwiftUI

struct Tag: Identifiable, Equatable, Hashable {
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
}
