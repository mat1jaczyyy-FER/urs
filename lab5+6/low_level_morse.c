#include <stm32f407xx.h>

#define BUZZER_ON  GPIO_BSRR_BS11
#define BUZZER_OFF GPIO_BSRR_BR11
#define LENGTH 100  // length of dot in ms

extern void Delay(uint32_t);

unsigned char * morse_code(unsigned char);
void send_char_morse (char);
void send_string_morse (char *);
void dash(void);
void dot(void);
void razmak_iza_slova(void);
void razmak(int t);
   
unsigned char * morse_code(unsigned char c) {

   static unsigned char Mdummy[6]="xxxxxx";
   static unsigned char M[96][6]={
               //  DEC HEX BIN Symbol Description
   {"xxxxxx"}, //  32 20 00100000   Space
   {"xxxxxx"}, //  33 21 00100001 ! Exclamation mark
   {".-..-."}, //  34 22 00100010 " Double quotes (or speech marks)
   {"xxxxxx"}, //  35 23 00100011 # Number
   {"xxxxxx"}, //  36 24 00100100 $ Dollar
   {"xxxxxx"}, //  37 25 00100101 % Procenttecken
   {"xxxxxx"}, //  38 26 00100110 & Ampersand
   {".----."}, //  39 27 00100111 ' Single quote
   {"-.--.x"}, //  40 28 00101000 ( Open parenthesis (or open bracket)
   {"-.--.-"}, //  41 29 00101001 ) Close parenthesis (or close bracket)
   {"xxxxxx"}, //  42 2A 00101010 * Asterisk
   {".-.-.x"}, //  43 2B 00101011 + Plus
   {"--..--"}, //  44 2C 00101100 , Comma
   {"-....-"}, //  45 2D 00101101 - Hyphen
   {".-.-.-"}, //  46 2E 00101110 . Period, dot or full stop
   {"-..-.x"}, //  47 2F 00101111 / Slash or divide
   {"-----x"}, //  48 30 00110000 0 Zero
   {".----x"}, //  49 31 00110001 1 One
   {"..---x"}, //  50 32 00110010 2 Two
   {"...--x"}, //  51 33 00110011 3 Three
   {"....-x"}, //  52 34 00110100 4 Four
   {".....x"}, //  53 35 00110101 5 Five
   {"-....x"}, //  54 36 00110110 6 Six
   {"--...x"}, //  55 37 00110111 7 Seven
   {"---..x"}, //  56 38 00111000 8 Eight
   {"----.x"}, //  57 39 00111001 9 Nine
   {"---..."}, //  58 3A 00111010 : Colon
   {"xxxxxx"}, //  59 3B 00111011 ; Semicolon
   {"xxxxxx"}, //  60 3C 00111100 < Less than (or open angled bracket)
   {"-...-x"}, //  61 3D 00111101 = Equals
   {"xxxxxx"}, //  62 3E 00111110 > Greater than (or close angled bracket)
   {"..--.."}, //  63 3F 00111111 ? Question mark
   {".--.-."}, //  64 40 01000000 @ At symbol
   {".-xxxx"}, //  65 41 01000001 A Uppercase A
   {"-...xx"}, //  66 42 01000010 B Uppercase B
   {"-.-.xx"}, //  67 43 01000011 C Uppercase C
   {"-..xxx"}, //  68 44 01000100 D Uppercase D
   {".xxxxx"}, //  69 45 01000101 E Uppercase E
   {"..-.xx"}, //  70 46 01000110 F Uppercase F
   {"--.xxx"}, //  71 47 01000111 G Uppercase G
   {"....xx"}, //  72 48 01001000 H Uppercase H
   {"..xxxx"}, //  73 49 01001001 I Uppercase I
   {".---xx"}, //  74 4A 01001010 J Uppercase J
   {"-.-xxx"}, //  75 4B 01001011 K Uppercase K
   {".-..xx"}, //  76 4C 01001100 L Uppercase L
   {"--xxxx"}, //  77 4D 01001101 M Uppercase M
   {"-.xxxx"}, //  78 4E 01001110 N Uppercase N
   {"---xxx"}, //  79 4F 01001111 O Uppercase O
   {".--.xx"}, //  80 50 01010000 P Uppercase P
   {"--.-xx"}, //  81 51 01010001 Q Uppercase Q
   {".-.xxx"}, //  82 52 01010010 R Uppercase R
   {"...xxx"}, //  83 53 01010011 S Uppercase S
   {"-xxxxx"}, //  84 54 01010100 T Uppercase T
   {"..-xxx"}, //  85 55 01010101 U Uppercase U
   {"...-xx"}, //  86 56 01010110 V Uppercase V
   {".--xxx"}, //  87 57 01010111 W Uppercase W
   {".--.xx"}, //  88 58 01011000 X Uppercase X
   {"-.--xx"}, //  89 59 01011001 Y Uppercase Y
   {"--..xx"}, //  90 5A 01011010 Z Uppercase Z
   {"xxxxxx"}, //  91 5B 01011011 [ Opening bracket
   {"xxxxxx"}, //  92 5C 01011100 \ Backslash
   {"xxxxxx"}, //  93 5D 01011101 ] Closing bracket
   {"xxxxxx"}, //  94 5E 01011110 ^ Caret - circumflex
   {"xxxxxx"}, //  95 5F 01011111 _ Underscore
   {"xxxxxx"}, //  96 60 01100000 ` Grave accent
   {".-xxxx"}, //  97 61 01100001 a Lowercase a
   {"-...xx"}, //  98 62 01100010 b Lowercase b
   {"-.-.xx"}, //  99 63 01100011 c Lowercase c
   {"-..xxx"}, // 100 64 01100100 d Lowercase d
   {".xxxxx"}, // 101 65 01100101 e Lowercase e
   {"..-.xx"}, // 102 66 01100110 f Lowercase f
   {"--.xxx"}, // 103 67 01100111 g Lowercase g
   {"....xx"}, // 104 68 01101000 h Lowercase h
   {"..xxxx"}, // 105 69 01101001 i Lowercase i
   {".---xx"}, // 106 6A 01101010 j Lowercase j
   {"-.-xxx"}, // 107 6B 01101011 k Lowercase k
   {".-..xx"}, // 108 6C 01101100 l Lowercase l
   {"--xxxx"}, // 109 6D 01101101 m Lowercase m
   {"-.xxxx"}, // 110 6E 01101110 n Lowercase n
   {"---xxx"}, // 111 6F 01101111 o Lowercase o
   {".--.xx"}, // 112 70 01110000 p Lowercase p
   {"--.-xx"}, // 113 71 01110001 q Lowercase q
   {".-.xxx"}, // 114 72 01110010 r Lowercase r
   {"...xxx"}, // 115 73 01110011 s Lowercase s
   {"-xxxxx"}, // 116 74 01110100 t Lowercase t
   {"..-xxx"}, // 117 75 01110101 u Lowercase u
   {"...-xx"}, // 118 76 01110110 v Lowercase v
   {".--xxx"}, // 119 77 01110111 w Lowercase w
   {"-..-xx"}, // 120 78 01111000 x Lowercase x
   {"-.--xx"}, // 121 79 01111001 y Lowercase y
   {"--..xx"}, // 122 7A 01111010 z Lowercase z
   {"xxxxxx"}, // 123 7B 01111011 { Opening brace
   {"xxxxxx"}, // 124 7C 01111100 | Vertical bar
   {"xxxxxx"}, // 125 7D 01111101 } Closing brace
   {"xxxxxx"}, // 126 7E 01111110 ~ Equivalency sign - tilde
   {"xxxxxx"}  // 127 7F 01111111   Delete
   };

   if (c<32){
      return Mdummy;
   } else if (c>127) {
      return Mdummy;
   } else {
      return &(M[c-32][0]);
   }
}

void send_char_morse (char c) {
   unsigned char *m;
   int i;

   m=morse_code(c);
   for(i=0;i<6;i++){
      if (   (*(m+i))=='-'   ){
         dash();
      } else if (   (*(m+i))=='.'   ){
         dot();
      } else {
         break;
      }
   }
   Delay(3*LENGTH); // razmak_iza_slova();
}

void dash(void){
   GPIOE->BSRR = BUZZER_ON;
   Delay(3*LENGTH); // razmak(3);
   GPIOE->BSRR = BUZZER_OFF;
   Delay(1*LENGTH); // razmak(1);
}

void dot(void){
   GPIOE->BSRR = BUZZER_ON;
   Delay(1*LENGTH); // razmak(1);
   GPIOE->BSRR = BUZZER_OFF;
   Delay(1*LENGTH); // razmak(1);
}

