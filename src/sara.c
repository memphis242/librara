#include <stdbool.h>
#include <stdint.h>
#include <assert.h>

// Macro constants for the capacity of each free list.
// The lists are statically sized so that theoretically, the full static array
// arena can be owned by any single list. This is done because we have to account
// for the run-time dynamics of these lists shifting ownership of the arena in
// all sorts of strange and mysterious ways in practice. We may start off with
// the 1024 list owning the majority of the arena, and over time, each 1024
// blocks may be split off, theoretically until all the blocks are 32-byte sized.
// Of course, we cannot dynamically size the memory used by these lists because,
// these lists are the handlers of dynamic memory, so their overhead must be set
// up front!
#define BLOCKS_1024_LIST_CAPACITY (( VEC_ARRAY_ARENA_SIZE / 1024 ) + 1)
#define BLOCKS_512_LIST_CAPACITY  (( VEC_ARRAY_ARENA_SIZE / 512  ) + 1)
#define BLOCKS_256_LIST_CAPACITY  (( VEC_ARRAY_ARENA_SIZE / 256  ) + 1)
#define BLOCKS_128_LIST_CAPACITY  (( VEC_ARRAY_ARENA_SIZE / 128  ) + 1)
#define BLOCKS_64_LIST_CAPACITY   (( VEC_ARRAY_ARENA_SIZE / 64   ) + 1)
#define BLOCKS_32_LIST_CAPACITY   (( VEC_ARRAY_ARENA_SIZE / 32   ) + 1)

// Macro constants for the iniital length of each free list.
// Ideally, the distribution of the initial lengths will match the distribution
// of requests during runtime. This minimizes the amount of times splitting and
// coalescing has to happen.
// Since that's not really going to be possible up front, one can either go
// through the discretize_arena.py Python script, write their own initial lens,
// or use the default below which starts at the largest size and goes down.
#ifdef USE_EXTERNAL_INIT_LENS
#include "array_arena_cfg.h"
#else
#define BLOCKS_1024_LIST_INIT_LEN (((VEC_ARRAY_ARENA_SIZE)        / 1024) + 1)
#define BLOCKS_512_LIST_INIT_LEN  (((VEC_ARRAY_ARENA_SIZE % 1024) / 512)  + 1)
#define BLOCKS_256_LIST_INIT_LEN  (((VEC_ARRAY_ARENA_SIZE % 512)  / 256)  + 1)
#define BLOCKS_128_LIST_INIT_LEN  (((VEC_ARRAY_ARENA_SIZE % 256)  / 128)  + 1)
#define BLOCKS_64_LIST_INIT_LEN   (((VEC_ARRAY_ARENA_SIZE % 128)  / 64)   + 1)
#define BLOCKS_32_LIST_INIT_LEN   (((VEC_ARRAY_ARENA_SIZE % 64)   / 32)   + 1)
#endif // USE_EXTERNAL_INIT_LENS

enum BlockSize
{
   BLKS_LARGEST_SIZE,
   BLKS_1024 = BLKS_LARGEST_SIZE,
   BLKS_512,
   BLKS_256,
   BLKS_128,
   BLKS_64,
   BLKS_32,
   NUM_OF_BLOCK_SIZES
};

static size_t BlockSize_E_to_Int[NUM_OF_BLOCK_SIZES] = { 1024, 512, 256, 128, 64, 32 };

struct ArrayPoolBlock_S
{
   void * ptr; // Pointer to block
   bool is_free;  // Flag to clear when allocating this block
};
struct ArrayPoolBlockList_S
{
   struct ArrayPoolBlock_S * blocks; // Array of blocks of this list
   uint16_t block_size; // Size of blocks in this list in bytes
   size_t len; // How many blocks are in this list
};
struct ArrayArena_S
{
   struct ArrayPoolBlockList_S lists[NUM_OF_BLOCK_SIZES];
   bool arena_initialized;
   size_t space_available;
};

