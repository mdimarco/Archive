#include <stdlib.h>
#include <pthread.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include "race.h"

#define NFIB 39
#define BUF_SIZE 1024
#define nthreads 4

int someone_finished = 0;

int main() {
    race_t *race = race_init();
    create_racers(race);
    start_race(race);
    return 0;
}

race_t *race_init(){
    race_t *race = (race_t *) malloc(sizeof(race_t));
    /**
     * 1. initialize barrier and race mutex
     */


    pthread_barrier_t barr;
    pthread_barrier_init(&barr, NULL, nthreads);

    pthread_mutex_t mut;
    pthread_mutex_init(&mut, NULL);

    race->barrier = barr;
    race->mutex = mut;

    return race;
}

int create_racers(race_t *race){
    race->team_1 = create_team("North West");
    race->team_2 = create_team("Blue Ivy");
    return 0;
}

race_team_t *create_team(char *team_name){
    race_team_t *team = (race_team_t *) malloc(sizeof(race_team_t));
    team->racer_a = create_racer(team_name);
    team->racer_b = create_racer(team_name);
    return team;
}

racer_t *create_racer(char *team_name){
    racer_t *racer = (racer_t *) malloc(sizeof(racer_t));
    racer->finished = 0;
    racer->team_name = team_name;

    /**
     * 1. initialize the racer's associated mutex and condition variable
     */
    pthread_mutex_t mut;
    pthread_mutex_init(&mut, NULL);
    racer->mutex = mut;

    pthread_cond_t con;
    pthread_cond_init(&con, NULL);
    racer->done = con;

    return racer;
}

void destroy_race(race_t *race) {

    /**
      *  destroy the race barrier, race mutex, and all racer condition variables/mutexes
      */

    pthread_cond_destroy( &(race->team_1->racer_a->done) ); 
    pthread_cond_destroy( &(race->team_1->racer_b->done) );
    pthread_cond_destroy( &(race->team_2->racer_a->done) );
    pthread_cond_destroy( &(race->team_2->racer_b->done) );

    
    pthread_mutex_destroy( &(race->team_1->racer_a->mutex) );
    pthread_mutex_destroy( &(race->team_1->racer_b->mutex) );
    pthread_mutex_destroy( &(race->team_2->racer_a->mutex) );
    pthread_mutex_destroy( &(race->team_2->racer_b->mutex) );

    pthread_mutex_destroy( &(race->mutex) );
    pthread_barrier_destroy( &(race->barrier) );

    free(race->team_1->racer_a);
    free(race->team_1->racer_b);
    free(race->team_2->racer_a);
    free(race->team_2->racer_b);

    free(race->team_1);
    free(race->team_2);

    free(race);
}

void *run_racer_a(void *args){
    /**
     * TODO:
     * 1. wait at barrier
     * 2. call calculate()
     * 3. set finished to 1
     * 4. signal condition variable
     */
    args_t *race_args = (args_t *)args;
    race_t *this_race = race_args->race;
    race_team_t *this_team = race_args->team;

    pthread_barrier_wait( &(this_race->barrier) );
    calculate();
    
    pthread_mutex_lock( &(this_team->racer_a->mutex) );
    this_team->racer_a->finished = 1;
    pthread_cond_signal( &(this_team->racer_a->done) );
    pthread_mutex_unlock( &(this_team->racer_a->mutex) );


    return 0;
}

void *run_racer_b(void *args){
    /**
     * TODO:
     * 1. wait at barrier
     * 2. wait on condition variable
     * 3. call handoff()
     * 4. call calculate()
     * 5. lock race mutex, call announce, unlock race mutex
     */
    args_t *race_args = (args_t *)args;
    race_t *this_race = race_args->race;
    race_team_t *this_team = race_args->team;
 
    pthread_barrier_wait( &(this_race->barrier) );

    pthread_mutex_lock( &(this_team->racer_b->mutex) );
    while( this_team->racer_a->finished == 0 )
    {
	    pthread_cond_wait( 
			    &(this_team->racer_a->done),
			    &(this_team->racer_a->mutex)
			    );
    }
    pthread_mutex_unlock( &(this_team->racer_b->mutex) );

    handoff(this_team->racer_b->team_name);
    calculate();
    pthread_mutex_lock( &(this_race->mutex) );
    announce(this_team->racer_b->team_name);
    pthread_mutex_unlock( &(this_race->mutex) );

   return 0;
}

void start_race(race_t *race){
    /**
     * TODO:
     * 1. initialize the argument wrapper
     * 2. create racer threads
     * 3. start race!
     * 4. join threads
     */
    pthread_t threads[4];
    args_t args[4];
    for(int i = 0; i<4; i++)
    {
	args[i].race = race;
	if(i < 2)
	{
 	    args[i].team = race->team_1;
	}
	else
	{
	    args[i].team = race->team_2;
	}
    }
    pthread_create(&threads[0],0,run_racer_a, &args[0]);
    pthread_create(&threads[1],0,run_racer_b, &args[1]);
    pthread_create(&threads[2],0,run_racer_a, &args[2]); 
    pthread_create(&threads[3],0,run_racer_b, &args[3]);
  
    for(int i = 0; i<4; i++)
    {
        pthread_join(threads[i], 0);
    }	

    //all racers are done
    printf("All racers have finished\n");
    destroy_race(race);
}

void calculate(){
    fibonacci(NFIB);
}

int fibonacci(unsigned int a){
    if(a < 2) {
        return 1;
    } else {
        return fibonacci(a - 1) + fibonacci(a - 2);
    }
}

void announce(char *team){
    if (!someone_finished) {
        printf("Team %s has locked the Golden Mutex and won the race!\n", team);
    } else {
        printf("Team %s has come in second place, securing the Silver Mutex!\n", team);
    }

    someone_finished = 1;
}


/* printf is thread-safe, so racing threads shouldn't use it.
   this function is used so a team can announce when it
   has handed off without impeding progress of the other team. */
void *handoff_print(void *msg) {
    printf((char *)msg);
    free(msg);
    return 0;
}

void handoff(char* team) {
    pthread_t print_thread;
    char *buf = malloc(BUF_SIZE);
    sprintf(buf, "Racer A of team %s has finished!\n", team);
	pthread_create(&print_thread, 0, handoff_print, buf);
}
