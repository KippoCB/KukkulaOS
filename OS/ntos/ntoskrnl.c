void kmain(void) {
    // NOTE: This is a temporary test implementation and not a final production kernel.
    
    // Set a pointer to the x86 VGA text mode memory address (0xB8000).
    // The volatile keyword prevents the compiler from optimizing away these direct memory writes.
    volatile unsigned char *vga = (unsigned char * )0xB8000;
    
    // Define the string to be printed on the screen
    const char *msg = "tää paska ei vittu toimi";
    
    // Loop through the string character by character until the null-terminator '\0' is reached
    for (int i = 0; msg[i] != '\0'; i++) {
        // Write the character's ASCII value to the VGA memory.
        // Each character on screen takes 2 bytes, so the character position is i * 2.
        vga[i * 2] = msg[i];
        
        // Write the attribute/color byte immediately after the character (i * 2 + 1).
        // 0x07 represents standard light gray text on a black background.
        vga[i * 2 + 1 ] = 0x07;
    }
    
    // Enter an infinite loop to prevent the CPU from executing random memory 
    // and crashing the system after printing the message.
    for (;;) { }
}
