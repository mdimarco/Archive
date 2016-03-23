/*
 * Write your maze generator here. 
 */
 #include <stdio.h>
 #include <stdlib.h>
 #include <assert.h>
 #include <time.h>

#define ROWS 10
#define COLUMNS 25

#define NORTH 0
#define EAST 1
#define SOUTH 2
#define WEST 3

typedef struct 
{
	int row;
	int col;

	char up;
	char down;
	char left;
	char right;

	int leftConnection;
	int  rightConnection;
	int  upConnection;
	int  downConnection;

	int visited;

}Room;

void initialize_room(void);
void create_matrix(FILE*);
char calc_border_value(Room);


void shuffle_array(int[], int);
void drunken_walk(int, int);

void calc_new_coors(int, int *, int *);
void calc_opposite_coords(int, int* , int* );

void create_connection(Room*, Room*);
void make_wall(Room*, int, int);
void make_opening(Room*, int, int);
void make_wall_or_opening_helper(Room*, int, int, int);

int  get_direction(int, int, int, int);
int  has_connection(Room*, int, int);

int out_of_bounds(int, int);

//------------------------------------------
//TESTING FUNCTIONS
void test_shuffle(void);
void test_get_direction(void);
void test_functions(void);
void test_create_connection(void);

//------------------------------------------


Room rooms[ROWS][COLUMNS];


int main(int argc, char **argv) {
	srand(time(NULL));

	if(argc<2){
		printf("Error: not enough args");
	}

	

	initialize_room();
	drunken_walk(0,0);



	FILE *file1 = fopen(argv[1], "w");
	create_matrix( file1 );

	int error = fclose(file1);
	assert(error == 0);

	return 0;

}




void create_matrix(FILE *file1){
	char roomVal;
	for(int i = 0; i<ROWS; i++){
		for(int j =0; j<COLUMNS; j++){
			roomVal = calc_border_value( rooms[i][j] );
			fprintf( file1, "%x", roomVal);
		}
		fprintf(file1, "\n" );
	}
}

char calc_border_value(Room r){
	return r.right*8 + r.left*4 + r.down*2 + r.up;
}


/*

I have defined my directions to move as such

		0
		^
		|
 3 <--- C  ---> 1
		|
	   \./
		2

	and defined NORTH = 0 EAST = 1
	WEST = 2 SOUTH = 3 at the top
	of this file.

	params x,y are the ROW and COLUMN to go at
*/
void drunken_walk(int x, int y){

	Room *r = &rooms[x][y];
	r->visited = 1;

	const int len = 4;
	int dirs[4] = {NORTH, EAST, SOUTH, WEST};

	//Randomize ze elements
	shuffle_array(dirs, len);

	
	for(int i = 0; i<4; i++){
		int dir = dirs[i];


		//Use new dir for new coordinates
		int newX = x;
		int newY = y;
		calc_new_coors(dir, &newX, &newY);

		//Check new bounds
		if( out_of_bounds(newX, newY) ){
				make_wall(r, newX, newY);
		}
		else{
			Room *neighbor = &rooms[newX][newY];

			//Recurse if not visited
			if( !neighbor->visited ){
				make_opening(r, newX, newY);
				drunken_walk(neighbor->row, neighbor->col );
			}
			else{
				int oppX = x;
				int oppY = y;
				//Looking "back" from new room coordinates
				calc_opposite_coords(dir, &oppX, &oppY);

				//Check if neighbor has a connection at the location we started at
				if( has_connection(neighbor, oppX, oppY )){
						create_connection(r, neighbor);
				}
				else{
					make_wall(neighbor, oppX, oppY);
				}
			}

		}

	} 

}



//Check if a given x,y coordinate is out of the grid bounds
int out_of_bounds(int i, int j){
	return (i < 0 || i >= ROWS || j < 0 || j >= COLUMNS);
}

//Uses GLOBAL variable rooms defined above main function
//Initializes rooms to initial values, 
//and connections to false
void initialize_room(){
	int i,j;
	for( i = 0; i < ROWS; i++){
		for( j = 0; j<COLUMNS; j++){
			rooms[i][j].row = i;
			rooms[i][j].col = j;
			rooms[i][j].up = 0;
			rooms[i][j].down = 0;
			rooms[i][j].left = 0;
			rooms[i][j].right = 0;
			rooms[i][j].leftConnection = 0;
			rooms[i][j].rightConnection = 0;
			rooms[i][j].upConnection = 0;
			rooms[i][j].downConnection = 0;
			rooms[i][j].visited = 0;
		}
	}
}




/*

	The following CHANGE what value 
	the variables
	passed into them point to.

*/