//! The arena of contiguous bytes from which we allocate from.
STATIC uint8_t ArrayArenaPool[VEC_ARRAY_ARENA_SIZE];

// These shall be the list of allocatable blocks (the "free lists").
struct ArrayPoolBlock_S blocks_1024[BLOCKS_1024_LIST_CAPACITY];
struct ArrayPoolBlock_S blocks_512[BLOCKS_512_LIST_CAPACITY];
struct ArrayPoolBlock_S blocks_256[BLOCKS_256_LIST_CAPACITY];
struct ArrayPoolBlock_S blocks_128[BLOCKS_128_LIST_CAPACITY];
struct ArrayPoolBlock_S blocks_64[BLOCKS_64_LIST_CAPACITY];
struct ArrayPoolBlock_S blocks_32[BLOCKS_32_LIST_CAPACITY];

STATIC struct ArrayArena_S ArrayArena =
{
   .lists =
   {
      [ BLKS_1024 ] = { .blocks = blocks_1024, .len = (BLOCKS_1024_LIST_INIT_LEN - 1), .block_size = 1024 },
      [ BLKS_512  ] = { .blocks = blocks_512,  .len = (BLOCKS_512_LIST_INIT_LEN  - 1), .block_size = 512  },
      [ BLKS_256  ] = { .blocks = blocks_256,  .len = (BLOCKS_256_LIST_INIT_LEN  - 1), .block_size = 256  },
      [ BLKS_128  ] = { .blocks = blocks_128,  .len = (BLOCKS_128_LIST_INIT_LEN  - 1), .block_size = 128  },
      [ BLKS_64   ] = { .blocks = blocks_64,   .len = (BLOCKS_64_LIST_INIT_LEN   - 1), .block_size = 64   },
      [ BLKS_32   ] = { .blocks = blocks_32,   .len = (BLOCKS_32_LIST_INIT_LEN   - 1), .block_size = 32   }
   },
   .arena_initialized = false,
   .space_available = VEC_ARRAY_ARENA_SIZE - (VEC_ARRAY_ARENA_SIZE % 32)
};

/**
 * @brief Local helper function to find the block that corresponds to the pointer passed in.
 * 
 * @note The enum BlockSize * and size_t * parameters are optional and may be
 *       set to NULL if all the user cares about is if there exists a block that
 *       lives at the address passed in.
 * @param[in]  ptr     Address to look for among the allocatable blocks
 * @param[out] blk_sz  (Ptr) Enum for which block list the ptr belongs to (optional)
 * @param[out] blk_idx (Ptr) Idx within the block list that the ptr belongs to (optional)
 * @return true if successful in finding a block; false otherwise
 */
static bool Helper_FindBlock( const void *,
     /* Return Parameters */  enum BlockSize *, size_t * );

/**
 * @brief Initializes the static array pool arena structures.
 */
STATIC void StaticArrayPoolInit(void)
{
   // Initialize the pointers within the arena free lists, calculating an offset
   // into the ArrayArenaPool for each.
   // TODO: This can be done at compile-time. If the macro magic isn't too crazy, let's try that.
   assert( ArrayArena.lists != NULL );
   assert( !ArrayArena.arena_initialized );

   size_t accumulating_offset = 0;
   for ( uint8_t i = 0; i < (uint8_t)NUM_OF_BLOCK_SIZES; i++ )
   {
      struct ArrayPoolBlockList_S * list = &ArrayArena.lists[i];
      assert( list != NULL );
      for ( size_t j = 0; j < list->len; j++ )
      {
         assert( accumulating_offset < VEC_ARRAY_ARENA_SIZE );
         list->blocks[j].ptr = &ArrayArenaPool[ accumulating_offset ];
         list->blocks[j].is_free = true;
         accumulating_offset += list->block_size;
         assert( accumulating_offset <= VEC_ARRAY_ARENA_SIZE );
      }
   }

   ArrayArena.arena_initialized = true;
}

/**
 * Check that the static array pool is initialized.
 */
STATIC bool StaticArrayPoolIsInitialized(void)
{
   return ArrayArena.arena_initialized;
}

