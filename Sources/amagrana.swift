// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import Rainbow
import ArgumentParser

@main
struct Amagrana: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Acerte o Anagrama e ganhe Grana.",
        usage:
        """
            amagrana menu [OPTIONS]
        """,
        discussion: """
        O objetivo do jogo é usar as letras disponíveis para formar diversas palavras e ganhar uma "grana" a cada acerto, ganhe o máximo de "grana" possível. É uma ótima atividade pra quem quer treinar a lógica e melhorar o vocabulário.
        """,
        subcommands: [Start.self]
    )
    @Flag (name: .shortAndLong, help: "Acessa as instruções do jogo")
    var instrucoes = false
    
    @Flag (name: .shortAndLong, help: "Abre o menu")
    var menu = false
    
    @Flag (name: .shortAndLong, help: "Obtém o histórico do jogador")
    var estatísticas = false
    
    func run() {
        Persistence.projectName = "amagrana"
        let model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])
        
        if estatísticas {
            print("Nome do usuário que deseja o histórico: ".blue)
            if let usuario = readLine() {
                let qtdHistorico: Int = model.historicos.count
                var historicoEncontrado: Bool = false
                                
                for i in 0...qtdHistorico-1 {
                    if model.historicos[i].nome == usuario {
                        historicoEncontrado = true
                        print("\nHistórico - \(usuario): ".blue)
                        var count: Int = 1
                        
                        for i in model.historicos[i].historico {
                            print(" \(count). Acertos: \(i.acertos)")
                            print("    Dinheiro: R$ \(i.dinheiro)")
                            print("    Dicas: \(i.dicas)")
                            print("    Letras dadas: \(i.letras)")
                            print("    Data: \(i.data)")
                            print("\n")
                            count += 1
                        }
                        break
                    }
                }
                
                if !historicoEncontrado {
                    print("\nHistórico não encontrado.")
                }
                    
            }
        }
        if instrucoes {
            print("Seja bem-vindo as instruções de Amagrana.".blue)
            print("Ao iniciar o jogo, use letras minúsculas para verificar as palavras.".blue)
            
            print("""
        
        Exemplo:
        
        ----------------------------------
            ó - c - u - l - o - s
        ----------------------------------
        para pedir dica: --dica
        para sair: --sair
        
        ______
        ______
        
        insira um palavra
        loucos
        
        Resultado:
        
        ----------------------------------
            ó - c - u - l - o - s
        ----------------------------------
        para pedir dica: --dica
        para sair: --sair
        
        
        loucos
        ______
        
        """)
            
            print("Ao pedir dica, você receberá uma nova palavra".blue)
            print("OBS: É necessário ter ao menos 1 Grana para pedir dica")
            print("""
        
        ----------------------------------
            ó - c - u - l - o - s
        ----------------------------------
        para pedir dica: --dica
        para sair: --sair
                
                
        loucos
        ______
        
        insira uma palavra
        --dica
        
        ----------------------------------
            ó - c - u - l - o - s
        ----------------------------------
        para pedir dica: --dica
        para sair: --sair
                
                
        loucos
        soluço
        """)
        }
        
        if menu {
            menuPrint()
        }
    }
    
    func menuPrint() {
        print("""
        
        
        
           █████╗ ███╗   ███╗ █████╗  ██████╗ ██████╗  █████╗ ███╗   ██╗ █████╗
          ██╔══██╗████╗ ████║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗████╗  ██║██╔══██╗
          ███████║██╔████╔██║███████║██║  ███╗██████╔╝███████║██╔██╗ ██║███████║
          ██╔══██║██║╚██╔╝██║██╔══██║██║   ██║██╔══██╗██╔══██║██║╚██╗██║██╔══██║
          ██║  ██║██║ ╚═╝ ██║██║  ██║╚██████╔╝██║  ██║██║  ██║██║ ╚████║██║  ██║
          ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
                                                                              
        """.blue)
        
        print("       START GAME              swift run amagrana start        ".blue)
        print("       INSTRUÇÕES              swift run amagrana -i           ".blue)
        print("       ESTATÍSTICAS            swift run amagrana -e           ".blue)
        print("\n\n")
    }
        
}

