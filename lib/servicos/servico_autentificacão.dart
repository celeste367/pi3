// Representa os possíveis níveis de acesso no sistema
enum NivelAcesso { caixa, gerente, admin }

class Usuario {
  final String id;
  final String nome;
  final String email;
  final String senha; // Em um app real, isso seria um hash
  final NivelAcesso nivel;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.nivel,
  });
}

class AuthService {
  // Simulação de um banco de dados de usuários
  static final List<Usuario> _usuarios = [
    Usuario(
      id: '1',
      nome: 'João (Caixa)',
      email: 'caixa@email.com',
      senha: '123',
      nivel: NivelAcesso.caixa,
    ),
    Usuario(
      id: '2',
      nome: 'Maria (Gerente)',
      email: 'gerente@email.com',
      senha: '123',
      nivel: NivelAcesso.gerente,
    ),
    Usuario(
      id: '3',
      nome: 'Admin',
      email: 'admin@email.com',
      senha: '123',
      nivel: NivelAcesso.admin,
    ),
  ];

  // O usuário logado atualmente. Em um app real, use um provedor de estado (Provider, Bloc).
  static Usuario? usuarioLogado;

  Future<Usuario?> login(String email, String senha) async {
    // Simula uma chamada de rede
    await Future.delayed(const Duration(seconds: 1));

    try {
      final usuario = _usuarios.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.senha == senha,
      );
      usuarioLogado = usuario;
      return usuario;
    } catch (e) {
      // Se não encontrar, retorna nulo
      usuarioLogado = null;
      return null;
    }
  }

  void logout() {
    usuarioLogado = null;
  }
}
