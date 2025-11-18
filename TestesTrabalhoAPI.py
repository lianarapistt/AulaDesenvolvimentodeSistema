import unittest
import copy
from fastapi.testclient import TestClient

# Importa o 'app' e o banco de dados 'alunos_db' do seu arquivo
from TrabalhoAPI import app, alunos_db, Aluno

ALUNOS_DB_INICIAL = {
    1: Aluno(nome= "João Guilherme De Souza", turma="1 ano 06", idade=15),
    2: Aluno(nome= "Julia Marina Carvalho", turma="2 ano 02", idade=16),
    3: Aluno(nome= "Pedro Luis Oliveira", turma="3 ano 04", idade=18),
}

class TestAlunosAPI(unittest.TestCase):

    def setUp(self):
        """
        Este método é executado antes de CADA teste.
        Isso garante que cada teste comece com um banco de dados limpo.
        """
        self.client = TestClient(app)
        
    def test_read_root(self):
        """Testa o endpoint raiz (GET /)"""
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), {"message": "Bem-vindo à API de Alunos! Acesse /docs para a documentação interativa."})

    def test_listar_alunos(self):
        """Testa a listagem de todos os alunos (GET /alunos/)"""
        response = self.client.get("/alunos/")
        self.assertEqual(response.status_code, 200)
        # Devemos ter 3 alunos do estado inicial
        self.assertEqual(len(response.json()), 3)
        self.assertEqual(response.json()[0]["nome"], "João Guilherme De Souza")

    def test_buscar_aluno_sucesso(self):
        """Testa a busca de um aluno existente (GET /alunos/{matricula})"""
        response = self.client.get("/alunos/2")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()["nome"], "Julia Marina Carvalho")

    def test_buscar_aluno_nao_encontrado(self):
        """Testa a busca de um aluno que não existe"""
        response = self.client.get("/alunos/999")
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.json(), {"detail": "Aluno não encontrado."})

    def test_criar_aluno_sucesso(self):
        """Testa a criação de um novo aluno (POST /alunos/{matricula})"""
        nova_matricula = 4
        novo_aluno_data = {"nome": "Lianara", "turma": "2 ano 04", "idade": 16}
        
        response = self.client.post(f"/alunos/{nova_matricula}", json=novo_aluno_data)
        
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()["message"], "Aluno cadastrado com sucesso!")
        
        # Verifica se o aluno foi realmente adicionado ao banco
        self.assertIn(nova_matricula, alunos_db)
        self.assertEqual(alunos_db[nova_matricula].nome, "Lianara")

    def test_criar_aluno_matricula_existente(self):
        """Testa a criação de um aluno com matrícula que já existe (erro 409)"""
        matricula_existente = 1
        novo_aluno_data = {"nome": "Théo", "turma": "2 ano 04", "idade": 16}

        response = self.client.post(f"/alunos/{matricula_existente}", json=novo_aluno_data)
        
        self.assertEqual(response.status_code, 409)
        self.assertEqual(response.json(), {"detail": "Matrícula já cadastrada."})

    def test_atualizar_aluno_sucesso(self):
        """Testa a atualização de um aluno existente (PUT /alunos/{matricula})"""
        matricula_para_atualizar = 3
        dados_atualizados = {"nome": "Pedro ATUALIZADO", "turma": "3 ano 05", "idade": 19}

        response = self.client.put(f"/alunos/{matricula_para_atualizar}", json=dados_atualizados)
        
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()["mensagem"], "Cadastro atualizado com sucesso!")
        
        # Verifica se o banco foi realmente atualizado
        self.assertEqual(alunos_db[matricula_para_atualizar].nome, "Pedro ATUALIZADO")
        self.assertEqual(alunos_db[matricula_para_atualizar].idade, 19)

    def test_atualizar_aluno_nao_encontrado(self):
        """Testa a atualização de um aluno que não existe (erro 404)"""
        dados_atualizados = {"nome": "Fantasma", "turma": "0 ano 00", "idade": 99}
        response = self.client.put("/alunos/999", json=dados_atualizados)
        
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.json(), {"detail": "Aluno não encontrado."})

    def test_deletar_aluno_sucesso(self):
        """Testa a deleção de um aluno existente (DELETE /alunos/{matricula})"""
        matricula_para_deletar = 1
        
        # Verifica se o aluno existe ANTES de deletar
        self.assertIn(matricula_para_deletar, alunos_db)
        
        response = self.client.delete(f"/alunos/{matricula_para_deletar}")
        
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json(), {"mensagem": "Aluno deletado com sucesso!"})

        # Verifica se o aluno foi realmente removido do banco
        self.assertNotIn(matricula_para_deletar, alunos_db)

    def test_deletar_aluno_nao_encontrado(self):
        """Testa a deleção de um aluno que não existe (erro 404)"""
        response = self.client.delete("/alunos/999")
        
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.json(), {"detail": "Aluno não encontrado."})

if __name__ == '__main__':
    unittest.main()
