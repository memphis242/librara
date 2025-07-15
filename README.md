# SArA - Static Arena Allocator
Library that implements a memory allocator for memory that is statically allocated up front through a user-configurable macro. The main differntiating feature of this allocator is that it supports a "compacting" allocation scheme where references and allocated blocks are moved around to close gaps that come up as a result of fragmentation from frees.