/**
 * @brief Allocates a contiguous block that can accomodate req_bytes from
 *        a static arena. Block size guaranteed to be ≥req_bytes.
 * @note Presently uses the "Buddy System" as described in:
 *          memorymanagement.org/mmref/alloc.html
 * @return Pointer to the allocated block if successful, NULL otherwise.
 */
STATIC void * StaticArrayAlloc(size_t req_bytes)
{
   assert( ArrayArena.arena_initialized );

   if ( req_bytes > ArrayArena.space_available )
   {
      // TODO: Return result type that specifies requested bytes was greater than space available
      return NULL;
   }

   #ifndef NDEBUG
   // Confirm assumption that the lists are sorted in order of descending block size
   uint16_t prev_sz = ArrayArena.lists[0].block_size;
   for ( uint8_t sz = 1; sz < (uint8_t)NUM_OF_BLOCK_SIZES; sz++ )
   {
      assert( ArrayArena.lists[sz].block_size > prev_sz );
      prev_sz = ArrayArena.lists[sz].block_size;
   }
   #endif

   void * block_ptr = NULL;
   size_t space_allocated = 0;

   // TODO: Accomodate block requests larger than 1024
   assert( req_bytes <= 1024 );
   // TODO: Reduce internal fragmentation /w block requests that are in between powers of 2
   // Start checking from the largest block sizes down
   for ( uint8_t sz = 0; sz < (uint8_t)NUM_OF_BLOCK_SIZES; sz++ )
   {
      // Skip until we find the nearest block size that accomodates the request
      if ( req_bytes < (ArrayArena.lists[sz].block_size / 2) ) continue;

      struct ArrayPoolBlockList_S * list = &ArrayArena.lists[sz];
      bool found_block = false;
      // Allocate from the beginning of the block list. This helps maintain
      // (but does not guarantee) a convenient descending order of block sizes,
      // which will make for more efficient allocating, freeing, splitting, and
      // coalescing.
      for ( size_t i = 0; i < list->len; i++ )
      {
         if ( list->blocks[i].is_free )
         {
            found_block = true;
            space_allocated = list->block_size;
            block_ptr = list->blocks[i].ptr;
            list->blocks[i].is_free = false;
         }
      }

      if ( (!found_block) && (sz != (uint8_t)BLKS_LARGEST_SIZE) )
      {
         // Look in the free lists of the larger block sizes
         // TODO: Loop through the block sizes up to the largest block size, not just the next size up.

         // Initially, the lists are of adjacent blocks, and the lists are organized
         // in descending order. So, the end of one list's large blocks is the start of
         // the next list's smaller blocks. If we split the block at the end, this
         // convenient descending order is maintained. This is also why I allocate
         // from the beginning of a list.
         struct ArrayPoolBlockList_S * larger_size_list = &ArrayArena.lists[sz + 1];
         for ( int i = (int)(larger_size_list->len - 1); i >= 0; i-- )
         {
            if ( !larger_size_list->blocks[i].is_free )  continue;

            // Split the larger block and assign its info to the smaller size free list
            larger_size_list->len--;
            list->blocks[list->len].ptr = larger_size_list->blocks[i].ptr;
            list->blocks[list->len + 1].ptr = (uint8_t *)larger_size_list->blocks[i].ptr + larger_size_list->block_size;
            list->blocks[list->len].is_free = false;
            list->blocks[list->len + 1].is_free = true;
            list->len += 2;
            block_ptr = list->blocks[list->len - 2].ptr;
            // Assign 
            found_block = true;
            space_allocated = list->block_size;
         }
      }

      break;
   }

   ArrayArena.space_available -= space_allocated;
   return block_ptr;
}

