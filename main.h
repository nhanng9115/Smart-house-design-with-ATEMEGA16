
#ifndef __MAIN_H
#define __MAIN_H

#include <mega16.h>
#include <delay.h>
#include <alcd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <usart.h>
#include <usart.c>
#include <ds18b20.h>
#include <1wire.h>

#ifndef cbi 
	#define cbi(port, bit) 	   (port) &= ~(1 << (bit))
#endif
#ifndef sbi 
	#define sbi(port, bit) 	   (port) |=  (1 << (bit))
#endif

#define    AREF_MODE    0                        //dien ap tham chieu ngoai, dien ap tren chan Vref
#define    AVCC_MODE    (1<<REFS0)                //dung dien ap chan AVcc lam dien ap tham chieu, chan Vref gan voi 1 tu dien 
#define    INT_MODE    (1<<REFS1)|(1<<REFS0)    //dung dien ap tham chieu noi 2.56V,  chan Vref gan voi 1 tu dien
#define ADC_VREF_TYPE AREF_MODE                //dinh nghia dien ap tham chieu
//=======================================================================
// khai bao cac chan cho VDK
//===============RELAY==================
#define RELAY   PORTB
#define RELAY1  0 // quat
#define RELAY2  1 // den
#define RELAY3  7 // chuong bao
//===============L298===================
#define L298  PORTD
#define IN1  3
#define IN2  4
#define EN   5 
#define EN_C 6  
//================Button=================

#define mode    PINB.2
#define up      PINB.3
#define down    PINB.4

char Data;
char str[15];
char LCD_Buffer[15];
char *str_adc;
char *str_nguong;
char str1[12];

int Temp,Temp1,i;
unsigned char *T=0; 
unsigned int khoi, anh_sang,khoi1, anh_sang1;
static unsigned int khoi_0_1, khoi_0_2,anh_sang_0_1,anh_sang_0_2,Temp_0,cb_Temp,cb_khoi_1, cb_khoi_2,cb_anh_sang_1, cb_anh_sang_2;
int khoi_ss_1, khoi_ss_2,anh_sang_ss_1,anh_sang_ss_2,Temp_ss;
// ham dieu khien nut bam
unsigned int mode1=0;
unsigned int  nguong; // nguong la bien chung de dieu khien cac gia tri nguong khac
unsigned int nguong_khoi_1 = 100;
unsigned int nguong_khoi_2 = 150;
unsigned int nguong_as_1 = 3;
unsigned int nguong_as_2 = 80;
unsigned int nguong_nhiet = 30;
unsigned int m,n;

void but_ton_khoi_1(){
        //neu nhan nut up
        if(!(PINB & 0x08)) 
        {
            delay_ms(200); 
            if(!(PINB & 0x08)) {
                nguong_khoi_1++; // thi speed tang dan toi 1023 thi ve 0;
                if(nguong_khoi_1>=1023) nguong_khoi_1 = 0;
            }
        }
        // neu nhan down thi nhiet do giam dan toi 0 roi ve 99;
		if(!(PINB & 0x10 )) {
			delay_ms(200);
            if(!(PINB & 0x10)) {
				nguong_khoi_1--;
				if(nguong_khoi_1<=0) nguong_khoi_1=1023;
			}
		} 
}
void but_ton_khoi_2(){
        //neu nhan nut up
        if(!(PINB & 0x08)) 
        {
            delay_ms(200); 
            if(!(PINB & 0x08)) {
                nguong_khoi_2++; // thi speed tang dan toi 1023 thi ve 0;
                if(nguong_khoi_2>=1023) nguong_khoi_2 = 0;
            }
        }
        // neu nhan down thi nhiet do giam dan toi 0 roi ve 99;
		if(!(PINB & 0x10 )) {
			delay_ms(200);
            if(!(PINB & 0x10)) {
				nguong_khoi_2--;
				if(nguong_khoi_2<=0) nguong_khoi_2=1023;
			}
		} 
}
void but_ton_nhiet(){
        //neu nhan nut up
        if(!(PINB & 0x08)) 
        {
            delay_ms(200); 
            if(!(PINB & 0x08)) {
                nguong_nhiet++; // thi speed tang dan toi 1023 thi ve 0;
                if(nguong_nhiet>=125) nguong_nhiet = 0;
            }
        }
        // neu nhan down thi nhiet do giam dan toi 0 roi ve 99;
		if(!(PINB & 0x10 )) {
			delay_ms(200);
            if(!(PINB & 0x10)) {
				nguong_nhiet--;
				if(nguong_nhiet<=0) nguong_nhiet=124;
			}
		} 
}
void but_ton_as_1(){
        //neu nhan nut up
        if(!(PINB & 0x08)) 
        {
            delay_ms(200); 
            if(!(PINB & 0x08)) {
                nguong_as_1++; // thi speed tang dan toi 1023 thi ve 0;
                if(nguong_as_1>=1023) nguong_as_1 = 0;
            }
        }
        // neu nhan down thi nhiet do giam dan toi 0 roi ve 99;
		if(!(PINB & 0x10 )) {
			delay_ms(200);
            if(!(PINB & 0x10)) {
				nguong_as_1--;
				if(nguong_as_1<=0) nguong_as_1=99;
			}
		} 
}
void but_ton_as_2(){
        //neu nhan nut up
        if(!(PINB & 0x08)) 
        {
            delay_ms(200); 
            if(!(PINB & 0x08)) {
                nguong_as_2++; // thi speed tang dan toi 1023 thi ve 0;
                if(nguong_as_2>=1023) nguong_as_2 = 0;
            }
        }
        // neu nhan down thi nhiet do giam dan toi 0 roi ve 99;
		if(!(PINB & 0x10 )) {
			delay_ms(200);
            if(!(PINB & 0x10)) {
				nguong_as_2--;
				if(nguong_as_2<=0) nguong_as_2=99;
			}
		} 
}
// ham doc gia tri ADC
unsigned int read_adc(unsigned char adc_channel){//chuong trinh con doc ADC theo tung channel    
    ADMUX=adc_channel|ADC_VREF_TYPE;
    ADCSRA|=(1<<ADSC);                    //bat dau chuyen doi             
    while ((ADCSRA & 0x10)==0); //cho den khi nao bit ADIF==1  
    ADCSRA |= 0x10;
    return ADCW; // thanh ghi ADCW chua ADC word doc duoc
}
//ham hien thi len LCD
void dis_LCD(char  *ch, unsigned int x){
    lcd_gotoxy(0,0);
    lcd_puts(ch);  
    sprintf(LCD_Buffer,"%5i", x);
    lcd_gotoxy(1,1);
    lcd_puts(" ");
    lcd_gotoxy(1,1);
    lcd_puts(LCD_Buffer);  

}    
//=======================================================================
// do cac thong so nhiet do, a/s, khoi
void read_parameter(){
    Temp=ds18b20_temperature(T);    // doc gia tri nhiet do va gan vao  bien Temp
    khoi = read_adc(0);    // doc gia tri khoi
    anh_sang = 0.17*read_adc(1);// doc gia tri cuong do anh sang
}

