#include <stdio.h>
#include <sys/select.h>
#include <unistd.h>

int main() {
  fd_set s;
  struct timeval timeout;

  timeout.tv_sec = 3;
  timeout.tv_usec = 10;
  /*
      do {
          printf("Hello\n");
          fflush(stdout);
          FD_ZERO(&s);
          FD_SET(STDIN_FILENO, &s);
          select(STDIN_FILENO+1, &s, NULL, NULL, &timeout);
      } while (FD_ISSET(STDIN_FILENO, &s) == 0);
  */

  int i = 100000;

  do {
    printf("Press [ENTER] for GSM debug mode... %i  \r", i / 10000);
    fflush(stdout);
    FD_ZERO(&s);
    FD_SET(STDIN_FILENO, &s);
    select(STDIN_FILENO + 1, &s, NULL, NULL, &timeout);
    i--;
  } while (FD_ISSET(STDIN_FILENO, &s) == 0 && i > 0);

  if (i <= 0) {
    printf("\nSkipping debug mode...\n");
  } else {
    printf("\nEntering debug mode...\n");

    // fill in the debug code here
  }
}
