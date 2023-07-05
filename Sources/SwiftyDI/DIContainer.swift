//
//  Dependencies.swift
//  QiitaExample
//
//  Created by Riku Yamane on 2021/04/15.
//

import Foundation

public class DIContainer {

    private(set) static var shared = DIContainer()

    fileprivate var dependencies = [Dependency]()
    
    @resultBuilder
    public struct DependencyBuilder {
        public static func buildBlock(_ dependencies: Dependency...) -> [Dependency] { dependencies }
    }

    public convenience init(@DependencyBuilder _ dependencies: () -> [Dependency]) {
        self.init()
        dependencies().forEach { register($0) }
    }    

    public func build() {
        for index in dependencies.startIndex..<dependencies.endIndex {
            dependencies[index].resolve()
        }
        Self.shared = self
    }

    public func resolve<T>() -> T {
        let instance: T? = {
            guard let dependency = dependencies.first(where: { $0.value is T }) else {
                return nil
            }
            switch dependency.scope {
            case .application:
                return dependency.value as? T
            case .standard:
                return dependency.newInstance() as? T
            }
        }()
        guard let instance = instance else {
            fatalError("\(T.self)の依存関係の取得に失敗しました。")
        }
        return instance
    }
    
    private func register(_ dependency: Dependency) {
        
        guard !dependencies.contains(where: { $0.name == dependency.name }) else {
            fatalError("\(String(describing: dependency.name)) は既にコンテナに登録されています。")
        }
        dependencies.append(dependency)
    }
}