//======================so sanh======================================
void so_sanh(){
    Temp_ss = Temp - Temp_0; 
    khoi_ss_1 = khoi - khoi_0_1;
    khoi_ss_2 = khoi - khoi_0_2;
    anh_sang_ss_1 = anh_sang - anh_sang_0_1;
    anh_sang_ss_2 = anh_sang - anh_sang_0_2;
    if (Temp_ss >= 0) {
        cb_Temp = 0;  // = 0 thi canh bao
        }
    else cb_Temp = 1;  // = 1 thi "an toan"
    
    if ((khoi_ss_1 >= 0)&&(khoi_ss_2<0)) {
        cb_khoi_1 = 0;
    }
    else cb_khoi_1 = 1; 
    
    if (khoi_ss_2 >=0){
        cb_khoi_2 = 0;
    }
    else cb_khoi_2 = 1;
        
    if (anh_sang_ss_1 <= 0) {
        cb_anh_sang_1 = 0;
    }
    else cb_anh_sang_1 = 1;
    if (anh_sang_ss_2 >= 0) {
        cb_anh_sang_2 = 0;
    }
    else cb_anh_sang_2 = 1;
       
}    
// hien thi LCD
/* LCD thuc hien hien thi:
        1. hien thi che do hoat dong: "an toan/canh bao dk phong"
            1.1 khi cac gia tri dung dai an toan thi hien thi "AN TOAN"
            1.2 khi gia tri nao vuot qua muc nguong thi hien thi "CANH BAO DK PHONG" , uu tien canh bao chay trong TH có nhieu canh baoo
        2. Khi o che do canh bao, neu nhap gia tri dieu khien tu PC thi LCD se hien thi gia tri vua nhap len */          

void dis_LCD_cb(){
    lcd_clear();  
        // uu tien canh bao chay cao nhat
        if (!cb_khoi_1){ 
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("CANH BAO CHAY"); // neu ca 3 thong so =1 thi an toan         
            lcd_gotoxy(0,1);
            lcd_puts("MUC 1"); 
        }   
         
        else if (!cb_khoi_2){ 
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("CANH BAO CHAY"); // neu ca 3 thong so =1 thi an toan         
            lcd_gotoxy(0,1);
            lcd_puts("MUC 2");
        } 
        else {
            if ((!cb_Temp)||(!cb_anh_sang_1)||(!cb_anh_sang_2)){
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_puts("CANH BAO"); // neu ca 3 thong so =1 thi an toan 
                lcd_gotoxy(0,1);
                lcd_puts("DK PHONG");
            }  
        }          
   /* if (!cb_Temp) {
        lcd_clear();
        dis_LCD("nhiet do !!!", Temp);
    }
    if (!cb_anh_sang) {
        lcd_clear();
        dis_LCD("anh sang !!!", anh_sang);
    }
    if (!cb_khoi) {   
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_puts("khoi");
        lcd_gotoxy(1,1);
        lcd_puts("chay....");
    } */
        
}   


