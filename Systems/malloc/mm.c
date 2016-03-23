

#include "mm.h"







/*
 * initializes the dynamic allocator
 * arguments: none
 * returns: 0, if successful
 *         -1, if an error occurs
 */
int mm_init(void) {

	block_t *head = mem_sbrk( ALIGN( sizeof( block_t )));
    if( (void *)head == (void *)-1){
        fprintf(stderr, "mem_sbrk failed to extend the heap in malloc\n");
        return -1;
    }
	head->size = MIN_SIZE;
	head->next = NULL;
	head->prev = NULL;
    head->end_size = MIN_SIZE;

	return 0;
}


/*
 * allocates a block of memory and returns a pointer to that block
 * arguments: size: the desired block size
 * returns: a pointer to the newly-allocated block (whose size
 *          is a multiple of ALIGNMENT), or NULL if an error
 *          occurred
 */
void *mm_malloc(size_t size) {
	if( size == 0){
		return NULL;
	}
    

	//Make find size of block to look for
	size_t newsize = ALIGN(size + SIZE_T_SIZE*2);
	newsize = MAX(newsize, MIN_SIZE);


    block_t *new_block;
	//Look for a block of the appropriate size in the free list

	void *new_b = find_block( newsize );

	if( new_b != (void *)-1 ){
        //Sees and does if the block has enough free space
        //to break a piece off and put into the free list
        break_free_block( new_b, newsize );

        new_block = (block_t *)new_b;
        set_block_size( new_block,  ALLOC( GET_SIZE(new_b) ));

    }


	//if not found, must use sbrk
	else{
		new_b = mem_sbrk(newsize);
		if(new_b == (void *)-1){
            fprintf(stderr, "mem_sbrk failed to extend the heap in malloc\n");
			return NULL;
		}
		else{
            new_block = (block_t *)new_b;
            set_block_size(new_block, ALLOC(newsize));
            
		}
  	}
    
	return (void *)((char *)new_block + SIZE_T_SIZE);

}


/*
 * frees a block of memory, enabling it to be reused later
 * arguments: ptr: the allocated block to free
 * returns: nothing
 */
void mm_free(void *ptr) {
                        //ptr
    //   size_t | notin    |       payload
    // [- - - -   - - - - ]|[ -  - - - - - - -- - - ]
    size_t *size_of_block = ptr - SIZE_T_SIZE;
    
    block_t *new_block = (block_t *)size_of_block;
    set_block_size(new_block, DEALLOC( new_block->size) );

    add_to_free_list( new_block);

  
    coalesce(new_block);
    
}




/*
 * reallocates a memory block to update it with the given size
 * arguments: ptr: a pointer to the memory block
 *            size: the desired new block size
 * returns: a pointer to the new memory block
 */
void *mm_realloc(void *ptr, size_t size) {

	ptr = NULL;
	size = (int)ptr;
	ptr = (void *)size;
	return NULL;
}

/*
 * checks the state of the heap for internal consistency
 * arguments: none
 * returns: 0, if successful
 *          nonzero, if the heap is not consistent
 */
int mm_check_heap(void) {
    printf("-------------------\n");
	printf("State of the Heap\n");

	block_t *current = mem_heap_lo();
    
    
    printf("Head block at %p with size %d\n", current, (int)(current->size));

    current= (void *)current + DEALLOC(current->size); //skip the head block
    
    while( ((void *)current ) <= mem_heap_hi()
         && current->size > 0){
        
        if(current->size == 0){
            printf("Looks like we goofed at %p with a size zero\n", current);
            exit(1);
        }
    
        if( (int)current->size %2 == 0 )
        {
            printf("Free ");
        }
        else{
            printf("Aloc ");
        }
        printf("block at %p ", current);
        printf("with size %d\n", current->size );

        //printf("End tag at %p with size %d\n", get_end_tag(current), *get_end_tag(current));
        
        current= (void *)current + DEALLOC(current->size);
    }
    
    printf("------------------\n");
    printf("\n\n");
    return 0;
}







