import unittest 
from Lia_exercicios import *

class TestesExemplos(unittest.TestCase):
    def testar_se_numero_eh_par (self):
        numero_a_ser_testado = 12
        self.assertTrue(numero_a_ser_testado % 2 == 0 )

    def testar_se_numero_eh_impar (self):
        numero_a_ser_testado = 17
        self.assertTrue(numero_a_ser_testado % 2 == 1 )

    def testar_conta (self):
        resultado = 15 + 5 + 25 + 7
        self.assertEqual(resultado, 52)

# criar 3 testes diferentes

    def Testar_conta (self):
        Resultado = 20 + 5
        self.assertEqual(Resultado, 25)
       
    def Testar_se_numero_eh_menor_dez (self):
        Numero = 15
        self.assertTrue (Numero <10)
    
    def testar_classificar_idade(self):
        self.assertEqual(classificar_idade(10), 'Criança')
        self.assertEqual(classificar_idade(15), 'Adolescente')
        self.assertEqual(classificar_idade(34), 'Adulto')
        self.assertEqual(classificar_idade(150), 'Idade Inválida')

    def teste_comparar_numeros(self):
        self.assertEqual(comparar_numeros(20,12), 20)
        self.assertEqual(comparar_numeros(13,56), 56)
        self.assertEqual(comparar_numeros(30,30), 'os números são iguais')
    
    def teste_verificar_vogal_ou_consoante(self):
        self.assertEqual(verificar_vogal_ou_consoante('a'), 'é uma vogal')
        self.assertEqual(verificar_vogal_ou_consoante('p'), 'é uma consoante')

    def teste_calcular_media(self):
        self.assertEqual(calcular_media(10,5,8), 'aprovado')
        self.assertEqual(calcular_media(3,4,2), 'reprovado')

    def teste_verificar_senhas(self):
        self.assertEqual(verificar_senhas('ABCD', 'ABCD'), 'Acesso permitido')
        self.assertEqual(verificar_senhas('ABCD', 'RRRR'), 'Senha não coincidiram')

    def teste_reverse_numeros(self):
        self.assertEqual(reverse_numeros(1,2,3), [3,2,1])
        self.assertEqual(reverse_numeros(10,20,30), [30,20,10])

    def teste_calcular_litros(self):
        Distancia = 12 * 24
        litros_usados = Distancia / 12
        self.assertEqual(calcular_litros(12,24), litros_usados)


if __name__ == "__main__":
    unittest.main()
