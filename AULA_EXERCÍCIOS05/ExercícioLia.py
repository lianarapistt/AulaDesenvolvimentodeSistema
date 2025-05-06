# 1. Solicite 5 números e mostre a soma
n1 = int(input("Digite o primeiro número: "))
n2 = int(input("Digite o segundo número: "))
n3 = int(input("Digite o terceiro número: "))
n4 = int(input("Digite o quarto número: "))
n5 = int(input("Digite o quinto número: "))
soma = n1 + n2 + n3 + n4 + n5
print("A soma dos 5 números é de:", soma)


# 2. Solicite 4 números e mostre o maior e o menor
n1 = int(input("Digite o primeiro número: "))
n2 = int(input("segundo número: "))
n3 = int(input("terceiro número: "))
n4 = int(input("quarto número: "))
maior = n1
if n2 > maior:
    maior = n2
if n3 > maior:
     maior = n3
if n4 > maior:
     maior = n4
menor = n1
if n2 < menor:
    menor = n2
if n3 < menor:
    menor = n3
if n4 < menor:
    menor = n4
print("O maior número é:", maior)
print("o menor número é:", menor)


# 3. Solicite uma palavra e mostre quantas vogais ela tem
palavra = input("Digite uma palavra: ")
vogais = "aeiou"
contador = 0
letra = palavra


while letra:
    if letra[0] in vogais:
        contador += 1
    letra = letra[1:]


print('A palavra contém esse número de vogais: ', contador)




# 4. Solicite 6 números e mostre apenas os números pares
#usei o resto da divisão para ver se era par ou impar
numero1 = int(input("Digite o 1 número: "))
numero2 = int(input("Digite o 2 número: "))
numero3 = int(input("Digite o 3 número: "))
numero4 = int(input("Digite o 4 número: "))
numero5 = int(input("Digite o 5 número: "))
numero6 = int(input("Digite o 6 número: "))


if numero1 % 2 == 0:
    print( numero1, "é par")
if numero2 % 2 == 0:
    print( numero2, "é par")
if numero3 % 2 == 0:
    print( numero3, "é par")
if numero4 % 2 == 0:
    print( numero4, "é par")
if numero5 % 2 == 0:
    print( numero5, "é par")
if numero6 % 2 == 0:
    print( numero6, "é par")




# 5. Solicite as notas de 4 provas e mostre a média
nota1 = float(input("Digite a nota da 1 prova: "))
nota2 = float(input("Digite a nota da 2 prova: "))
nota3 = float(input("Digite a nota da 3 prova: "))
nota4 = float(input("Digite a nota da 4 prova: "))
media = nota1 + nota2 + nota3 + nota4 / 4
print("a média das notas é:", media)


# 6. Solicite um número e mostre a tabuada desse número de 1 a 10
#tabuada
numero = int(input("digite um número: "))
print(numero * 1)
print(numero * 2)
print(numero * 3)
print(numero * 4)
print(numero * 5)
print(numero * 6)
print(numero * 7)
print(numero * 8)
print(numero * 9)
print(numero * 10)


# 7. Solicite um número N e mostre todos os números de 1 até N


numeroN = int(input("Digite um número: "))
contador = 1
while contador <= numeroN:
    print(contador)
    contador += 1


# 8. Solicite uma palavra e mostre ela ao contrário
#[::-1] usei fatiamento para inverter
palavra = input('digite a palavra')
palavra_ao_contrario = palavra [::-1]
print(palavra_ao_contrario)




# 9. Solicite um número e diga se ele é múltiplo de 3
#usei % para ver se a sobra da  0 e assim sabemos se é ou não
numero = int(input("Digite um número aqui: "))
if numero % 3 == 0:
    print("o número é múltiplo de 3")
else:
    print("o número não é múltiplo de 3")


# 10. Solicite 3 nomes e mostre todos eles em ordem alfabética
#ordenar com o sort para ficar em ordem alfabética
nome1 = input("Digite o primeiro nome: ")
nome2 = input("Digite o segundo nome: ")
nome3 = input("Digite o terceiro nome: ")
nomes_todos = nome1, nome2, nome3
nomes_todos.sort()
print("Os nomes em ordem alfabética é:", nomes_todos)
