class bp:
    def __init__(self):
        self.counter = 0b00

    # true iff taken
    def prediction(self):
        return (self.counter & 0b10) != 0

    def take(self):
        self.counter += 1
        if self.counter > 0b11: self.counter = 0b11

    def nottake(self):
        self.counter -= 1
        if self.counter < 0b00: self.counter = 0b00

branchstream = [True, True, True, True, False]*50
# branchstream = [True, False]*50
predictor = bp()

accurate = 0
for taken in branchstream:
    predict_taken = predictor.prediction()
    if predict_taken == taken:
        accurate += 1

    print(f'outcome: {taken}, prediction: {predict_taken}')

    if taken:
        predictor.take()
    else:
        predictor.nottake()

print(f'correctly predicted rate = {accurate/len(branchstream)}')
