//
//  Pokemon.swift
//  Pokedex
//
//  Created by Артем Форкунов on 14.10.2020.
//

import Foundation

struct PokemonList: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonData: Codable {
    let id: Int
    let types: [PokemonTypeEntry]
    let sprites: PokemonSprites
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonSprites: Codable {
    let front_default: String
}

struct PokemonSpeciesData: Codable {
    let flavor_text_entries: [FlavorTextEntry]
}

struct FlavorTextEntry: Codable {
    let flavor_text: String
    let language: LanguageEntry
}

struct LanguageEntry: Codable {
    let name: String
}
