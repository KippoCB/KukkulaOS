 

void kmain(void) 
{

    volatile unsigned char *vga = (unsigned char * )0xB8000;

    const char *msg = "vittu jes tää paska boottaa!";



    for  (int i = 0; msg[i] != '\0'; i++)

    {


    vga[i * 2] = msg[i];

    vga[i * 2 + 1 ] = 0x07;

    }
    


    for (;;)

    {

    }

}