STATIC void * StaticArrayRealloc(void * ptr, size_t req_bytes)
{
   enum BlockSize old_blk_sz;
   size_t old_blk_idx;
   bool old_blk_found = Helper_FindBlock( ptr, &old_blk_sz, &old_blk_idx );

   if ( !old_blk_found )
   {
      // TODO: Raise exception that user tried to realloc an unallocated block
      return NULL;
   }
   else if ( ArrayArena.lists[old_blk_sz].blocks[old_blk_idx].is_free )
   {
      // TODO: Raise exception that user tried to realloc a block that was free
      return NULL;
   }
   else if ( req_bytes >  (ArrayArena.lists[old_blk_sz].block_size / 2) &&
             req_bytes <= ArrayArena.lists[old_blk_sz].block_size )
   {
      // Not much point in reallocating if the size is the best fit.
      // TODO: Accomodate realloc size requests in between powers of 2 using combo of block sizes
      return ptr;
   }
   else if ( 0 == req_bytes )
   {
      StaticArrayFree( ptr );
      return NULL;
   }

   void * tmp = StaticArrayAlloc( req_bytes );
   if ( tmp != NULL )
   {
      size_t old_blk_size = BlockSize_E_to_Int[old_blk_sz];
      size_t num_of_bytes = (req_bytes > old_blk_size) ? old_blk_size : req_bytes;
      memcpy( tmp, ptr, num_of_bytes );
      StaticArrayFree( ptr );
      return tmp;
   }

   // Must not have been able to allocate new block...
   // TODO: Need a better way to express that we failed to realloc. Probably add void ** new_ptr param and return bool/exception/result type.
   return ptr;
}

/**
 * @brief Free the block at the address passed in, if applicable.
 * @note If the address passed in is not one that a block lives at, the fcn simply returns.
 * @param[in] Address of block to free
 */
STATIC void StaticArrayFree(const void * ptr)
{
   enum BlockSize blk_sz;
   size_t blk_idx;
   bool blk_found = Helper_FindBlock( ptr, &blk_sz, &blk_idx );

   if ( !blk_found ) return;  // TODO: Raise exception that user tried to free an unallocated block?

   ArrayArena.lists[blk_sz].blocks[blk_idx].is_free = true;
   ArrayArena.space_available += BlockSize_E_to_Int[blk_sz];
}

/**
 * @brief Determine whether an address is associated with a block that is allocated.
 */
STATIC bool StaticArrayIsAlloc(const void * ptr)
{
   enum BlockSize blk_sz;
   size_t blk_idx;
   bool blk_found = Helper_FindBlock( ptr, &blk_sz, &blk_idx );

   if ( !blk_found ) return false;

   return !ArrayArena.lists[blk_sz].blocks[blk_idx].is_free;
}

/* Static Array Allocator Helper Implementations */

static bool Helper_FindBlock( const void * ptr,
                              enum BlockSize * blk_sz, size_t * blk_idx )
{
   assert( ArrayArena.arena_initialized );

   if ( NULL == ptr )   return false;

#ifndef NDEBUG
   bool blk_found = false;
#endif
   for ( uint8_t sz = 0; sz < (uint8_t)NUM_OF_BLOCK_SIZES; sz++ )
   {
      const struct ArrayPoolBlockList_S * list = &ArrayArena.lists[sz];
      for ( size_t i = 0; i < list->len; i++ )
      {
         // 🗒: Should I allow for an address _inside_ a block?
         //     (ptr >= list->blocks[i].ptr) && (ptr < list->blocks[i+1].ptr)
         if ( list->blocks[i].ptr == ptr )
         {
            if ( blk_sz != NULL ) *blk_sz = (enum BlockSize)sz;
            if ( blk_idx != NULL ) *blk_idx = i;

#ifndef NDEBUG
            // Assert that this is the only block that has this address. For
            // the debug build, keep searching to make sure this assertion holds.
            // We should only enter this if statement once, so blk_found should
            // still be false.
            assert(!blk_found);
            blk_found = true;
#else
            return true;
#endif

         }
      }
   }

#ifndef NDEBUG
   return blk_found;
#else
   return false;
#endif
}

#ifdef ARRAY_ARENA_VIZ

// TODO: Implement arena viz API

#endif // ARRAY_ARENA_VIZ

