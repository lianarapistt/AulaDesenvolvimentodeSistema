#python -m uvicorn main:app --reload
#pip install "uvicorn[standard]"  
#pip install fastapi      
#pip install uvicorn

import uuid
from typing import List, Dict, Optional
from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel, Field


class TarefaBase(BaseModel):
    """Modelo base para dados de entrada (Criação e Atualização)"""
    titulo: str = Field(..., min_length=3, description="Título curto e obrigatório da tarefa.")
    descricao: Optional[str] = Field(None, description="Detalhamento opcional da tarefa.")

class TarefaCreate(TarefaBase):
    """Modelo de dados esperado ao criar uma nova tarefa."""
    pass

class TarefaUpdate(TarefaBase):
    """Modelo de dados esperado ao atualizar uma tarefa existente."""
    concluida: bool = Field(False, description="Status de conclusão da tarefa.")

class Tarefa(TarefaUpdate):
    """Modelo de dados completo da Tarefa (usado na resposta da API)"""
    id: str = Field(..., description="Identificador único gerado automaticamente.")


#Dicionario em Memoria 
db_tarefas: Dict[str, dict] = {}


app = FastAPI(
    title="Trabalho final de Desenvolvimento de Sistema // Théo Ferreira - Lianara Vitória  e Matheus Gorges Machado",
    description="API RESTful para gerenciar tarefas em memória com FastAPI."
)


def _get_tarefa_dict(tarefa_id: str) -> Optional[dict]:
    return db_tarefas.get(tarefa_id)

def _generate_id() -> str:
    return str(uuid.uuid4())





@app.post(
    "/tarefas",
    response_model=Tarefa,
    status_code=status.HTTP_201_CREATED,
    summary="Cria uma nova tarefa"
)
async def criar_tarefa(tarefa_data: TarefaCreate):
    
    novo_id = _generate_id()
    
    nova_tarefa = Tarefa(
        id=novo_id,
        titulo=tarefa_data.titulo,
        descricao=tarefa_data.descricao,
        concluida=False 
    )
    
    db_tarefas[novo_id] = nova_tarefa.model_dump() 
    return nova_tarefa

@app.get(
    "/tarefas",
    response_model=List[Tarefa],
    summary="Lista todas as tarefas"
)
async def listar_tarefas():
    return list(db_tarefas.values())

@app.get(
    "/tarefas/{tarefa_id}",
    response_model=Tarefa,
    summary="Obtém uma tarefa específica por ID"
)
async def obter_tarefa(tarefa_id: str):
    """Retorna a tarefa correspondente ao ID fornecido."""
    
    tarefa = _get_tarefa_dict(tarefa_id)
    
    if not tarefa:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Tarefa com ID '{tarefa_id}' não encontrada."
        )
    
    return tarefa

@app.put(
    "/tarefas/{tarefa_id}",
    response_model=Tarefa,
    summary="Atualiza uma tarefa existente"
)
async def atualizar_tarefa(tarefa_id: str, tarefa_data: TarefaUpdate):
    
    tarefa_existente = _get_tarefa_dict(tarefa_id)
    
    if not tarefa_existente:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Tarefa com ID '{tarefa_id}' não encontrada."
        )
    
    if not tarefa_data.titulo or len(tarefa_data.titulo) < 3:
         pass
    
    tarefa_existente.update(tarefa_data.model_dump())
    
    tarefa_existente['id'] = tarefa_id 
    
    db_tarefas[tarefa_id] = tarefa_existente
    
    return tarefa_existente

@app.delete(
    "/tarefas/{tarefa_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Deleta uma tarefa"
)
async def deletar_tarefa(tarefa_id: str):
    """Remove uma tarefa pelo ID."""
    
    if tarefa_id not in db_tarefas:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Tarefa com ID '{tarefa_id}' não encontrada."
        )
    
    del db_tarefas[tarefa_id]
    
    return None


iimport pytest
from fastapi.testclient import TestClient
from main import app, db_tarefas # Importa a app e o DB em memória

client = TestClient(app)

@pytest.fixture(autouse=True)
def clean_db():
    """Limpa o dicionário em memória antes de cada teste."""
    db_tarefas.clear()
    yield # Executa o teste


def test_criar_tarefa_sucesso():
    """Testa a criação bem-sucedida de uma tarefa (Com título e descrição)."""
    response = client.post(
        "/tarefas",
        json={"titulo": "Fazer compras", "descricao": "Comprar pão e leite"}
    )
    assert response.status_code == 201
    data = response.json()
    assert data["titulo"] == "Fazer compras"
    assert data["descricao"] == "Comprar pão e leite"
    assert data["concluida"] is False
    assert "id" in data
    assert data["id"] in db_tarefas

def test_criar_tarefa_titulo_minimo():
    """Testa a criação bem-sucedida de uma tarefa com o mínimo de caracteres no título."""
    response = client.post(
        "/tarefas",
        json={"titulo": "ABC"}
    )
    assert response.status_code == 201
    data = response.json()
    assert data["titulo"] == "ABC"
    assert data.get("descricao") is None
    assert data["concluida"] is False

