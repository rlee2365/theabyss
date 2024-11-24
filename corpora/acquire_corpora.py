# Gutenberg IDs
from datasets import load_dataset

wordsworth = [
    10219, 12145, 12383, 32459, 56361, 47651, 47143, 52836]
# coleridge = [29091, 29092]
# shelley = [4800]
keats = [8209, 23684]
eliot = [1567]

authors = {
    'wordsworth': wordsworth,
    'keats': keats,
    'eliot': eliot
}

dataset = load_dataset('biglam/gutenberg-poetry-corpus')['train']

for author_name,author_ids in authors.items():
    filtered = dataset.filter(lambda x: x['gutenberg_id'] in author_ids)
    with open(f'{author_name}.txt', 'w') as f:
        def append_line(x):
            f.write(x['line']+'\n')
            return None
        filtered.map(append_line)