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
def eh_palindromo(text):
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


# Função: Média dos Elementos 
print("--- 1. Primos no Intervalo (10 a 20) ---")
print(f"Resultado: {primos_intervalo(10, 20)}") # retornar [11, 13, 17, 19]

print("\n--- 2. Ordenar e Remover Duplicatas ---")
lista_com_duplicatas = [5, 2, 8, 2, 5, 1, 8]
print(f"Lista Original: {lista_com_duplicatas}")
print(f"Resultado: {ordenar_sem_repeticao(lista_com_duplicatas)}") #retornar [1, 2, 5, 8]

print("\n--- 3. Soma dos Dígitos ---")
print(f"Soma dos dígitos de 456: {soma_digitos(456)}") # retornar 4 + 5 + 6 = 15

print("\n--- 4. Palíndromo ---")
frase_palindromo = "A base do teto desaba"
print(f"'{frase_palindromo}' é palíndromo? {eh_palindromo(frase_palindromo)}") #retornar True

print("\n--- 5. Frequência de Palavras ---")
texto_exemplo = "Eu amo programar, e você ama programar também"
print(f"Frequência: {frequencia_palavras(texto_exemplo)}")
#retornar {'eu': 1, 'amo': 2, 'programar,': 2, 'e': 1, 'você': 1, 'também': 1}

print("\n--- 6. Média dos Elementos ---")
lista_numeros = [10, 20, 30, 40]
print(f"Média de {lista_numeros}: {media_lista(lista_numeros)}") # retornar 100 / 4 = 25.0
print(f"Média de lista vazia: {media_lista([])}") # retornar None
