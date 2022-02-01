import csv
import random

def get_csv_data():
    with open ("/home/steve/Documents/Computing/Flutter_projects/kovol_quiz/assets/data/words.csv") as file:
        reader = csv.reader(file)
        data = []
        for row in reader:
            data.append((row[0], row[1]))
        return tuple(data)


def get_options(data):
    random_words = random.choices(data, k=4)
    quiz_word = random.choice(random_words)
    return quiz_word[0], random_words


def prompt(quiz_word, options):
    print(f"""
    \nWhat is the meaning of {quiz_word}?

    1. {options[0][1]}
    2. {options[1][1]}
    3. {options[2][1]}
    4. {options[3][1]}
    """)

def evaluate_answer(answer, quiz_word, options):
    if options[int(answer) - 1][0] == quiz_word:
        print("\nCorrect")
    else:
        print("\nWrong")

    
data = get_csv_data()
while True:
    quiz_word, options = get_options(data)
    prompt(quiz_word, options)
    evaluate_answer(input(), quiz_word, options)