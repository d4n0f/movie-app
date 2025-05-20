//
//  Cast.swift
//  movie-app
//
//  Created by Balint Fonad on 2025. 05. 10..
//

struct Cast: Identifiable{
    let id: Int
    let cast: [CastMember]
    
    init () {
        self.id = 0
        self.cast = []
    }
    
    init(id: Int, cast: [CastMember]) {
        self.id = id
        self.cast = cast
    }
    
    init(dto: MovieCreditResponse) {
        self.id = dto.id
        self.cast = dto.cast
            .map(CastMember.init)
    }
}