//Converter from 0,1,2,3 to new x and y coordinates
void calc_new_coors(int dir, int *i,int *j){

		if( dir == NORTH){ *i = *i -1;}
		if( dir == EAST){ *j = *j +1;}
		if( dir == SOUTH){ *i = *i +1;}
		if( dir == WEST){ *j = *j -1;}

}
//Does  the opposite of ^
void calc_opposite_coords(int dir, int *i, int *j){
		if( dir == NORTH){ *i = *i +1;}
		if( dir == EAST){ *j = *j -1;}
		if( dir == SOUTH){ *i = *i -1;}
		if( dir == WEST){ *j = *j +1;}
}


/*

	Shuffles an n length array using standard pseudorandom
	number generator. Uses in place swapping due to int property
	of A and no current risk of overflow.

	int A[]: Array to be randomized
	int n: length of array

*/
void shuffle_array(int A[],int n){
	int i;
	float randNum;
	int randInd;
	for(i=0; i<n; i++){
		randNum = ( rand() % ( n  - i ) ) + i;
		randInd = (int)randNum;
		//Swap w/o temp variable
		int temp = A[i];
		A[i] = A[randInd]; 
		A[randInd] = temp;
	}
}


//Calls helper function to place a wall at reference point from r
void make_wall(Room *r, int i, int j){
	make_wall_or_opening_helper(r, i, j, 1);
}

//Calls helper function to place a wall at reference point from r
void make_opening(Room *r, int i, int j){
	make_wall_or_opening_helper(r, i, j, 0);
}


/*
	Does the actual wall/opening
	creation. if the coordinates
	specified are out of bounds, this makes
	a fake "room" to pretend to connect to
	so that a wall can be added.

	This is necessary because of how the 
	create_connection function is defined.



*/
void make_wall_or_opening_helper(Room *r, int i, int j, int n){
	if(out_of_bounds(i, j)){
		//Makes an out of bounds "room" to make connection to
		Room fakeRoom;
		fakeRoom.row = i;
		fakeRoom.col = j;
		fakeRoom.upConnection = 0;
		fakeRoom.downConnection = 0;
		fakeRoom.leftConnection = 0;
		fakeRoom.rightConnection = 0;
		create_connection( r, &fakeRoom);
		}

	else{
		create_connection( r, &rooms[i][j]);
		}

	int direction = get_direction(r->col, j, r->row, i);
	if( direction == NORTH){ r->up = n; }
	if( direction == SOUTH){ r->down = n; }
	if( direction == WEST){ r->left = n; }
	if( direction == EAST){ r-> right = n; }
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


//Connects two rooms together (using pointers to stop ref problem)
void create_connection(Room *r1, Room *r2){
	int direction = get_direction(r1->col, r2->col, r1->row, r2->row);

	if( direction == SOUTH){
		r1->downConnection = 1;
	}
	if( direction == NORTH){
		r1->upConnection = 1;
	}
	if( direction == EAST){
		r1->rightConnection = 1;
	}
	if( direction == WEST){
		r1->leftConnection = 1;
	}
}


//Returns whether or not the room has a connection at the given index
int  has_connection(Room *r, int i, int j){

	int direction = get_direction(r->col, j, r->row, i);

	if( direction == SOUTH){ return r->downConnection; }

	if( direction == NORTH){ return r->upConnection; }

	if( direction == EAST){ return r->rightConnection; }

	else { return r->leftConnection; }


}

//-------------------------------------------------------------------------------------------
//TESTING FUNCTIONS BECAUSE MISTAKES
void test_functions(){

	//TEST SHUFFLE VERIFIED
	//testShuffle(); //If seed not changes, should yield 3 2 0 1

	test_get_direction(); // VERIFIED
	test_create_connection(); // VERIFIED

}

void test_shuffle(){
	int arr[4] = {0,1,2,3};
	shuffle_array( arr, 4);
	printf("%d %d %d %d \n", arr[0], arr[1], arr[2], arr[3] );

}

void test_get_direction(){
	int east =  get_direction(1,2, 1, 1);
	int west =  get_direction(2,1, 1, 1);
	int south = get_direction(1,1, 1, 2);
	int north = get_direction(1,1, 2, 1);
	assert( east == EAST);
	assert( west == WEST);
	assert( south == SOUTH);
	assert( north == NORTH);
}

void test_create_connection(){
	Room r;
	r.row = 3;
	r.col = 3;
	r.leftConnection = 0;

	Room r2;
	r2.row = 3;
	r2.col = 2;
	r2.rightConnection = 0;

	create_connection(&r, &r2);
	assert( r.leftConnection == 1);

	r.row = 2;
	r.col = 2;
	r.downConnection = 0;
	r2.upConnection = 0;

	create_connection(&r, &r2);
	assert( r.downConnection == 1);
}

