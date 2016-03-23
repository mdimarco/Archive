#include <stdlib.h>
#include <stdio.h>

#include "linkedlist.h"

/* A ListNode is a node in a singly-linked list */
typedef struct ListNode ListNode;
struct ListNode {
	void *value;
	ListNode *next;
};

struct LinkedList {
    int (*equals)(void *, void *);  // Function to compare two elements for equality
    void *(*copy)(void *);  // Function that copies an element and returns a pointer to the copy.
    void (*delete)(void *);  // Function to delete an element

	ListNode *head;  // The first element (remember to update)
    int size;  // The number of elements in the list (remember to update)
};

/******************************
 * Creation/deletion functions
 ******************************/

/* Create a new linkedlist with the given element functions and return it */
LinkedList *linkedlist_new(int (*equals) (void *, void *),
                    void *(*copy)(void *), 
                    void (*delete)(void *)) {
	// TODO: 1. Allocate space for a linkedlist struct.
	//       2. Initialize the struct.
	LinkedList *newlist = (LinkedList *) malloc( sizeof( LinkedList ) );
	newlist->equals = equals;
	newlist->copy = copy;
	newlist->delete = delete;

	newlist->head = NULL;
	newlist->size = 0;


	return newlist;
}



/* Delete the given linked list */
void linkedlist_delete(LinkedList *linkedlist) {
	// TODO: 1. Delete all of the linked list's internal data.
	//       2. Free the struct.

	
	ListNode *current = linkedlist->head;
	int som = linkedlist->size;
	for(int i =0; i<som; i++){
		ListNode *next = current->next;
		linkedlist->delete(current->value);
		free(current);
		current = next;
	}
	linkedlist->head = NULL;

	free(linkedlist);
}


/******************************
 * Access/modification functions
 ******************************/

/* Add a copy of the given element to the tail of the list */
void linkedlist_append(LinkedList *linkedlist, void *element) {
	// TODO: 1. Find the last node in the linked list.
	//       2. Create a copy of the element and store the copy in
    //          a new list node.
	//       3. Set the next pointer of the last node to the newly
    //          created node.


	if( linkedlist->head == NULL){
		ListNode *new_head = (ListNode *)malloc(sizeof(ListNode));
		linkedlist->head = new_head;

		linkedlist->head->value = linkedlist->copy(element);
		linkedlist->head->next = NULL;
		linkedlist->size++;
		return;
	}

	ListNode *current = linkedlist->head;
	while( current->next != NULL ){
		current = current->next;
	}
	ListNode *new = (ListNode *)malloc(sizeof(ListNode));
	new->value = linkedlist->copy(element);
	new->next = NULL;

	current->next = new;
	linkedlist->size++;
}


/* Insert a copy of the given element at the given index (before the element 
 * that currently has that index).
 * Inserting at size is equivalent to appending.
 * Return 1 if the element was added successfully
 * 0 otherwise (if the index is invalid)
 */
int linkedlist_insert(LinkedList *linkedlist, void *element, int index) {
	// TODO: 1. Find the node at the given index, if such a node exists.
	//       2. Create a copy of the element and store the copy in
    //          a new list node.
	//       3. Update the next pointers of the old and new nodes.
	if(index > linkedlist->size){
		return 0;
	}

	if(index == linkedlist->size){
		linkedlist_append(linkedlist, element);
		return 1;
	}

	if( index == 0  ){
		ListNode *new = (ListNode *) malloc(sizeof(ListNode));
		new->next = linkedlist->head;
		new->value = element;
		linkedlist->head = new;
		linkedlist->size++;
		return 1;
	}	

	ListNode *current = linkedlist->head;
	
	int counter = 1;
	while(  (counter < index) ){
		current = current->next;
		counter++;
	}

	ListNode *new = (ListNode *) malloc(sizeof(ListNode));
	new->next = current->next;
	new->value = linkedlist->copy(element);
	current->next = new;

	linkedlist->size++;
	return 1;
}

/* Return 1 if the given element is in the list
 * 0 otherwise
 */
int linkedlist_contains(LinkedList *linkedlist, void *element) {
	ListNode *current = linkedlist->head;
	while (current != NULL) {
		if (linkedlist->equals(current->value, element)) {
			return 1;
		}
		current = current->next;
	}
	return 0;
}

/* Remove the first occurence of the given element from the list
 * Return 1 if the element was removed successfully
 * 0 otherwise (if the element was not found)
 */
int linkedlist_remove(LinkedList *linkedlist, void *element) {
	// TODO: 1. Find the first node containing the element.
	//       2. If an element is found, delete the linkedlist's copy
	//          of the element and remove the node.
    //       3. Update the next pointer of the previous element.
	if( !linkedlist_contains(linkedlist, element) ){
		return 0;
	}

	if( linkedlist->equals( linkedlist->head->value, element) ){
		linkedlist->delete( linkedlist->head->value );
		ListNode *temp = linkedlist->head->next;
		free(linkedlist->head);
		linkedlist->head = temp;
		linkedlist->size--;
		return 1;
	}


	ListNode *current = linkedlist->head;
	while( !linkedlist->equals(current->next->value, element) ){
		current = current->next;
	}

	ListNode *temp = current->next;
	linkedlist->delete( temp->value );

	current->next = current->next->next;
	free(temp);
	linkedlist->size--;
	return 1;
}


/******************************
 * Other utility functions
 ******************************/

/* Get the size of the given set */
int linkedlist_size(LinkedList *linkedlist) {
	return linkedlist->size;
}

/* Print a representation of the linkedlist,
 * using the given function to print each
 * element
 */
void linkedlist_print(LinkedList *linkedlist, FILE *stream, void (*print_element)(FILE *, void *)) {
	fprintf(stream, "{size=%d} ", linkedlist->size);
    ListNode *bn = linkedlist->head;
    fprintf(stream, "[");
    while(bn) {
        print_element(stream, bn->value);
        bn = bn->next;
        if(bn)
            fprintf(stream, ", ");
    }
    fprintf(stream, "]");
}
