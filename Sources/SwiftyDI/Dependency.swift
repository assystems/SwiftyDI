//
//  Dependency.swift
//  QiitaExample
//
//  Created by Riku Yamane on 2021/04/15.
//

import Foundation

public struct Dependency {
    
    public enum Scope {
        case standard
        case application
    }
    
    public typealias ResolveBlock<T> = () -> T

    private(set) var value: Any!
    private let resolveBlock: ResolveBlock<Any>
    let name: String
    let scope: Scope

    public init<T>(scope: Scope = .standard,
            _ block: @escaping ResolveBlock<T>) {
        self.scope = scope
        resolveBlock = block
        name = String(describing: T.self)
    }
    
    public mutating func resolve() {
        value = resolveBlock()
    }
    
    func newInstance() -> Any {
        resolveBlock()
    }
}
