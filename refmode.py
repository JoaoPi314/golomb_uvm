x = int(input('Digite um número: '))

binary = bin(x + 1)
size = len(binary) - 3
x = ''

for i in range(size):
	x += '0'

x += binary[2:]
print(x)