struct Start: ParsableCommand {
    func run() {
        Persistence.projectName = "amagrana"
        let model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])

        var usuario: String
        var grana: Int
        (usuario, grana) = validarUsuario()
        
        let modelShuffled = model.palavras.shuffled()
        var sair: Bool = false
        let palavraPrincipal: String = modelShuffled[0].palavra
        let listaPrincipal: [String] = modelShuffled[0].anagramas
        var acertos: Int = 0
        var dicas: Int = 0
        var palavrasQueFaltam: [String] = listaPrincipal
        let qntdPalavras: Int = palavrasQueFaltam.count
 
        while acertos != qntdPalavras {
            print("----------------------------------\n----------------------------------")
            print("\(palavraPrincipal)".uppercased().blue.bold)
            print("----------------------------------")
            print("para pedir dica: --dica")
            print("para sair: --sair\n".lightRed)
        
            
            let tam = listaPrincipal.count
            for i in 1...tam {
                let palavra: String = listaPrincipal[i-1]
                if palavrasQueFaltam.contains(palavra) {
                    let substituida = String(repeating: "_", count: palavra.count)
                    print(substituida)
                } else {
                    print("\(palavra)")
                }
            }
//            sleep (1)
            print("\nInsira uma palavra: ".blue)
            
            if let palavraTestada = readLine() {
                
                if palavraTestada == "--dica" {
                    dicas += 1
                    (palavrasQueFaltam, acertos, grana) = dica(&palavrasQueFaltam, &acertos, grana: &grana)
                } else if palavraTestada == "--sair"{
                    sair = true
                    break
                } else {
                    (palavrasQueFaltam, acertos, grana) = confere(listaPrincipal, &palavrasQueFaltam, palavraTestada, &acertos, &grana)
                }
                print("\nAcertos: \(acertos)/\(qntdPalavras)\n")
                
                print("R$ \(grana) Granas 💵\n\n")
                sleep (1)
//                print("Pressione enter para continuar: ")
//                _ = readLine()
            }
        }
        if !sair {
            print("Parabéns \(usuario), você encontrou todas as palavras !!!\n".blue)
            if usuario != "Temporário" {
                salvar(usuario, grana, acertos: acertos, dinheiro: acertos - dicas, dicas: dicas, letras: palavraPrincipal, data: data())
            }
        }
    }
    
    func validarUsuario() -> (String, Int) {
        let model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])
        var usuario: String = ""
        var grana: Int = 0
        
        print("\nDigite o usuário: ".blue)
        if let user = readLine() {
            if user == ""{
                print("Usuário não encontrado. Deseja cadastrar? \n[1] Sim \nOu pressione enter para entrar como usuário temporário: ")
                sleep(2)
                if let escolha = readLine() {
                    if escolha == "1" {
                        usuario = cadastro()
                    } else {
                        usuario = "Temporário"
                    }
                }
            } else {
                var verificado: Bool = false
                let qtdUsers: Int = model.usuarios.count
                for i in 0...qtdUsers-1 {
                    if model.usuarios[i].nome == user {
                        verificado = true
                        usuario = model.usuarios[i].nome
                        grana = model.usuarios[i].grana
                        print("Olá, \(model.usuarios[i].nome). Vamos jogar ;)")
                        print("Pressione enter para começar: ")
                        _ = readLine()
                    }
                }
                if !verificado {
                    print("Usuário não encontrado. Deseja cadastrar? \n[1] Sim \nOu pressione enter para entrar como usuário temporário: ")
                    sleep(2)
                    if let escolha = readLine() {
                        if escolha == "1" {
                            usuario = cadastro()
                        } else {
                            usuario = "Temporário"
                        }
                    }
                    
                }
            }
        }
        return (usuario, grana)
    }
    
    func cadastro() -> String {
        var model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])
        let qtdUsers: Int = model.usuarios.count
        
        var usuarioCadastrado: String = ""
        var cadastrado: Bool = false
        while !cadastrado {
            print("\nNome do usuário que deseja cadastrar: ")
            if let newUser = readLine() {
                var jaCadastrado: Bool = false
                for i in 0...qtdUsers-1 {
                    if model.usuarios[i].nome == newUser {
                        print("Usuário já cadastrado. Tente novamente.")
                        jaCadastrado = true
                    }
                }
                if !jaCadastrado {
                    model.usuarios.append(Usuario(nome: newUser, grana: 0))
                    cadastrado = true
                    usuarioCadastrado = newUser
                    print("Cadastro realizado com sucesso.\n")
                }
            }
        }
        
        try? Persistence.saveJson(model, file: "amagrana.json")
        return usuarioCadastrado
    }
    
    func confere (_ lista: [String], _ palavrasQueFaltam: inout [String], _ palavraTestada: String, _ acertos: inout Int, _ grana: inout Int) -> ([String], Int, Int) {
        if lista.contains(palavraTestada) {
            let final: Int = palavrasQueFaltam.count
            for i in 1...final {
                if palavrasQueFaltam[i-1] == palavraTestada {
                    palavrasQueFaltam.remove(at: i-1)
                    acertos += 1
                    grana += 1
                    break
                }
            }
            print("Acertou!!!")
        } else {
            print("Errou. Tenta de novo.")
        }
        
        return (palavrasQueFaltam, acertos, grana)
    }
    
    func dica (_ lista: inout [String], _ acertos: inout Int, grana: inout Int) -> ([String], Int, Int) {
        if grana >= 1 {
            let palavraDica: String? = lista.randomElement()
            let final: Int = lista.count
            for i in 1...final {
                if lista[i-1] == palavraDica {
                    lista.remove(at: i-1)
                    grana -= 1
                    acertos += 1
                    break
                }
            }
            print("Palavra dada: \(palavraDica ?? "naosei")")
        } else {
            print("Você está sem grana.")
        }
        return (lista, acertos, grana)
    }
    
    func salvar(_ usuario: String, _ grana: Int, acertos: Int, dinheiro: Int, dicas: Int, letras: String, data: String) {
        var model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])
        
        let qtdUsers: Int = model.usuarios.count
        let qtdHistoricos: Int = model.historicos.count
        for i in 0...qtdUsers-1 {
            if model.usuarios[i].nome == usuario {
                model.usuarios[i].grana = grana
            }
        }
        var historicoSalvo: Bool = false
        for i in 0...qtdHistoricos-1 {
            if model.historicos[i].nome == usuario {
                model.historicos[i].historico.insert(Historico(acertos: acertos, dinheiro: dinheiro, dicas: dicas, letras: letras, data: data), at: 0)
                historicoSalvo = true
            }
        }
        
        if !historicoSalvo {
            model.historicos.append(Historicos(nome: usuario, historico: [Historico(acertos: acertos, dinheiro: dinheiro, dicas: dicas, letras: letras, data: data)]))
        }
    
        try? Persistence.saveJson(model, file: "amagrana.json")
    }
    
    func data() -> String{
        let agora = Date()

        let formatador = DateFormatter()
        formatador.dateFormat = "dd/MM/yyyy"
        let dataAtual = formatador.string(from: agora)

        return dataAtual
    }
}

//        do {
//            let model: Model = try Persistence.readJson(file: "amagrana.json")
//            print(model.palavras.count)
//        } catch {
//            print(error)
//        }
//        model.usuarios.append(Usuario(nome: "gabi", grana: -1))
//        try? Persistence.saveJson(model, file: "amagrana.json")
//        if let model: Model = try? Persistence.readJson(file: "amagrana.json") {
//
//        }
//
//        guard let model: Model = try? Persistence.readJson(file: "amagrana.json") else {
//            return
//        }
//        print(model)
