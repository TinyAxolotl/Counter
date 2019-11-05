/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 22.08.2018
Author  : 
Company : 
Comments: 


Chip type               : ATmega8A
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#define DS1302_E 2
#define DS1302_SCLK 0
#define DS1302_IO 1
#define DS1302_DDR_RTC DDRC
#define DS1302_PORT_RTC PORTC
#define DS1302_PIN_RTC PINC
#define IN1   PORTB.7
#define IN2   PORTD.5
#define IN3   PORTD.6
#define IN4   PORTD.7
#define left_button  PINB.4
#define right_button  PINB.3
#define OK_button      PINB.2

#define step 4096

#define AM 0
#define PM 0b00100000

#define H12 0b10000000
#define H24 0

#include <mega8.h>
#include <delay.h>
#include <io.h>
#include <stdio.h>
#include <alcd.h>


   char buffer[16];
   unsigned long int steps=0;
   int i=0, counter_sec=0, screen=0;
   bit flag_get_date=0, flag_start_motor=0, flag_forward=0, left=1, right=1, OK=1, flag_feed=0, flag_first_move=0, flag_return=0;
   volatile eeprom int flag_activ_korm=0, flag_activ_svet=0;     
   
   
typedef    struct
    {
    int        Sec;
    int        Min;
    int        Hour;
    int        Month;
    int        Day;
    int        Year;
    int        WeekDay;
    int        AMPM;
    int        H12_24;
    } tpDateTime;

tpDateTime    DateTime;

int DS1302_Bin8_To_BCD(int data)
{
   int nibh;
   int nibl;

   nibh=data/10;
   nibl=data-(nibh*10);

   return((nibh<<4)|nibl);
}

int DS1302_BCD_To_Bin8(int data)
{
unsigned char result;        
    result = ((data>>4) & 0b00000111);
    data &= 0x0F;
    data = data + result*10;
    return data;
}

//посылаем команду или байт данных в часы
void ds1302_write(unsigned char cmd)
{
unsigned char i;
    DS1302_DDR_RTC |= (1<<DS1302_E) | (1<<DS1302_SCLK);
    DS1302_PORT_RTC |= (1<<DS1302_E);//E=1
    delay_us(1);
    DS1302_DDR_RTC |= (1<<DS1302_IO);//выход
    for(i=0; i<8; i++)
    {
        if((cmd&(1<<i)) == 1<<i)
        {
            DS1302_PORT_RTC |= (1<<DS1302_IO);
        }
        else
        {
            DS1302_PORT_RTC &= ~(1<<DS1302_IO);
        }
        DS1302_PORT_RTC |= (1<<DS1302_SCLK);
        delay_us(1);
        DS1302_PORT_RTC &= ~(1<<DS1302_IO);
        DS1302_PORT_RTC &= ~(1<<DS1302_SCLK);
    } 
}
//вызываем после записи байта данных в часы
void ds1302_end_write_data()
{
    DS1302_PORT_RTC &= ~(1<<DS1302_E);
}

unsigned char ds1302_read()
{
unsigned char readbyte;
unsigned char i;
    readbyte=0;
    DS1302_DDR_RTC &= ~(1<<DS1302_IO);
    for(i=0;i<8;i++)
    {
        DS1302_PORT_RTC |= 1<<DS1302_SCLK;
        if((DS1302_PIN_RTC & (1<<DS1302_IO))==0)
        {
            readbyte &= ~(1<<i);
        }
        else
        {
            readbyte |= 1<<i;
        }
        delay_us(1);
        DS1302_PORT_RTC &= ~(1<<DS1302_SCLK);
        delay_us(1);
    }
    DS1302_PORT_RTC &= ~(1<<DS1302_E);
    delay_us(1);
    return readbyte;
}

void DS1302_ReadDateTime() {
    //read seconds
    ds1302_write(0x81);
    DateTime.Sec = DS1302_BCD_To_Bin8(ds1302_read());
    //read minutes
    ds1302_write(0x83);
    DateTime.Min = DS1302_BCD_To_Bin8(ds1302_read());
    //read hour
    ds1302_write(0x85);
    DateTime.Hour = ds1302_read();
    DateTime.AMPM = (DateTime.Hour & 0b00100000);
    DateTime.H12_24 = (DateTime.Hour & 0b10000000);
    if (DateTime.H12_24 == H12) {
        DateTime.Hour = DateTime.Hour & 0b00011111;
    }
    else {
        DateTime.Hour = DateTime.Hour & 0b00111111;
    }
    DateTime.Hour = DS1302_BCD_To_Bin8(DateTime.Hour);
    //read day
    ds1302_write(0x87);
    DateTime.Day = DS1302_BCD_To_Bin8(ds1302_read());
    //read month
    ds1302_write(0x89);
    DateTime.Month = DS1302_BCD_To_Bin8(ds1302_read());
    //read weekday
    ds1302_write(0x8B);
	DateTime.WeekDay=ds1302_read();
	//read year
	ds1302_write(0x8D);
	DateTime.Year = DS1302_BCD_To_Bin8(ds1302_read());
}