// ham hien thi cac gia tri len PC
void dis_PC_parameter(){
     sprintf(str,"Nd");
     itoa(Temp,str_adc);
     *strcpy(str1,str_adc);
     strcat(str,str1);
     puts(str); 
     delay_ms(100); 

     sprintf(str,"As");
     itoa(anh_sang,str_adc);
     *strcpy(str1,str_adc);
     strcat(str,str1); 
     puts(str); 
     delay_ms(100);
}  
//==============================================================
//ham hien thi cac gia tri nguong len PC
void dis_PC_nguong(){
     sprintf(str,"Nguong_Nd"); // gia tri nguong nhiet do
     itoa(Temp_0,str_nguong);
     *strcpy(str1,str_nguong);
     strcat(str,str1);
     puts(str); 
     delay_ms(100); 

     sprintf(str,"1_Nguong_As");     // nguong duoi cua anh sang, khi duoi muc nguong nay thi turn on the light and move up the curtain.
     itoa(anh_sang_0_1,str_nguong);
     *strcpy(str1,str_nguong);
     strcat(str,str1); 
     puts(str); 
     delay_ms(100);   
     
     
     sprintf(str,"2_Nguong_As");     // nguong tren cua anh sang, khi tren muc nguong nay thi turn of the light and move down the curtain
     itoa(anh_sang_0_2,str_nguong);   // Vinh oi may cho hien thi cho nguong anh sang gom nguong tren va nguong duoi nha
     *strcpy(str1,str_nguong);         // hien thi duoi dang "a" - "b" trong do a=anh_sang_0_1, b= anh_sang_0_2
     strcat(str,str1); 
     puts(str); 
     delay_ms(100);
     
}
//=======================================================================
void dis_PC_cb(){
    if (Temp>Temp_0) {  
        sprintf(str,"a1-");  // do
        puts(str);    
        delay_ms(200); 
    }              
    else {
        sprintf(str,"a1+");//xanh
        puts(str);    
        delay_ms(200);        
    }
        
    if ((anh_sang_0_1<anh_sang)&&(anh_sang<anh_sang_0_2)) {    //nam trong dai anh sang phu hop
        sprintf(str,"a2+");      // xanh
        puts(str);    
        delay_ms(200);
    }              
    else {
        sprintf(str,"a2-");    //do
        puts(str);    
        delay_ms(200);
    } 
    if ((khoi>khoi_0_1)&&(khoi<khoi_0_2)) {  
        sprintf(str,"a3_1-");     //canh bao muc 1
        puts(str);    
        delay_ms(200);
    }
    else if (khoi>=khoi_0_2){
        sprintf(str,"a3_2-");      // canh bao muc 2
        puts(str);    
        delay_ms(200); 
    }                
    else {
        sprintf(str,"a3+");       // an toan = den xanh
        puts(str);    
        delay_ms(200);
    } 
}      
void control(){
    // dk quat
     if (cb_Temp == 0) {sbi(RELAY, RELAY1);} // bat quat 
     if (cb_Temp == 1) {cbi(RELAY, RELAY1);} // tat quat   
     // dieu khien rem, bat den khi anh_sang <200 
     if (anh_sang < anh_sang_0_1) { 
        sbi(RELAY, RELAY2);// bat den  
     }
     else { 
        cbi(RELAY, RELAY2);// tat den  
     }
     delay_ms(10);  
     //cbi(L298, EN); //tat rem  
     // DIEU KHIEN BAO DONG KHI CÓ CHÁY   
     if (cb_khoi_1 == 0) {
            sbi(RELAY, RELAY3); // bat den bao dong 
     }
     if (cb_khoi_2 == 0) {
        unsigned int i;
        for ( i=0;i<10;i++){
            sbi(RELAY, RELAY3); // bat den bao dong 
            delay_ms(50);
            cbi(RELAY, RELAY3); //tat den (nhap nhay)
            delay_ms(50);
        }
     }
     if ((cb_khoi_1 == 1)&&(cb_khoi_2 == 1)) {cbi(RELAY, RELAY3);} // tat den bao chay           
}


void execute() {
    if(rx_buffer[rx_wr_index-1] == 13) {
        if(rx_buffer[0] == 't') {
             unsigned char* str;   
             int index = 0;
             int i; 
             int nn;
             for(i = 1; i < rx_wr_index; i++) {
                str[index++] = rx_buffer[i];
               // str++;
             } 
             nn = atoi(str);
             Temp_0 = nn;
        }
        else if(rx_buffer[0] == 'l') {
             unsigned char* str;   
             int index = 0; 
             int nn;   
             int i;
             for(i = 1; i < rx_wr_index; i++) {
                str[index++] = rx_buffer[i];
               // str++;
             } 
             nn = atoi(str);
             anh_sang_0_1 = nn; 
        };

        rx_wr_index = 0;
        rx_counter = 0;
    }
}
#endif 
// ------------------END OF FILE-------------------
// ------------------------------------------------