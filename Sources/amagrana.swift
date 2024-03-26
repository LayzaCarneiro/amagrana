// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import ArgumentParser
import Rainbow

@main
struct Amagrana: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Acerte o Anagrama e ganhe Grana.",
        usage:
        """
            amagrana menu [OPTIONS]
                    or
            swift run amagrana start
        """,
        discussion: """
                   █████╗ ███╗   ███╗ █████╗  ██████╗ ██████╗  █████╗ ███╗   ██╗ █████╗
                  ██╔══██╗████╗ ████║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗████╗  ██║██╔══██╗
                  ███████║██╔████╔██║███████║██║  ███╗██████╔╝███████║██╔██╗ ██║███████║
                  ██╔══██║██║╚██╔╝██║██╔══██║██║   ██║██╔══██╗██╔══██║██║╚██╗██║██╔══██║
                  ██║  ██║██║ ╚═╝ ██║██║  ██║╚██████╔╝██║  ██║██║  ██║██║ ╚████║██║  ██║
                  ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
                   
        O objetivo do jogo é usar as letras disponíveis para formar diversas palavras e ganhar uma "grana" a cada acerto, ganhe o máximo de "grana" possível. É uma ótima atividade pra quem quer treinar a lógica e quer melhorar o vocabulário.
        """.blue,
        subcommands: [Start.self]
    )
    @Flag (name: .shortAndLong, help: "Acessa as instruções do jogo.")
    var instrucoes = false
    
    @Flag (name: .shortAndLong, help: "Acessa mais informações sobre o jogo.")
    var helper = false
    
    @Flag (name: .shortAndLong, help: "Obtém o histórico do jogador.")
    var estatísticas = false
    
    func run() {
        Persistence.projectName = "amagrana"
        let model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])
        
        if estatísticas {
            print("Nome do usuário que deseja o histórico: ".blue)
            if let usuario = readLine()?.lowercased() {
                let qtdHistorico: Int = model.historicos.count
                var historicoEncontrado: Bool = false
                
                for i in 0...qtdHistorico-1 where model.historicos[i].nome == usuario {
                    historicoEncontrado = true
                    print("\nHistórico - \(usuario): ".blue)
                    var count: Int = 1
                    
                    for i in model.historicos[i].historico {
                        print(" \(count). Acertos: \(i.acertos)")
                        print("    Dinheiro ganho: R$ \(i.dinheiro)")
                        print("    Dicas: \(i.dicas)")
                        print("    Letras dadas: \(i.letras)")
                        print("    Data: \(i.data)")
                        print("\n")
                        count += 1
                    }
                    break
                    
                }
                if !historicoEncontrado {
                    print("\nHistórico não encontrado.")
                }
                
            }
        }
        if instrucoes {
            instrucoesPrint()
        }
        
        if helper {
            menuPrint()
        }
    }
    
    func instrucoesPrint(){
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
    
    func menuPrint() {
        print("""
        
        
        
           █████╗ ███╗   ███╗ █████╗  ██████╗ ██████╗  █████╗ ███╗   ██╗ █████╗
          ██╔══██╗████╗ ████║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗████╗  ██║██╔══██╗
          ███████║██╔████╔██║███████║██║  ███╗██████╔╝███████║██╔██╗ ██║███████║
          ██╔══██║██║╚██╔╝██║██╔══██║██║   ██║██╔══██╗██╔══██║██║╚██╗██║██╔══██║
          ██║  ██║██║ ╚═╝ ██║██║  ██║╚██████╔╝██║  ██║██║  ██║██║ ╚████║██║  ██║
          ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
                                                               
        
        """.blue)
        
        print("    >> START GAME <<           swift run amagrana start        ".blue)
        print("       INSTRUÇÕES              swift run amagrana -i           ".blue)
        print("       ESTATÍSTICAS            swift run amagrana -e           ".blue)
        print("       MENU                    swift run amagrana -h           ".blue)
        print("       HELP                    swift run amagrana --help       ".blue)
        print("\n\n")
    }
}

