  .section .text
  .globl   _start

_start:
  li       x1, 25     # Load 25 into register x1
  li       x2, 44     # Load 44 into register x2
  add      x3, x1, x2 # Add x1 and x2, store result in x3
  sw       x3, 0(x0)  # Store x3 at address 0 (data memory)
  j        _start     # Infinite loop (halt)
