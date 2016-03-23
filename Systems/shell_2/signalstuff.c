#include "SignalStuff.h"



//Makes several escape signals ignored 
//So that this shell won't be affected 
void terminal_sig_setup(void){
   signal(SIGQUIT, SIG_IGN);
   signal(SIGTSTP, SIG_IGN);
   signal(SIGTTIN, SIG_IGN);
   signal(SIGTTOU, SIG_IGN);
   signal(SIGINT,  SIG_IGN);

  }

//Sets up default signals for child
//to be called FROM within the child
//So that a control-c here affects it
//Also sets up child as group leader
//and gives it terminal control
void child_sig_from_child( void ){
   signal(SIGQUIT, SIG_DFL);
   signal(SIGTSTP, SIG_DFL);
   signal(SIGTTIN, SIG_DFL);
   signal(SIGTTOU, SIG_DFL);
   signal(SIGINT, SIG_DFL);

  }


