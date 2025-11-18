# 1- Escreva uma função primos_no_intervalo(a,b) que retorna uma lista com todos os números primos entre a e b.
# 2- Implemente uma função ordenar_sem_repetir(lista) que retorna uma lista ordenada sem elemenos repetidos.
# 3- Crie uma função soma_diagnostico(n) que recebe um número intero e retorna a soma de seus digitos 
# 4- faça uma função eh_palindromo(texto) que verifica se uma string é palindromo (ignorar maiusculas,imusculas e espaços)
# 5- Implemente uma função frequencias_palavras(texto) que recebe uma frase e retorna um dicionario com cada palvra e sua frequencia 
# 6- Implemente uma função media_lista (lista) que retorna a média dos elementos de uma lista de números. Se a lista estiver vazia, retorne Nome



#Função: Número Primos em Intervalo
def primos_intervalo(a, b):
    primos = []
    for numero in range(a, b + 1):
        
        if numero > 1:
            for i in range(2, int(numero**0.5) + 1):
                if numero % i == 0:
                    break
            else:
                primos.append(numero)
    return primos

#Função: Ordena e Remove Duplicatas
def ordenar_sem_repeticao(l):
    sem_repeticao = set(l)
    lista_ordenada = sorted(sem_repeticao)
    
    return lista_ordenada

# Função: Soma dos Digitos 
def soma_digitos(numero):
    texto_numero = str(abs(numero))   
    soma_total = 0
    for digito_texto in texto_numero:
        digito_inteiro = int(digito_texto)
        soma_total = soma_total + digito_inteiro    
    return soma_total

# Função: Palíndromo
def verificar_palindromo(text):
    t_sem_espaco = text.replace(" ", "")
    t_limpo = t_sem_espaco.lower()
    t_invertido = t_limpo[::-1]  
    return t_limpo == t_invertido

# Função: Frequência de Palavras
def frequencia_palavras(text):
    frequencia = {}
    palavras = text.lower().split()
    for palavra in palavras:
        contagem_atual = frequencia.get(palavra, 0)
        frequencia[palavra] = contagem_atual + 1
    return frequencia

# Função: Frequência de Palavras
def media_lista(l):
    if not l:
        return None
    soma = sum(l)
    quantidade = len(l)
    return soma / quantidade