def test_criar_tarefa_falha_sem_titulo():
    """Testa a falha na criação por falta do campo 'titulo' (Deve retornar 422)."""
    response = client.post(
        "/tarefas",
        json={"descricao": "Detalhe da tarefa sem título"}
    )
    assert response.status_code == 422
    assert "field required" in response.json()["detail"][0]["msg"]

def test_criar_tarefa_falha_titulo_curto():
    """Testa a falha na criação se o 'titulo' tiver menos de 3 caracteres (Deve retornar 422)."""
    response = client.post(
        "/tarefas",
        json={"titulo": "AB"}
    )
    assert response.status_code == 422
    assert "ensure this value has at least 3 characters" in response.json()["detail"][0]["msg"]


def test_listar_tarefas_vazia():
    """Testa a listagem quando não há nenhuma tarefa (deve retornar uma lista vazia)."""
    response = client.get("/tarefas")
    assert response.status_code == 200
    assert response.json() == []

def test_listar_tarefas_existentes():
    """Testa a listagem quando existem uma ou mais tarefas."""
    tarefa1 = {"id": "1", "titulo": "Tarefa Um", "descricao": None, "concluida": False}
    tarefa2 = {"id": "2", "titulo": "Tarefa Dois", "descricao": "Detalhe", "concluida": True}
    db_tarefas["1"] = tarefa1
    db_tarefas["2"] = tarefa2
    
    response = client.get("/tarefas")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 2
    assert any(t["id"] == "1" for t in data)
    assert any(t["id"] == "2" for t in data)
    

def test_buscar_tarefa_por_id_valido():
    """Testa a busca por um ID válido e existente."""
    tarefa = {"id": "abc-123", "titulo": "Tarefa Teste", "descricao": None, "concluida": False}
    db_tarefas["abc-123"] = tarefa
    
    response = client.get("/tarefas/abc-123")
    assert response.status_code == 200
    assert response.json()["id"] == "abc-123"
    assert response.json()["titulo"] == "Tarefa Teste"

def test_buscar_tarefa_por_id_nao_existente():
    """Testa a busca por um ID que não existe (deve retornar 404)."""
    response = client.get("/tarefas/non-existent-id")
    assert response.status_code == 404
    assert "não encontrada" in response.json()["detail"]
    

def test_atualizar_tarefa_sucesso():
    """Testa a atualização bem-sucedida de uma tarefa."""
    tarefa_original = {"id": "upd-1", "titulo": "Antigo Título", "descricao": "Antiga Descrição", "concluida": False}
    db_tarefas["upd-1"] = tarefa_original
    
    novos_dados = {
        "titulo": "Novo Título Atualizado", 
        "descricao": "Nova Descrição Detalhada", 
        "concluida": True
    }
    
    response = client.put("/tarefas/upd-1", json=novos_dados)
    assert response.status_code == 200
    data = response.json()
    
    assert data["titulo"] == "Novo Título Atualizado"
    assert data["descricao"] == "Nova Descrição Detalhada"
    assert data["concluida"] is True
    
    tarefa_atualizada_db = db_tarefas["upd-1"]
    assert tarefa_atualizada_db["titulo"] == "Novo Título Atualizado"
    assert tarefa_atualizada_db["concluida"] is True

def test_atualizar_tarefa_id_nao_existente():
    """Testa a tentativa de atualizar uma tarefa com um ID inexistente (deve retornar 404)."""
    novos_dados = {"titulo": "Título", "descricao": "Descrição", "concluida": True}
    response = client.put("/tarefas/non-existent-id-put", json=novos_dados)
    assert response.status_code == 404
    assert "não encontrada" in response.json()["detail"]

def test_atualizar_tarefa_falha_titulo_invalido():
    """Testa a falha na atualização com um título inválido (curto) (Deve retornar 422)."""
    
    tarefa_original = {"id": "upd-2", "titulo": "Original", "descricao": None, "concluida": False}
    db_tarefas["upd-2"] = tarefa_original
    
    
    dados_invalidos = {"titulo": "A", "descricao": "Nova", "concluida": False}
    
    response = client.put("/tarefas/upd-2", json=dados_invalidos)
    assert response.status_code == 422
    assert "ensure this value has at least 3 characters" in response.json()["detail"][0]["msg"]
    
    assert db_tarefas["upd-2"]["titulo"] == "Original"


def test_deletar_tarefa_sucesso_e_verificacao():
    """Testa a deleção bem-sucedida e verifica se a tarefa sumiu."""
    tarefa_id_to_delete = "del-1"
    db_tarefas[tarefa_id_to_delete] = {"id": tarefa_id_to_delete, "titulo": "Para Deletar", "descricao": None, "concluida": False}
    
    response_delete = client.delete(f"/tarefas/{tarefa_id_to_delete}")
    assert response_delete.status_code == 204
    assert response_delete.content == b"" 
    
    response_get = client.get(f"/tarefas/{tarefa_id_to_delete}")
    assert response_get.status_code == 404
    assert tarefa_id_to_delete not in db_tarefas

def test_deletar_tarefa_id_nao_existente():
    """Testa a tentativa de deletar uma tarefa com ID inexistente (deve retornar 404)."""
    response = client.delete("/tarefas/non-existent-id-delete")
    assert response.status_code == 404
    assert "não encontrada" in response.json()["detail"]
