
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>


#define ROWS 10
#define COLUMNS 25

#define NORTH 0
#define EAST 1
#define SOUTH 2
#define WEST 3




//Node Structure
typedef struct Node_t
{
	int row;
	int col;

	struct Node_t *next;
	struct Node_t *prev; 
}Node;



//Linked List Structure
typedef struct 
{
	Node *head;
	Node *tail;

}LinkedList;


//Room Structure
typedef struct 
{
	int row;
	int col;

	char up;
	char down;
	char left;
	char right;

	int
	 visited;

}Room;

int is_goal(int, int);
int dfs(Room [ROWS][COLUMNS], LinkedList*, int, int);


int should_traverse( Room* , int, int);
int get_direction(int, int, int, int);
int get_bit(Room*, int);

void add_to_path( LinkedList* ,int, int);
void remove_from_path( LinkedList *);

void print_path(FILE *, LinkedList *);

int x_goal;
int y_goal;

/* 
 * Write your solver program here.  
 */

int main(int argc, char **argv) {
	if(argc != 7){
		fprintf(stderr, "Incorrect No. of Args!\n");
		fprintf(stderr, "./solver  <maze file> <output file> <start_x> <start_y> <end_x> <end_y>\n");
		return 1;
	}

	char *input_file = argv[1];
	char *output_file = argv[2];


	int x_start = atoi(argv[3]);
	int y_start = atoi(argv[4]);

	//Goal variables are declared GLOBALLY to be used by is_goal function
	x_goal = atoi(argv[5]);
	y_goal = atoi(argv[6]);



	Room maze[ROWS][COLUMNS];


	//file1 to be the SCAN of the input file
	FILE *file1;
	file1 = fopen( input_file, "r");
	if( file1 == NULL ){
		fprintf(stderr, "There was an error opening the input file.\n");
		return 1;
	}

	if( x_start < 0 || x_start > COLUMNS-1 || y_start < 0 || y_start > ROWS-1){
		fprintf(stderr, "Invalid start coordinates, please keep them between the ROWS, COLUMNS defined values(default 10,25)\n");
		return 1;
	}
	if( x_goal < 0 || x_goal > COLUMNS-1 || y_goal < 0 || y_goal  > ROWS-1){
		fprintf(stderr, "Invalid start coordinates, please keep them between the ROWS, COLUMNS defined values(default 10,25)\n");
		return 1;
	}



	for(int i = 0; i<ROWS; i++){
		for(int j =0; j<COLUMNS; j++){

			unsigned int data;
			fscanf( file1, "%1x", &data );
			

			maze[i][j].row = i;
			maze[i][j].col = j;

			//Masking masking masking
			maze[i][j].right = data & 0x8;
			maze[i][j].left =  data & 0x4;
			maze[i][j].down =  data & 0x2;
			maze[i][j].up =    data & 0x1;
			maze[i][j].visited = 0;
		}
	}
	
	
	//Creation of head node
	Node head = { .row=0, .col=0, .next=NULL, .prev=NULL};
	LinkedList path = { .head = &head, .tail=&head};
	LinkedList *path_ptr = &path;



	dfs( maze, path_ptr, x_start, y_start );




	//Output file to WRITE to
	FILE *output;
	output = fopen(output_file, "w");
	if(output == NULL){
		fprintf(stderr, "Error writing to output file\n");
		return 1;
	}

	//Actual file output writing
	print_path(output, path_ptr);



	int error = fclose(file1);
	assert(error == 0);
	error = fclose(output);
	assert(error == 0);


	return 0;
}




/*

	Performs the actual depth first search, taking in the maze and current path used to get there
	which is pushed and popped as needed throughout the program.

*/
int dfs(Room maze[ROWS][COLUMNS], LinkedList *path, int i, int j){


	Room *room = & (maze[i][j]) ;

	if( is_goal( room->row , room->col ) ){
		return 1;
	}

	room->visited = 1;

	//Uses di and dj to move to decide next move
	for(int k = 0; k<4; k++ ){
		int di = 0;
		int dj = 0;
		if(k == 0){ di = 1;}
		if(k == 1){ di = -1;}
		if(k == 2){ dj = 1;}
		if(k == 3){ dj = -1;}

		int new_row = i+di;
		int new_col = j+dj;




		if(     should_traverse( room, new_row, new_col )  
				&& maze[new_row][new_col].visited != 1 ){

			//Pushes onto end of linked list
			add_to_path(path, new_row, new_col);

			if( dfs(maze, path, new_row, new_col) ){
				return 1;
			}
			else{
				#ifdef FULL
				add_to_path(path, new_row-di, new_col-dj);
				#else
				remove_from_path(path);
				#endif
			}
		}
		 
	}

	return 0;
}



/*

	Uses externally defined variables x_goal and y_goal
	to see if the current goal (at row i or col j) has been reached

*/
int is_goal(int i, int j){
	if( i == ( y_goal ) && j == ( x_goal )){
		return 1;
	}
	else{
		return 0;
	}
}



/*

	Pushes a new node with row and col as specified in the parameters
	to the tail end of the linked list. 

*/
void add_to_path( LinkedList *path, int row, int col){

		Node *new_node = malloc(sizeof(Node));
		new_node->row = row;
		new_node->col = col;
		new_node->next = NULL;
		new_node->prev = path->tail;

		path->tail->next = new_node;
		path->tail = new_node;


}

/*
	Pops and frees the current tail from the path
*/
void remove_from_path(LinkedList *path){
		Node *temp = path->tail;

		path->tail->prev->next = NULL;
		path->tail = path->tail->prev;

		free(temp);
}



/*
	Essentially decides if the new row and col specified are
	walls or openings

*/
int should_traverse( Room *room, int new_i, int new_j){

	int direction = get_direction(room->col, new_j, room->row, new_i);
	int bit = get_bit( room, direction );
	if(bit == 0 ){return 1;}
	else{
		return 0;
	}
}

//returns where on room1's compass room2 lies
int get_direction(int x1, int x2, int y1, int y2){
	if(x2-x1 > 0){
		return EAST;
	}
	if(x2-x1 < 0){
		return WEST;
	}
	if(y2-y1 > 0){
		return SOUTH;
	}
	else{
		return NORTH;
	}
}


//Returning a 1 if the direction is a wall, 0 if an opening
int get_bit( Room *room, int direction ){
	if( direction == EAST)  return room -> right;
	if( direction == WEST)  return room -> left;
	if( direction == NORTH) return room -> up;
	else return room -> down;
}


//_____________________________________________________________________________________


//Prints the path of the linked list to the file specified
void print_path( FILE* file, LinkedList *path){
	char* type;
	#ifdef FULL
	type = "FULL";
	#else
	type = "PRUNED";
	#endif


	Node *head = path->head;
	fprintf(file, "%s\n", type);
	while( head != NULL){
		fprintf(file, "%d,%d\n", head->col, head->row);
		head = head->next;
	}
}


