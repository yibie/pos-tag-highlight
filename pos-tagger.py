import sys
import subprocess

def install_package(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

def ensure_spacy():
    try:
        import spacy
    except ImportError:
        print("spaCy not found. Installing...", file=sys.stderr)
        install_package("spacy")
        install_package("https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-3.5.0/en_core_web_sm-3.5.0.tar.gz")
        import spacy
    
    try:
        nlp = spacy.load("en_core_web_sm")
    except OSError:
        print("Downloading spaCy English model...", file=sys.stderr)
        spacy.cli.download("en_core_web_sm")
        nlp = spacy.load("en_core_web_sm")
    
    return nlp

def tag_text(text, nlp):
    doc = nlp(text)
    return ' '.join(f"{token.text}_{token.pos_}" for token in doc)

if __name__ == "__main__":
    nlp = ensure_spacy()
    try:
        text = sys.stdin.read()
        result = tag_text(text, nlp)
        print(result)
    except Exception as e:
        print(f"Error in tag_text: {str(e)}", file=sys.stderr)
        sys.exit(1)
