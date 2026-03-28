# Start Small

Don't pretend to run when you can't even walk.
Always plan in microsteps and go up one step at a time.

Before running the full thing, check if it works on something small first.
If it doesn't work small, scaling up won't help.

## Checklist

1. **Run on tiny data first.** 10, 100 samples — can it memorize them? If not, it's a structural problem.
2. **Break it apart and verify each piece.** Don't look at the whole thing at once. Data preprocessing, model, loss, training loop — split by module, verify inputs and outputs of each. When the whole thing fails you can't tell where; when you split it, you can see.
3. **Change one thing at a time.** If you change multiple things at once, you won't know what caused the success or failure.
4. **Scale up step by step.** Small passes → medium → full. Each step must pass before moving to the next.
