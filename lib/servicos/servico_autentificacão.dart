enum NivelAcesso { caixa, gerente, admin }

class Usuario {
  final String id;
  final String nome;
  final String email;
  final String senha;
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
      senha: '1234',
      nivel: NivelAcesso.gerente,
    ),
    Usuario(
      id: '3',
      nome: 'Admin',
      email: 'admin@email.com',
      senha: '12345',
      nivel: NivelAcesso.admin,
    ),
  ];

  static Usuario? usuarioLogado;

  Future<Usuario?> login(String email, String senha) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final usuario = _usuarios.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.senha == senha,
      );
      usuarioLogado = usuario;
      return usuario;
    } catch (e) {
      usuarioLogado = null;
      return null;
    }
  }

  void logout() {
    usuarioLogado = null;
  }
}