void DS1302_WriteDateTime() {
int tmp;
	//set seconds
	ds1302_write(0x80);
	ds1302_write(DS1302_Bin8_To_BCD(DateTime.Sec));
	ds1302_end_write_data();
	//set minutes
	ds1302_write(0x82);
	ds1302_write(DS1302_Bin8_To_BCD(DateTime.Min));
	ds1302_end_write_data();
	//set hour	
	tmp = (DS1302_Bin8_To_BCD(DateTime.Hour) | DateTime.AMPM | DateTime.H12_24);
	ds1302_write(0x84);
	ds1302_write(tmp);
	ds1302_end_write_data();
	//set dade
	ds1302_write(0x86);
	ds1302_write(DS1302_Bin8_To_BCD(DateTime.Day));
	ds1302_end_write_data();
	//set month
	ds1302_write(0x88);
	ds1302_write(DS1302_Bin8_To_BCD(DateTime.Month));
	ds1302_end_write_data();
	//set day (of week)
	ds1302_write(0x8A);
	ds1302_write(DateTime.WeekDay);
	ds1302_end_write_data();
	//set year
	ds1302_write(0x8C);
	ds1302_write(DS1302_Bin8_To_BCD(DateTime.Year));
	ds1302_end_write_data();
}
   
   
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0x83;
if (steps > 0)
{
    
    switch(i)
        {
        case 0:   IN1=0; break;
        case 1:   IN3=1; break;
        case 2:   IN4=0; break;
        case 3:   IN2=1; break;
        case 4:   IN3=0; break;
        case 5:   IN1=1; break;
        case 6:   IN2=0; break;
        case 7:   IN4=1; break;
        } 
    
    
    if(flag_forward==0)
        {
        i++;
        if(i>7)
            i=0;
        }
    else
        {
        i--;
        if(i<0) 
            i=7;
        }     
    steps--;
    
}
else
    {
    IN1=0;
    IN2=0;
    IN3=0;
    IN4=0;
    }
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{

TCNT1H=0xCF2C >> 8;
TCNT1L=0xCF2C & 0xff;
switch(screen)                     // Вывод меню
 {
    case 0:                                           // Вывод основной инф.   
    {
        DS1302_ReadDateTime();
        sprintf(buffer, "%02i:%02i:%02i", DateTime.Hour, DateTime.Min, DateTime.Sec);
        lcd_gotoxy(0,0);
        lcd_puts(buffer);
    
        if(flag_get_date == 0 || (DateTime.Hour>23 && DateTime.Min>59))
            {
            sprintf(buffer, "%02i,%01i,%02i", DateTime.Day, DateTime.Month, DateTime.Year);
            lcd_gotoxy(0,1);
            lcd_puts(buffer);
            flag_get_date = 1;
            };                  
            
        if (flag_activ_korm==0)
            {
            lcd_gotoxy(10,0);
            lcd_putsf("K OFF");
            }
        else
            {
            lcd_gotoxy(10,0);
            lcd_putsf("K ON");
            }    
        
        
        if (flag_activ_svet==0)
            {
            lcd_gotoxy(10,1);
            lcd_putsf("S OFF");
            }
        else
            {
            lcd_gotoxy(10,1);
            lcd_putsf("S ON");
            }
        if(left==0 || right==0)
            {
            screen=1;
            left=1;
            right=1;
            } 
        if(OK==0);
            OK=1;
        break; 
    }
    
    case 1:                                            // Возможность войти в меню настройки    
    {
        lcd_clear();
        lcd_gotoxy(3,1);
        lcd_putsf("HACTROuKA");
        
        if(left==0 || right==0)
            {
            lcd_clear();
            screen=0;
            left=1;
            right=1;
            flag_get_date=0;
            };
        if(OK==0)
            {
            OK=1;
            screen=2;
            }
        break;
    }
    
    case 2:
    {
                                                        // Настройка параметра 1. Вкл\выкл автокормушки
        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf("ABTOKOPMyLLIKA");
        lcd_gotoxy(1,1);
        lcd_putsf("PAR 1   ON  OFF");
        
        if(left==0)
            { 
            screen=10;
            left=1;
            }
        if(right==0)
            {
            screen=3;
            right=1;
            }
        if(OK==0)
            {
            screen=20;
            OK=1;
            }
        break;
    }
    
    case 3:
    {         
        lcd_clear();
        lcd_gotoxy(4,0);
        lcd_putsf("PODCBETKA");                       // Настройка параметра 2. Вкл\выкл света
        lcd_gotoxy(1,1);
        lcd_putsf("PAR 2   ON  OFF");
        
        if(left==0)
            { 
            screen=2;
            left=1;
            }
        if(right==0)
            {
            screen=10;
            right=1;
            }
        if(OK==0)
            {
            screen=30;
            OK=1;
            }
        break;
    }       
    
    case 10:                                            // Выход из настройки
    {
        lcd_clear();
        lcd_gotoxy(5,0);
        lcd_putsf("EXIT?");                      
        
        if(left==0)
            { 
            screen=3;
            left=1;
            }
        if(right==0) 
            {
            screen=2;
            right=1;
            }
        if(OK==0)  
            {
            lcd_clear();
            flag_get_date=0;
            screen=0;
            OK=1;
            }                                              
        break;
    }
    
    case 20:                                             // Вкл\выкл автокормушки
    {
        lcd_clear();
        if(left==0)
            {
                flag_activ_korm=1;
                left=1;
                right=1;
            };
        if(right==0)
            {       
                flag_activ_korm=0;
                left=1;
                right=1;
                
            };
        if(flag_activ_korm==1)
            {
                lcd_gotoxy(1,0);
                lcd_putsf("ABTOKOPMyLLIKA");
                lcd_gotoxy(4,1);
                lcd_putsf("B K JI");
            }
        else
            {
                lcd_gotoxy(1,0);
                lcd_putsf("ABTOKOPMyLLIKA");
                lcd_gotoxy(4,1);
                lcd_putsf("B bI K JI");
            }
        if(OK==0)
            {
                screen=2;
                OK=1;
            }
        break;
    }
    
        case 30:                                             // Вкл\выкл подсветки
    {
        lcd_clear();
        if(left==0)
            {
                flag_activ_svet=1; 
                left=1;
                right=1;
            };
        if(right==0)
            {       
                flag_activ_svet=0;
                
                left=1;
                right=1;
            };
        if(flag_activ_svet==1)
            {
                lcd_gotoxy(4,0);
                lcd_putsf("PODCBETKA");
                lcd_gotoxy(4,1);
                lcd_putsf("B K JI");
            }
        else
            {
                lcd_gotoxy(4,0);
                lcd_putsf("PODCBETKA");
                lcd_gotoxy(4,1);
                lcd_putsf("B bI K JI");  
            }
        if(OK==0)
            {
                screen=3;
                OK=1;
            }
        break;
    }
       
}

if(counter_sec%10==0)               // Опрос кнопок каждую секунду
    {
        if(left_button==0)
            left=0;
        if(right_button==0)
            right=0;
        if(OK_button==0)
            OK=0;
    }

if(flag_activ_korm==1 && DateTime.Hour == 20 && flag_start_motor == 0 && flag_feed == 0)
    {
        flag_start_motor=1;
        flag_forward=0;
        flag_feed=1;
        flag_first_move=1;
    }       

if(DateTime.Hour != 20)
    flag_feed=0;   
    
if(flag_start_motor == 1 && flag_forward == 0 && steps == 0 && flag_first_move==1)
{
    steps = step * 30;
    flag_first_move=0;
}

if(flag_start_motor == 1 && flag_forward == 0 && steps == 0 && flag_first_move == 0)
{
    flag_forward = 1;
    flag_start_motor=0;
    steps = step * 50;
    flag_return=1;
}

if(flag_return == 1 && steps==0 && flag_forward==1)
{
    flag_forward = 0;
    steps = step * 20;
    flag_return=0;
}

if(flag_activ_svet == 1 && (DateTime.Hour > 8 && DateTime.Hour < 23))
    {
    PORTB.5 = 1;
    }          
else
    {
    PORTB.5 = 0;
    }

counter_sec++;
if (counter_sec>50)
    counter_sec=0;         
}


