build:
    cp whitepapers/Semi-structured\ Document\ Feature\ Extraction/misc/main.pdf docs/resources/feature-extraction.pdf
    cp whitepapers/Table\ Layout\ Regular\ Expression\ -\ Layex/misc/main.pdf docs/resources/layex.pdf
    mkdocs build
    
run:
    mkdocs serve