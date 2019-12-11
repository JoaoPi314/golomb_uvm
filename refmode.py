x = int(input('Digite um numero: '))

binary = bin(x + 1)
size = len(binary) - 3
x = ''

for i in range(size):
	x += '0'

x += binary[2:]

lista = [];

for c in x:
	lista.append(c) 

print(lista)
