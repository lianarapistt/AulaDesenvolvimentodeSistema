# PYTHON exercícios 

 # 1- idade
def classificar_idade(idade):
    if idade < 12 and idade >=1:
        return 'Criança'
    elif idade >= 12 and idade <= 17:
        return 'Adolescente'
    elif idade>= 18 and idade<=100:
        return 'Adulto'
    else:
        return 'Idade Inválida'


#2- numero
def comparar_numeros(n1, n2):
    if n1 > n2:
        return(n1)
    elif n2 > n1:
        return(n2)
    else:
        return("os números são iguais")

#3-vogal
def verificar_vogal_ou_consoante(letra):
    if letra == "a" and "e" and "i" and "o" and "u":
        return ("é uma vogal")
    else:
        return("é uma consoante")



#4 - Calculo media
def calcular_media (nota1, nota2, nota3):
    soma = nota1 + nota2 + nota3
    media = soma / 3
    if media >= 7:
        return"aprovado"
    else:
        return"reprovado"

#5- senhas
def verificar_senhas(senha1, senha2 ):
    if senha1 == senha2:
        return'Acesso permitido'
    else:
        return 'Senha não coincidiram'


#6- numeros reverse
def reverse_numeros(N1, N2, N3):
    numeros = [N1, N2, N3]
    numeros.sort(reverse=True)
    return(numeros)

# 7- calcular a quantidade de litros usados
def calcular_litros(Tempo, Velocidade):
    Distancia = Tempo * Velocidade
    litros_usados = Distancia / 12
    return(litros_usados)
