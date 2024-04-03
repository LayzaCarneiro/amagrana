// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation
import Rainbow

func setup() {
    Persistence.projectName = "amagrana"
    let json = """
    {"historicos":[],"palavras":[{"palavra":"mirar","anagramas":["mirar","mirra","rimar","riram"]},{"anagramas":["amor","armo","mora","oram","ramo","roam","roma","romã"],"palavra":"amor"},{"palavra":"barco","anagramas":["barco","braço","broca", "cobra"]},{"palavra":"terno","anagramas":["norte","tenor","terno","torne","trenó"]},{"palavra":"carro","anagramas":["carro","corar","corra","orçar","roçar"]},{"anagramas":["carteiros","erráticos","escritora","restrição","retóricas"],"palavra":"carteiros"},
        {"palavra":"alegria", "anagramas":["alegria", "alergia", "galeria", "gelaria", "regalia"]}
    ],"usuarios":[]}
    """.data(using: .utf8)!
    
    do {
        let model = try JSONDecoder().decode(Model.self, from: json)
        Persistence.saveIfEmpty(model: model, filename: "amagrana.json")
    } catch {
        print(error)
    }
}

@main
struct Amagrana: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Acerte o Anagrama e ganhe Grana",
        usage: "amagrana [OPTIONS] [SUBCOMMAND]",
        discussion: """
                   █████╗ ███╗   ███╗ █████╗  ██████╗ ██████╗  █████╗ ███╗   ██╗ █████╗
                  ██╔══██╗████╗ ████║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗████╗  ██║██╔══██╗
                  ███████║██╔████╔██║███████║██║  ███╗██████╔╝███████║██╔██╗ ██║███████║
                  ██╔══██║██║╚██╔╝██║██╔══██║██║   ██║██╔══██╗██╔══██║██║╚██╗██║██╔══██║
                  ██║  ██║██║ ╚═╝ ██║██║  ██║╚██████╔╝██║  ██║██║  ██║██║ ╚████║██║  ██║
                  ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
                   
        O objetivo do jogo é usar as letras disponíveis para formar diversas palavras e ganhar uma "grana" a cada acerto, ganhe o máximo de "grana" possível. É uma ótima atividade pra quem quer treinar a lógica e melhorar o vocabulário.
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
        setup()
        if estatísticas {
            estatisticasPrint()
        } else if instrucoes {
            instrucoesPrint()
        } else if helper {
            menuPrint()
        }
    }
    
    func estatisticasPrint() {
        Persistence.projectName = "amagrana"
        let model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])
        
        print("Nome do usuário que deseja o histórico: ".blue)
        if let usuario = readLine()?.lowercased() {  // entra o nome do usuário em minúsculo
            let qtdHistorico: Int = model.historicos.count
            var historicoEncontrado: Bool = false
            
            if qtdHistorico > 0 {
                for i in 0...qtdHistorico-1 where model.historicos[i].nome == usuario {  // procura o usuário
                    historicoEncontrado = true // usuário é encontrado
                    print("\nHistórico - \(usuario.capitalized): ".blue)
                    var count: Int = 1 // esse count é usado para ordenar os históricos
                    
                    // printa os históricos
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
            }
            if !historicoEncontrado {
                // quer dizer que o usuário não foi encontrado em históricos, então ou não existe o usuário, ou ele não tem um histórico
                print("\nHistórico do usuário não existe.")
            }
            
        }
    }
    
    // função que printa as instruções
    func instrucoesPrint() {
        print("\nSeja bem-vindo às instruções de Amagrana.".blue)
        print("Ao iniciar o jogo, use as letras dadas para formar uma nova palavra (que use toda as letras) e verificar se é um anagrama ou não.".blue)
        print("""
        
        Exemplo:
        
        ----------------------------------
            ó - c - u - l - o - s
        ----------------------------------
        para pedir dica: --dica
        para sair: --sair
            
        ______
        ______
        ______
        
        insira um palavra:
        >> loucos
        
        Resultado:
        
        ----------------------------------
            ó - c - u - l - o - s
        ----------------------------------
        para pedir dica: --dica
        para sair: --sair
        
        
        """)
        print("loucos".yellow)
        print("______\n______\n\n")
        
        print("DICA\nAo pedir dica, você receberá uma nova palavra".blue)
        print("OBS: Para pedir dica, é necessário ter ao menos 1 Grana e acertado uma palavra")
        print("""
        ----------------------------------
            ó - c - u - l - o - s
        ----------------------------------
        para pedir dica: --dica
        para sair: --sair
                
                
        loucos
        ______
        ______
        
        insira uma palavra:
        >> --dica
        
        
        Resultado:
        
        ----------------------------------
            ó - c - u - l - o - s
        ----------------------------------
        para pedir dica: --dica
        para sair: --sair
            
            
        loucos
        _____
        """)
        print("soluço\n\n".yellow)
        
        print("Para sair do jogo:\n".blue)
        print("""
              ----------------------------------
                  ó - c - u - l - o - s
              ----------------------------------
              para pedir dica: --dica
              para sair: --sair
                      
                      
              ______
              ______
              ______
              
              insira uma palavra:
              >> --sair
              """)
        
        print("OBS: Ao sair, o jogo não fica salvo no histórico.".red)
    }
    
    // função que printa o menu
    func menuPrint() {
        print("""
        
        
        
           █████╗ ███╗   ███╗ █████╗  ██████╗ ██████╗  █████╗ ███╗   ██╗ █████╗
          ██╔══██╗████╗ ████║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗████╗  ██║██╔══██╗
          ███████║██╔████╔██║███████║██║  ███╗██████╔╝███████║██╔██╗ ██║███████║
          ██╔══██║██║╚██╔╝██║██╔══██║██║   ██║██╔══██╗██╔══██║██║╚██╗██║██╔══██║
          ██║  ██║██║ ╚═╝ ██║██║  ██║╚██████╔╝██║  ██║██║  ██║██║ ╚████║██║  ██║
          ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝
                                                               
        
        """.blue)
        
        print("      >> START GAME <<           amagrana start        ".blue)
        print("         INSTRUÇÕES              amagrana -i           ".blue)
        print("         ESTATÍSTICAS            amagrana -e           ".blue)
        print("         MENU                    amagrana -h           ".blue)
        print("         HELP                    amagrana --help       ".blue)
        print("\n\n")
    }
}

struct Start: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Para iniciar o jogo",
        usage: "amagrana start",
        discussion: """
        O objetivo do jogo é usar as letras disponíveis para formar diversas palavras e ganhar uma "grana" a cada acerto, ganhe o máximo de "grana" possível. É uma ótima atividade pra quem quer treinar a lógica e quer melhorar o vocabulário.
        """.blue
    )
    
    func run() {
        setup()
        Persistence.projectName = "amagrana"
        let model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])
        
        var usuario: String
        var grana: Int
        var acertos: Int = 0
        var dicas: Int = 0
        var sair: Bool = false // variável utilizada para saber quando o usuário quer sair do jogo (--sair)
        let modelShuffled = model.palavras.shuffled() // para pegar uma palavra aleátoria
        let palavraPrincipal: String = modelShuffled[0].palavra // a palavra que será printada
        let listaPrincipal: [String] = modelShuffled[0].anagramas // lista de anagramas da palavra principal
        var palavrasQueFaltam: [String] = listaPrincipal // lista de palavras que faltam ser encontradas
        let qntdPalavras: Int = palavrasQueFaltam.count
        
        // antes de começar o jogo, vamos validar o usuário
        (usuario, grana) = validarUsuario()
        
        // loop que vai continuar enquanto todas as palavras não forem encontradas/acertadas
        while acertos != qntdPalavras {
            if usuario == "--sair" { // caso o usuário queira sair
                sair = true // para não realizar o último print
                break // sai do while
            }
            // função que printa as letras dadas e os anagramas
            anagramaPrint(palavraPrincipal: palavraPrincipal, listaPrincipal: listaPrincipal, palavrasQueFaltam: palavrasQueFaltam)
            print("\nInsira uma palavra: ".blue)
            
            if let palavraTestada = readLine()?.lowercased() { // entrada do usuário
                if palavraTestada == "--dica" { // se quiser dica, chama a função "dica" e passa os parâmetros dela
                    var deuDica: Bool = false
                    (palavrasQueFaltam, deuDica) = dica(&palavrasQueFaltam, acertos, grana)
                    if deuDica { // se deu certo pedir a dica (tem grana e tem o mínimo de acerto), aumenta os acertos e dicas, e diminui a grana
                        acertos += 1
                        grana -= 1
                        dicas += 1
                    }
                } else if palavraTestada == "--sair"{ // caso o usuário queira sair
                    sair = true // para não realizar o último print/
                    break // sai do while
                } else { // chama a função que confere se a palavra é anagrama
                    (palavrasQueFaltam, acertos, grana) = confere(listaPrincipal, &palavrasQueFaltam, palavraTestada, &acertos, &grana)
                }
                print("\nPalavras Encontradas:  \(acertos)/\(qntdPalavras)") // printa qtd de palavras encontradas
                print("R$ \(grana) Granas 💵\n\n") // printa a grana
                sleep(1)
            }
        }
        if !sair { // usuário não pediu para sair e acertou todas as palavras
            anagramaPrint(palavraPrincipal: palavraPrincipal, listaPrincipal: listaPrincipal, palavrasQueFaltam: palavrasQueFaltam)
            sleep(1)
            if usuario != "Temporário" { // se não for temporário, salva
                print("\nParabéns \(usuario.capitalized), você encontrou todas as palavras!!! Obrigada, por jogar (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧ \n".lightGreen.bold)
                // chama a função que salva os dados
                salvar(usuario, grana, acertos, acertos - dicas, dicas, palavraPrincipal.uppercased(), data())
            } else {
                print("\nParabéns Usuário Aleatório, você encontrou todas as palavras!!! Obrigada, por jogar (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧\nSe quiser salvar seu histórico, CRIE SEU USUÁRIO.".lightGreen.bold)
            }
        }
    }
    
    func validarUsuario() -> (String, Int) {
        let model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])
        var usuario: String = ""
        var grana: Int = 0
        
        print("\nDigite o nome do usuário ou pressione enter para cadastrar: ".blue)
        if let user = readLine()?.lowercased() {
            // caso o usuário entre com um enter
            if user == ""{
                print("Usuário não encontrado. Deseja cadastrar? \n[1] Sim \nOu pressione enter para entrar como usuário temporário: ")
                if let escolha = readLine() {
                    if escolha == "1" {
                        usuario = cadastro() // se quiser realizar o cadastro
                    } else {
                        usuario = "Temporário" // se quiser entrar como usuário temporário
                    }
                }
            }
            // se quiser sair no meio da validação
            else if user == "--sair" {
                return (user, grana)
            } else {
                var verificado: Bool = false
                let qtdUsers: Int = model.usuarios.count
                if qtdUsers > 0 { // confere se tem pelo menos um usuário antes de percorrer a lista
                    for i in 0...qtdUsers-1 where model.usuarios[i].nome == user {
                        verificado = true // confirmar que o usuário foi encontrado, ou seja, verificado
                        usuario = model.usuarios[i].nome // retorna o nome do usuário
                        grana = model.usuarios[i].grana // retorna a grana salva do usuário
                        print("\nOlá, \(model.usuarios[i].nome.capitalized). Vamos jogar ;)".lightRed)
                        print("Pressione enter para começar: ")
                        _ = readLine()
                    }
                }
                if !verificado { // caso não exista o usuário, ou não tenha sido encontrado, cadastra
                    print("\nUsuário não encontrado. Deseja cadastrar? \n[1] Sim \nOu pressione enter para entrar como usuário temporário: ")
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
            if let newUser = readLine()?.lowercased() { // nome a ser cadastrado
                var jaCadastrado: Bool = false
                if qtdUsers > 0 { // caso tenham usuários, percorre a lita para saber se o nome já foi cadastrado
                    for i in 0...qtdUsers-1 where model.usuarios[i].nome == newUser { // já existe usuário com esse nome
                        print("\nUsuário já cadastrado. Tente novamente.".lightRed.bold)
                        jaCadastrado = true // já existe cadastro com esse nome
                    }
                }
                if !jaCadastrado { // se usuário com esse nome não existir
                    model.usuarios.append(Usuario(nome: newUser, grana: 0)) // adiciona na lista com grana = 0
                    cadastrado = true // para sair do loop
                    usuarioCadastrado = newUser // para retornar o nome do usuário cadastrado
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
    
    // função para printar o jogo
    func anagramaPrint (palavraPrincipal: String, listaPrincipal: [String], palavrasQueFaltam: [String]) {
        let arrayPrincipal = Array(palavraPrincipal).shuffled() // transforma a palavra principal em um array
        let tamArray: Int = arrayPrincipal.count
        var palavraEmbaralhada: String = ""
        
        // loop para percorrer o array da palavra embaralhado e formar as letras que sairão no print
        //      exemplo: palavra princiapl = mirar
        //      arrayPrincipal = ['R', 'A', 'I', 'M', 'R']
        //      o loop transforma em: R - A  - I - M - R
        for i in 0...tamArray-1 {
            if i == tamArray - 1 {
                palavraEmbaralhada += String(arrayPrincipal[i]) + "  "
            } else {
                palavraEmbaralhada += String(arrayPrincipal[i]) + "  -  "
            }
        }
        
        print("---------------------------------------")
        print("---------------------------------------")
        print(" \(palavraEmbaralhada)".uppercased().lightRed.bold)
        print("---------------------------------------")
        print("para pedir dica: --dica (revela uma palavra, mas custa 1 grana e você precisa ter acertado alguma palavra)")
        print("para sair: --sair\n".lightRed)
        
        let tam = listaPrincipal.count
        for i in 1...tam { // percorre a lista de anagramas
            let palavra: String = listaPrincipal[i-1]
            // confere se a palavra já foi acertada
            if palavrasQueFaltam.contains(palavra) {
                // se não foi acertada, printa a palavra no formato "_____"
                let substituida = String(repeating: "_", count: palavra.count)
                print(substituida)
            } else {
                print(palavra)
            }
        }
    }
    
    // função que confere se a palavra é um anagrama, tem como parâmetros: a lista de palavras que são anagramas, a lista de palavras que faltam ser acertadas, a palavra que o usuário entrou, a quantidade de acertos e grana atual do usuário
    func confere (_ lista: [String], _ palavrasQueFaltam: inout [String], _ palavraTestada: String, _ acertos: inout Int, _ grana: inout Int) -> ([String], Int, Int) {
        if lista.contains(palavraTestada) { // confere se a palavra que o usuário entrou está na lista de anagramas
            if !palavrasQueFaltam.contains(palavraTestada) { // confere se essa palavra está na lista de palavras que faltam, caso não esteja, já foi encontrada
                print("Você já acertou essa palavra, tente novamente!".yellow)
            } else { // caso esteja nas lista de palavras que faltam, é um acerto
                print("\nAcertou!!!".lightGreen)
            }
            let final: Int = palavrasQueFaltam.count
            for i in 1...final where palavrasQueFaltam[i-1] == palavraTestada { // percorre a lista de palavras que faltam
                palavrasQueFaltam.remove(at: i-1) // remove da lista a palavra que o usuário testou
                acertos += 1 // aumenta acerto
                grana += 1 // aumenta grana
                break // sai do for
            }
        } else { // a palavra não está na lista de anagramas
            print("\nErrou. Tenta de novo.".lightRed)
        }
        return (palavrasQueFaltam, acertos, grana)
    }
    
    // função dica que tem como parâmetros: a lista que vai pegar a palavra aleatória, os acertos e grana do usuário
    func dica (_ lista: inout [String], _ acertos: Int, _ grana: Int) -> ([String], Bool) {
        var deuDica: Bool = false
        if (grana >= 1 && acertos >= 1) { // confere se tem grana e acerto suficiente
            let palavraDica: String = lista.randomElement()! // pega uma palavra aleatória da lista
            let final: Int = lista.count
            for i in 1...final where lista[i-1] == palavraDica { // percorre a lista para remover a palavra aleatória
                lista.remove(at: i-1)
                deuDica = true // deu certo pedir dica
                break
            }
            print("\nPalavra dada: \(palavraDica)".lightGreen) // diz qual a palavra aleatória que foi dada
        } else if grana == 0 { // caso não tenha grana
            print("\nVocê não tem grana o suficiente para pedir dica. Acerte mais.".lightRed)
        } else { // quer dizer que não acertou uma palavra ainda
            print("Você precisa acertar ao menos uma palavra antes de pedir uma dica".lightRed)
        }
        sleep(1)
        
        return (lista, deuDica)
    }
    
    // função para salvar os dados, tem como parâmetros: nome do usuário, grana e acertos dele, a quantidade de dinheiro que foi ganha (acertos - dicas), qtd de dicas pedidas, letras dada e o dia que foi jogado
    func salvar(_ usuario: String, _ grana: Int, _ acertos: Int, _ dinheiro: Int, _ dicas: Int, _ letras: String, _ data: String) {
        var model: Model = (try? Persistence.readJson(file: "amagrana.json")) ?? Model(usuarios: [], palavras: [], historicos: [])
        
        let qtdUsers: Int = model.usuarios.count
        let qtdHistoricos: Int = model.historicos.count
        var historicoSalvo: Bool = false
        
        for i in 0...qtdUsers-1 where model.usuarios[i].nome == usuario {
            model.usuarios[i].grana = grana // atualiza a grana
        }
        if qtdHistoricos > 0 {
            for i in 0...qtdHistoricos-1 where model.historicos[i].nome == usuario {
                model.historicos[i].historico.insert(Historico(acertos: acertos, dinheiro: dinheiro, dicas: dicas, letras: letras, data: data), at: 0) // salva no histórico do usuário
                historicoSalvo = true
            }
        }
        if !historicoSalvo { // quer dizer que o usuário não foi encontrado em históricos, então cria um pra ele
            model.historicos.append(Historicos(nome: usuario, historico: [Historico(acertos: acertos, dinheiro: dinheiro, dicas: dicas, letras: letras, data: data)]))
        }
        do {
            try Persistence.saveJson(model, file: "amagrana.json")
        } catch {
            print(error)
        }
    }
    
    // função para pegar a data do dia jogado no formato dd/MM/yyyy
    func data() -> String {
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
