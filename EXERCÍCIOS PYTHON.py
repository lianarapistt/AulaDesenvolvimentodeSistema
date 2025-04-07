# PYTHON exercícios

 # 1- idade
idade = int(input("Digite sua idade: "))

if idade < 12:
    print("Criança")
elif 12 <= idade <= 17:
    print("Adolescente")
else:
    print("Adulto")


#2- numero
n1 = float (input("Digite o primeiro número: "))
n2 = float (input("Digite o segundo número:" ))
if n1 > n2:
    print(n1)
elif n2 > n1:
    print(n2)
else:
    print("os números são iguais")

#3-vogal
letra = (input("Digite uma letra: "))
if letra == "a" and "e" and "i" and "o" and "u":
    print ("é uma vogal")
else:
    print("é uma consoante")



#4 - Calculo media
nota1 = float (input("Digite a sua primeira nota: "))
nota2 = float (input("Digite a sua segunda nota: "))
nota3 = float (input("Digite a sua terceira nota: "))
soma = nota1 + nota2 + nota3
media = soma / 3
if media >= 7:
    print("aprovado")
else:
    print("reprovado")

#5- senhas
senha1 = input('Digite a sua senha: ')
senha2 = input('Repita sua senha: ')
if senha1 == senha2:
    print('Acesso permitido')
else:
    print('Senha não coincidiram')


#6- 
N1 = int(input('Digite um numero: '))
N2 = int(input('Digite um numero: '))
N3 = int(input('Digite um numero: '))
numeros = [N1, N2, N3]
numeros.sort(reverse=True)
print(numeros)

# 7- litros usados

Tempo = int(input("Digite o tempo de sua viagem(em horas): "))
Velocidade = int(input("Digite a velocidade média de sua viagem(em km/h): "))
Distancia = Tempo * Velocidade
litros_usados = Distancia / 12
print("A velocidade media durante a viagem foi de ", Velocidade)
print("O tempo gasto na viagem foi de ", Tempo)
print("A distancia percorida durante a viagem foi de ", Distancia)
print("A quantidade de litros usada em sua viagem foi de(em ml):", litros_usados)



