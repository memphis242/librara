# RArA - Runtime Arena Allocator
Library that implements a memory allocator for a user-provided pool. The allocator may be configured at compile-time (via configuration macros) and/or run-time (via init fcn parameters).   

## Differentiating Features
- You choose your preferred allocation scheme
   - classic bump/stack allocation for speed
   - fixed-object size pool allocation for arbitrarily ordered free/alloc on fixed-size objects
   - segregated free-lists to support arbitrarily ordered free/alloc operations on arbitrarily-sized objects
   - and more...
- Supports "compacting" functionality for applicable allocation schemes where references and allocated blocks are moved around to close external fragmentation gaps
   - To support this, the user application registers callbacks to update its references when shifting occurs
- Minimalistic interface (small API)
- Intended for embedded systems, so memory-efficiency is prioritized whenever possible to keep this library lightweight
- Compile-time configuration allows the end-user to pick which parts of the library they want to include, facilitating smaller library file size
- "Vizable" - if enabled via the `VIZABLE` compile-time config macro, the pool may be visualized through a socket interface (see example Python script in [`scripts/`](./scripts/)