void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=1 Bit6=1 Bit5=1 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1 
PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
//TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
//TCNT0=0xB2;
TCCR0=(0<<CS02) | (1<<CS01) | (1<<CS00);
TCNT0=0x83;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125,000 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0,5 s
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
TCNT1H=0x0B;
TCNT1L=0xDC;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);


// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTD Bit 0
// RD - PORTB Bit 1
// EN - PORTD Bit 1
// D4 - PORTD Bit 2
// D5 - PORTD Bit 3
// D6 - PORTD Bit 4
// D7 - PORTB Bit 6
// Characters/line: 16
lcd_init(16);

/*

if(flag_set_time<0 && flag_set_time>0) 
{
   // Задаем время и параметры (AM/PM следует задавать только при H12)
    DateTime.Sec = 0;
    DateTime.Min = 13;
    DateTime.Hour = 21;
    DateTime.Month = 9;
    DateTime.Day = 27;
    DateTime.Year = 18;
    //DateTime.WeekDay = 2;
    //DateTime.AMPM = AM;   //AM/PM
    DateTime.H12_24 = H24;  //H12/H24

// Записываем время в микросхему ds1302
    DS1302_WriteDateTime();    
    
    flag_set_time = 1;  

}

 */

// Global enable interrupts
#asm("sei")

while (1)
      {
      

      }
}
