#include <iostream>
#include "system.h"
#include <openthread/thread.h>
using namespace std;


//void system_part2_post_init() __attribute__((weak));
// this is overridden for modular firmware
//void system_part2_post_init(){}

int main(void){
    cout << "hello world" ;
    system_part2_post_init();
    return 0;
}
