# Importa as 6 funções do arquivo 'ExerciciosUltimaAula'
from ExerciciosUltimaAula import (
    primos_intervalo,
    ordenar_sem_repeticao,
    soma_digitos,
    verificar_palindromo,
    frequencia_palavras,
    media_lista
)


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
# Usando 'eh_palindromo' como estava no seu print
print(f"'{frase_palindromo}' é palíndromo? {verificar_palindromo(frase_palindromo)}") #retornar True

print("\n--- 5. Frequência de Palavras ---")
texto_exemplo = "Eu amo programar, e você ama programar também"
print(f"Texto: '{texto_exemplo}'")
print(f"Frequência: {frequencia_palavras(texto_exemplo)}")
# Nota: O seu comentário de retorno esperado está um pouco diferente do que
# o código realmente fará (ex: 'programar,' vs 'programar'). O código está
# tratando 'programar,' e 'programar' como palavras diferentes.

print("\n--- 6. Média dos Elementos ---")
lista_numeros = [10, 20, 30, 40]
print(f"Média de {lista_numeros}: {media_lista(lista_numeros)}") # retornar 100 / 4 = 25.0
print(f"Média de lista vazia: {media_lista([])}") # retornar None
