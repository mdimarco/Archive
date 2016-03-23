#ifndef MM_H
#define MM_H

#include "memlib.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>
#include <string.h>


extern int mm_init (void);
extern void *mm_malloc (size_t size);
extern void mm_free (void *ptr);
extern void *mm_realloc(void *ptr, size_t size);
extern int mm_check_heap(void);

typedef struct block {
    size_t size;
    struct block *next;
    struct block *prev;
    size_t end_size;
}block_t;

//All sizes will be even
#define actual_size( s ) ((s) & -2)
//Tell if allocated
#define allocated( s ) ((s) & 1)

#define GET_SIZE(a) (((block_t *)a)->size)
#define GET_NEXT(a) (((block_t *)a)->next)
#define GET_PREV(a) (((block_t *)a)->prev)


#define MAX(a,b) ( (a>b)?a:b )
#define ALLOC(a) ((a) | 1)
#define DEALLOC(a) ((a) & ~1 )
#define IS_ALLOC(a) ((a) & 1)


/* single word (4) or double word (8) alignment */
#define ALIGNMENT 8

#define ALIGN(size) (((size) + (ALIGNMENT-1)) & ~0x7)

#define SIZE_T_SIZE (ALIGN(sizeof(size_t)))
#define MIN_SIZE    (ALIGN(sizeof(block_t)))



/* in-line functions for block manipulation.  Do not feel that you have to use them 
    Also, feel free to change the type signitures as needed

*/


//add a block to the free list
static inline void add_to_free_list( block_t *block){
    block_t *current = mem_heap_lo();
    
    block->prev = current;
    block->next = current->next;
    if( current->next != NULL){
        current->next->prev = block;
    }
    current->next = block;
}

//remove a block from the free list
static inline void remove_from_free_list( block_t * block){
    if(block->next != NULL){
        block->next->prev = block->prev;
    }
    block->prev->next = block->next;
    block->next = NULL;
    block->prev = NULL;
}

//gets the end-size tag of the block
static inline size_t *get_end_tag( block_t *block){
    size_t *end_tag = ((void *)block) + (block->size & ~1) - (SIZE_T_SIZE/2);
    return end_tag;
}

//sets the end-size tag of the
static inline void set_end_tag( block_t *block, size_t size){
    size_t *end_tag = get_end_tag(block);
    *end_tag = size & ~1;
}

//Sets the block's beginning and ending tags
static inline void set_block_size(block_t *block, size_t size){
    block->size = size;
    block->end_size = size;
    set_end_tag(block, size);
}


/*
 
 sees if the block input can be split into two
 in order to reduce internal fragmentation, this
 will automatically add the block back into the 
 free list if a block is made
 */

//  start
//[-------|------------------------]
//          ^free

//  end
//[--|-------][----|---------------]
//   ^allocated        ^free

static inline void break_free_block(void *fb, size_t newblock_size) {
    
    if( GET_PREV(fb) == NULL){
        printf("Ya don goofed, can't remove this head of the freelist\n");
        return;
    }
    
    block_t * open_space = (block_t *)fb;
    size_t open_size = open_space->size;

    size_t size_left = open_size - newblock_size;
    if( size_left > MIN_SIZE){
        
        //Leftovers block
        block_t *leftovers = (void *)open_space + newblock_size;
        set_block_size(leftovers, size_left);
        
        //Add to list
        add_to_free_list( leftovers );
        
        set_block_size(open_space, open_space->size - size_left);
    }
    remove_from_free_list( open_space );
    
}




//Function that print's the state of the freelist
static inline void print_freelist( void )
{
    printf("State of the free list\n");
    block_t *current = mem_heap_lo();
    do{
        if( (int)current->size %2 == 0 )
        {
            printf("Free ");
        }
        else{
            printf("Allocated ");
        }
        printf("block at %p ", current);
        printf("with size %d\n", (int)(current->size) );
        current = current->next;
        
    }while (current != NULL);
    printf("\n\n\n");
}



//Input: a block
//Output: a block's previous neighbor by memory address
static inline block_t *prev_by_memory( void *block)
{
    void *prev_end_size = ((block) - (SIZE_T_SIZE/2));
    
    void *prev_block = block - *((size_t *)prev_end_size);
    return ((block_t *)prev_block);
}


//merge block into pre_block
static inline void merge_with_prev( block_t *block, block_t *prev_block ){
    set_block_size(prev_block, prev_block->size + block->size);
    remove_from_free_list(block);
}

//merge next_block into block
static inline void merge_with_next( block_t *block, block_t *next_block){
    set_block_size(block, block->size + next_block->size);
    remove_from_free_list(next_block);
}



//Searches this block's next and previous neighbors
//in the free list, and merges them using the helper
//functions defined above if necessary
static inline void coalesce(void *block)
{
    
    block_t *prev_block = prev_by_memory(block);
    
    //          is the prev block free?        and not the head of the list?
    while ( !IS_ALLOC( prev_block->size ) && prev_block->prev != NULL  )
    {
        merge_with_prev( (block_t *)block, prev_block );
        
        //rolled back because merged
        block = prev_block;
        prev_block = prev_by_memory( (void *)prev_block);
    }
    
    block_t *next_block = (block_t *)(block + GET_SIZE(block));
    void *top_of_heap = mem_heap_hi();
    
    //            Does block have a next?         and       is the next free?
    while( ( (long)next_block < (long)top_of_heap) &&  !IS_ALLOC( next_block->size ) )
    {
        merge_with_next(block, next_block);
        next_block = (block_t *)(block + GET_SIZE(block));
    }
    
}


//Searches the free list for an appropriate sized block
//Returns this block if it exists
static inline void *find_block( int size )
{
    
    //Search the free list for a block of the correct size
    block_t *current = mem_heap_lo();
    while( current != NULL ){

        if( (int)(current->size) >= size && (current->prev != NULL) ){
            return current;
        }
        current = current->next;
    }
    
    //Get this far? Didn't find the correct sized block
    void *ret = (void *)-1;
    return ret;
}




#endif
