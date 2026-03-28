#!/bin/bash
python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    model = data.get('model', {}).get('display_name', '?')
    pct = data.get('context_window', {}).get('used_percentage', 0)
    print(f'[{model}] Context: {pct:.0f}%')
except:
    print('Context: N/A')
"
