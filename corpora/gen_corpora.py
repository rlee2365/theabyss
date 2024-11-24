import nltk
from nltk.probability import FreqDist
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from collections import defaultdict, Counter

nltk.download('punkt')
nltk.download('averaged_perceptron_tagger')
nltk.download('stopwords')

def grab_words(corpus, output_file, top_n=500):
    print(f"Building word pool for {corpus}, top {top_n}, output: {output_file}")
    with open(corpus) as f:
        text = f.read()

    tokens = word_tokenize(text)
    stop_words = set(stopwords.words('english'))
    filtered_tokens = [word for word in tokens if word.isalnum() and word not in stop_words]

    # POS tagging
    pos_tags = nltk.pos_tag(filtered_tokens)

    # Frequency distribution
    fdist = FreqDist(filtered_tokens)

    # Group by POS
    pos_dict = {}
    for word, pos in pos_tags:
        if pos not in pos_dict:
            pos_dict[pos] = []
        pos_dict[pos].append(word)

    # Create a filter for POS
    filter_pos = ['NN', 'JJ', 'VB', 'RB']
    filtered_pos_dict = {pos: words for pos, words in pos_dict.items() if pos in filter_pos}

    common_words_by_pos = {pos: [x[0] for x in Counter(words).most_common(top_n)] for pos, words in filtered_pos_dict.items()}

    # Write to file
    import json
    with open(output_file, 'w') as f:
        json.dump(common_words_by_pos, f)

grab_words('shakespeare.txt', 'shakespeare_dict_500.json', 500)
grab_words('shakespeare.txt', 'shakespeare_dict_2000.json', 2000)
grab_words('eliot.txt', 'eliot_dict_2000.json', 2000)
grab_words('keats.txt', 'keats_dict_2000.json', 2000)
grab_words('wordsworth.txt', 'wordsworth_dict_2000.json', 2000)