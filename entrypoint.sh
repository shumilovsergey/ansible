#!/bin/bash

# Render file tree to file and also print it to terminal
tree -I '__pycache__|*.pyc|.git|*.retry' -a -N | tee /ansible/PROJECT_STRUCTURE.txt 2>/dev/null || echo "(tree not available)"

# Continue with the original CMD
exec "$@"
