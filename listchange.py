def listchange(total, denos = [25, 10, 5, 1]):
	if total == 0 or denos == []:
		return []
	elif total < denos[0]:
		return listchange(total, denos[1:])
	elif total == denos[0]:
		return [[denos[0]]] + listchange(total, denos[1:])
	else:
		return consall(denos[0], listchange(total - denos[0], denos)) + listchange(total, denos[1:])

def consall(num, lsts):
	for i in range(len(lsts)):
		lsts[i] = [num] + lsts[i]
	return lsts

		#listchange(10)

# [	[consall(denos[0], [listchange(total - denos[0], denos)])]
# 		, listchange(total, denos[1:])]
