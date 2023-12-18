file_path = 'input.txt'

total_cards = 0
with open(file_path, 'r') as file1:
    cards = []
    for line in file1:
        line = line.replace('  ', ' ').replace('  ', ' ').strip()
        print(f'{line=}')
        card_id = int(line.split(': ')[0].split(' ')[1])
        winning_numbers = line.split(': ')[1].split(' | ')[0].split(' ')
        your_numbers = line.split(': ')[1].split(' | ')[1].split(' ')
        matches = 0
        for your_num in your_numbers:
            if your_num in winning_numbers:
                matches += 1

        cards.append({
            "matches": matches,
            "copies": 1
        })

    print(f'{cards=}')
    for card_id, card in enumerate(cards):
        for id in range(card_id + 1, card_id + card["matches"] + 1):
            cards[id]["copies"] += card["copies"]
            print(f'{id=}: {cards[id]["copies"]=}')
        print(f'{cards[card_id]=}')

    for card in cards:
        total_cards += card["copies"]


print(f'{total_cards=}')