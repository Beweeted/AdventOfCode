import sys
input = sys.argv[1]

class BingoBoard:
	boardId = 0
	board = None
	markedBoard = None

	def print_board_flat(self):
		print(self.board)

	def print_sorted_board(self):
		new_board = self.board[:]
		new_board.sort()
		print(new_board)

	def print_board(self):
		for i in range(5):
			print(self.board[i*5:i*5+5])

	def print_marked_board(self):
		for i in range(5):
			print(self.markedBoard[i*5:i*5+5])

	def print_count_of_marked_squares(self):
		print("Marked squares:", sum(self.markedBoard))

	def get_bingo_score(self):
		score = 0
		bingoFound = False
		for i in range(5):
			#Rows
			mrow = self.markedBoard[i*5:i*5+5]
			#Columns
			mcol = self.markedBoard[0+i:25:5]

			if set(mrow) == {1} or set(mcol) == {1}:
				bingoFound = True

		if bingoFound:
			for i in range(25):
				if self.markedBoard[i] == 0:
					score += self.board[i]
		return score

	def mark_square(self, squareToMark):
		try:
			index = self.board.index(squareToMark)
			self.markedBoard[index] = 1
			return True
		except:
			return False

	def __init__(self, valueList, boardId):
		self.board = valueList[:]
		self.markedBoard = [0] * 25
		self.boardId = boardId

calledNumbers = []
bingoBoards = []
newBoardId = 0
cardValues = []
print("Loading data...")
with open(input, 'r') as file:
	calledNumbers = file.readline().strip().split(',')
	for l in file:
		line = l.strip()
		if line != '':
			cardValues += [int(num) for num in line.split(' ') if num]
			if len(cardValues) == 25:
				bingoBoards += [BingoBoard(cardValues, newBoardId)]
				#print("Added board", newBoardId)
				#bingoBoards[newBoardId].print_board()
				newBoardId += 1
				cardValues = []

finalScore = 0
bestBoard = None

print("Calling numbers...")
for num in calledNumbers:
	n = int(num)
	bingoFound = False
	print("Calling number:", n)
	for b in bingoBoards:
		if b.mark_square(n):
			score = b.get_bingo_score()
			if score > 0:
				bingoFound = True
				print("Bingo found! Board ID: ", b.boardId, "Score:", score)
				score *= n
				b.print_board()
				print("Marked board:")
				b.print_marked_board()
				if score > finalScore:
					bingoFound = True
					finalScore = score
					bestBoard = b.boardId

	if bingoFound:
		break

print("Final score:", finalScore)
print("Best board:", bestBoard)








