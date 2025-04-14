//
//  Enviroments.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 04. 12..
//

struct Environment {
    enum Name {
        case prod
        case dev
        case seriesDev
        case seriesProd
    }
#if ENV_PROD
    static let name: Name = .prod
#elseif ENV_DEV
    static let name: Name = .dev
#elseif ENV_TVSERIES_DEV
    static let name: Name = .seriesDev
#else
    static let name: Name = .seriesProd
#endif
}
