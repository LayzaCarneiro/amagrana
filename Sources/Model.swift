//
//  Model.swift
//
//
//  Created by User on 15/03/24.
//

import Foundation

struct Model: Codable {
    var usuarios: [Usuario]
    var palavras: [Palavra]
    var historicos: [Historicos]
}

struct Palavra: Codable {
    var palavra: String
    var anagramas: [String]
}

struct Usuario: Codable {
    var nome: String
    var grana: Int
}

struct Historicos: Codable {
    var nome: String
    var historico: [Historico]
}

struct Historico: Codable {
    var acertos: Int
    var dinheiro: Int
    var dicas: Int
    var letras: String
    var data: String
}

// Bundle  x  Sandbox
//  read     write/read

// ~/.amagrana/model.json