struct Start: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Acerte o Anagrama e ganhe Grana.",
        usage:
        """
            swift run amagrana start
        """,
        discussion: """
        O objetivo do jogo é usar as letras disponíveis para formar diversas palavras e ganhar uma "grana" a cada acerto, ganhe o máximo de "grana" possível. É uma ótima atividade pra quem quer treinar a lógica e quer melhorar o vocabulário.
        """.blue
    )
    
    func run() {
        Persistence.projectName = "amagrana"
        let model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])
        
        var usuario: String
        var grana: Int
        var acertos: Int = 0
        var dicas: Int = 0
        var sair: Bool = false
        let modelShuffled = model.palavras.shuffled()
        let palavraPrincipal: String = modelShuffled[0].palavra
        let listaPrincipal: [String] = modelShuffled[0].anagramas
        var palavrasQueFaltam: [String] = listaPrincipal
        let qntdPalavras: Int = palavrasQueFaltam.count
        (usuario, grana) = validarUsuario()
        
        while acertos != qntdPalavras {
            if usuario == "--sair" {
                sair = true
                break
            }
            anagramaPrint(palavraPrincipal: palavraPrincipal, listaPrincipal: listaPrincipal, palavrasQueFaltam: palavrasQueFaltam)
            print("\nInsira uma palavra: ".blue)
            
            if let palavraTestada = readLine()?.lowercased() {
                if palavraTestada == "--dica" {
                    dicas += 1
                    (palavrasQueFaltam, acertos, grana) = dica(&palavrasQueFaltam, &acertos, grana: &grana)
                } else if palavraTestada == "--sair"{
                    sair = true
                    break
                } else {
                    (palavrasQueFaltam, acertos, grana) = confere(listaPrincipal, &palavrasQueFaltam, palavraTestada, &acertos, &grana)
                }
                print("\nPalavras Encontradas:  \(acertos)/\(qntdPalavras)")
                print("R$ \(grana) Granas 💵\n\n")
                sleep(1)
            }
        }
        if !sair {
            anagramaPrint(palavraPrincipal: palavraPrincipal, listaPrincipal: listaPrincipal, palavrasQueFaltam: palavrasQueFaltam)
            sleep(1)
            if usuario != "Temporário" {
                print("\nParabéns \(usuario.capitalized), você encontrou todas as palavras!!! Obrigada, por jogar :)\n".lightGreen.bold)
                salvar(usuario, grana, acertos, acertos - dicas, dicas, palavraPrincipal, data())
            } else {
                print("\nParabéns Usuário Aleatório, você encontrou todas as palavras!!! Obrigada, por jogar :)\nSe quiser salvar seu histórico, CRIE SEU USUÁRIO.".lightGreen.bold)
            }
        }
    }
    
    func validarUsuario() -> (String, Int) {
        let model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])
        var usuario: String = ""
        var grana: Int = 0
        
        print("\nDigite o nome do usuário ou pressione enter para cadastrar: ".blue)
        if let user = readLine()?.lowercased() {
            if user == ""{
                print("Usuário não encontrado. Deseja cadastrar? \n[1] Sim \nOu pressione enter para entrar como usuário temporário: ")
                
                if let escolha = readLine() {
                    if escolha == "1" {
                        usuario = cadastro()
                    } else {
                        usuario = "Temporário"
                    }
                }
            } else if user == "--sair" {
                return (user, grana)
            } else {
                var verificado: Bool = false
                let qtdUsers: Int = model.usuarios.count
                if qtdUsers > 0 {
                    for i in 0...qtdUsers-1 where model.usuarios[i].nome == user {
                        verificado = true
                        usuario = model.usuarios[i].nome
                        grana = model.usuarios[i].grana
                        print("\nOlá, \(model.usuarios[i].nome.capitalized). Vamos jogar ;)".lightRed)
                        print("Pressione enter para começar: ")
                        _ = readLine()
                    }
                }
                if !verificado {
                    print("\nUsuário não encontrado. Deseja cadastrar? \n[1] Sim \nOu pressione enter para entrar como usuário temporário: ")
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
            if let newUser = readLine()?.lowercased() {
                var jaCadastrado: Bool = false
                if qtdUsers > 0 {
                    for i in 0...qtdUsers-1 where model.usuarios[i].nome == newUser {
                        print("\nUsuário já cadastrado. Tente novamente.".lightRed.bold)
                        jaCadastrado = true
                    }
                }
                if !jaCadastrado {
                    model.usuarios.append(Usuario(nome: newUser, grana: 0))
                    cadastrado = true
                    usuarioCadastrado = newUser
                    print("\nCadastro realizado com sucesso.".lightGreen.bold)
                    print("Pressione enter para começar o jogo, \(usuarioCadastrado.capitalized): ")
                    _ = readLine()
                }
            }
        }
        do {
            try Persistence.saveJson(model, file: "amagrana.json")
        } catch {
            print(error)
        }
        
        return usuarioCadastrado
    }
    
    func anagramaPrint (palavraPrincipal: String, listaPrincipal: [String], palavrasQueFaltam: [String]) {
        let arrayPrincipal = Array(palavraPrincipal).shuffled()
        let tamArray: Int = arrayPrincipal.count
        var palavraEmbaralhada: String = ""
        
        for i in 0...tamArray-1 {
            if i == tamArray - 1 {
                palavraEmbaralhada += String(arrayPrincipal[i]) + "  "
            } else {
                palavraEmbaralhada += String(arrayPrincipal[i]) + "  -  "
            }
        }
        
        print("----------------------------------")
        print("----------------------------------")
        print("\(palavraEmbaralhada)".uppercased().lightRed.bold)
        print("----------------------------------")
        print("para pedir dica: --dica\n(Ao acertar uma palavra, você pode comprar uma dica que revela uma palavra)")
        print("para sair: --sair\n".lightRed)
        
        let tam = listaPrincipal.count
        for i in 1...tam {
            let palavra: String = listaPrincipal[i-1]
            if palavrasQueFaltam.contains(palavra) {
                let substituida = String(repeating: "_", count: palavra.count)
                print(substituida)
            } else {
                print(palavra)
            }
        }
    }
    
    func confere (_ lista: [String], _ palavrasQueFaltam: inout [String], _ palavraTestada: String, _ acertos: inout Int, _ grana: inout Int) -> ([String], Int, Int) {
        if lista.contains(palavraTestada) {
            if !palavrasQueFaltam.contains(palavraTestada) {
                print("Você já acertou essa palavra, tente novamente!".yellow)
            } else {
                print("\nAcertou!!!".lightGreen)
            }
            let final: Int = palavrasQueFaltam.count
            for i in 1...final where palavrasQueFaltam[i-1] == palavraTestada {
                palavrasQueFaltam.remove(at: i-1)
                acertos += 1
                grana += 1
                break
                
            }
        } else {
            print("\nErrou. Tenta de novo.".lightRed)
        }
        
        return (palavrasQueFaltam, acertos, grana)
    }
    
    func dica (_ lista: inout [String], _ acertos: inout Int, grana: inout Int) -> ([String], Int, Int) {
        if (grana >= 1 && acertos >= 1) {
            let palavraDica: String = lista.randomElement()!
            let final: Int = lista.count
            for i in 1...final where lista[i-1] == palavraDica {
                lista.remove(at: i-1)
                grana -= 1
                acertos += 1
                break
            }
            print("\nPalavra dada: \(palavraDica)".lightGreen)
        } else if grana == 0 {
            print("\nVocê não tem grana o suficiente para pedir dica. Acerte mais.".lightRed)
        } else {
            print("Você precisa acertar ao menos uma palavra antes de pedir uma dica".lightRed)
        }
        
        sleep(1)
        
        return (lista, acertos, grana)
    }
    
    func salvar(_ usuario: String, _ grana: Int, _ acertos: Int, _ dinheiro: Int, _ dicas: Int, _ letras: String, _ data: String) {
        var model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])
        
        let qtdUsers: Int = model.usuarios.count
        let qtdHistoricos: Int = model.historicos.count
        var historicoSalvo: Bool = false
        
        for i in 0...qtdUsers-1 where model.usuarios[i].nome == usuario {
            model.usuarios[i].grana = grana
        }
        
        if qtdHistoricos > 0 {
            for i in 0...qtdHistoricos-1 where model.historicos[i].nome == usuario {
                model.historicos[i].historico.insert(Historico(acertos: acertos, dinheiro: dinheiro, dicas: dicas, letras: letras, data: data), at: 0)
                historicoSalvo = true
            }
        }
        
        if !historicoSalvo {
            model.historicos.append(Historicos(nome: usuario, historico: [Historico(acertos: acertos, dinheiro: dinheiro, dicas: dicas, letras: letras, data: data)]))
        }
        
        do{
            try Persistence.saveJson(model, file: "amagrana.json")
        } catch {
            print(error)
        }
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
// 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
