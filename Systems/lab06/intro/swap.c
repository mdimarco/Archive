// the following declares 'buf', while assuming that is defined elsewhere.
extern int buf[];

void swap() {
    int temp;

    temp = buf[1];
    buf[1] = buf[0];
    buf[0] = temp;
}
