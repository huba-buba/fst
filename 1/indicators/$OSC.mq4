// Вот теперь может и сбудется...
#property copyright "Hohla"
#property link      "hohla@mail.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 SpringGreen
#property indicator_color2 Green
#property indicator_color3 Gray
#property indicator_color4 Gray

extern int MODE=5;// MODE=1..5
extern int HL=1;  // HL=1..9
extern int iHL=8; // iHL=1..8

double Buffer0[],Buffer1[],Buffer2[],Buffer3[];

int OnInit(void){//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   string Name="OSC "+DoubleToStr(MODE,0)+"-";
   IndicatorBuffers(4);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,Buffer0);    SetIndexLabel(0,"Buf0");
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,Buffer1);    SetIndexLabel(1,"Buf1");
   SetIndexStyle(2,DRAW_LINE);   SetIndexBuffer(2,Buffer2);    SetIndexLabel(2,"Buf2");
   SetIndexStyle(3,DRAW_LINE);   SetIndexBuffer(3,Buffer3);    SetIndexLabel(3,"Buf3");
   switch (MODE){
         case 1:  Name=Name+"HL/sHL (HL="+DoubleToStr(HL,0)+", iHL="+DoubleToStr(iHL,0)+") ";break; // Отношение последней HL к средней HL, посчитанной за per раз
         case 2:  Name=Name+"Canal  (HL="+DoubleToStr(HL,0)+", iHL="+DoubleToStr(iHL,0)+") ";break; // Цена HLC/3 в канале 
         case 3:  Name=Name+"LastHL (HL="+DoubleToStr(HL,0)+", iHL="+DoubleToStr(iHL,0)+") ";break; // фиксируются экстремумы HL до формирования следующих
         case 4:  Name=Name+"LastHL (HL="+DoubleToStr(HL,0)+", iHL="+DoubleToStr(iHL,0)+") ";break; // фиксируются вершины экстремумов HL до формирования следующих
         case 5:  Name=Name+"Fractal (HL="+DoubleToStr(HL,0)+", iHL="+DoubleToStr(iHL,0)+") ";break; // фракталы по HiLo
         }
   IndicatorShortName(Name);
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ

#define N  30 // количество диапазонов HL для усреднения
double OSC, OscBorder=0, hl[N+1], HLC=0, LO, HI;
double H,L,H1,L1,H2,L2,H3,L3;
int start(){//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   int CountBars=Bars-IndicatorCounted()-1;
   if (CountBars>Bars-1) return(0);
   for (int bar=CountBars; bar>0; bar--){ //Print("  OSC ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES));
      H =iCustom(NULL,0,"$HL",HL,iHL,0,bar);   
      L =iCustom(NULL,0,"$HL",HL,iHL,1,bar);
      H1=iCustom(NULL,0,"$HL",HL,iHL,0,bar+1);   // щщитаем прошлые hi / lo
      L1=iCustom(NULL,0,"$HL",HL,iHL,1,bar+1);
      H2=iCustom(NULL,0,"$HL",HL,iHL,0,bar+2);   // щщитаем позапрошлые hi / lo
      L2=iCustom(NULL,0,"$HL",HL,iHL,1,bar+2);
      H3=iCustom(NULL,0,"$HL",HL,iHL,0,bar+3);   // щщитаем позапрошлые hi / lo
      L3=iCustom(NULL,0,"$HL",HL,iHL,1,bar+3);
      switch (MODE){
         case 1: // Отношение последней HL к средней HL, посчитанной за N раз  ////////////////////////////////////////////////////////////////////////////////////////////////////
            if (hl[0]!=H-L){// сформировался новый диапазон HL
               OSC=0;
               hl[0]=H-L;   // обновим последний диапазон
               for (int b=N; b>0; b--){
                  hl[b]=hl[b-1]; // пересортируем массив, чтобы новое значение было с индексом 1 
                  OSC+=hl[b];   // за одно посчитаем сумму всех значений
                  }
               OSC/=N; // посчитаем среднее N диапазонов без учета последнего диапазона
               }
            Buffer0[bar]=OSC;  // Среднее значение N диапазонов HL
            Buffer1[bar]=hl[0]; // Последний диапазон HL
         break;
         case 2: // Цена HLC/3 в канале //////////////////////////////////////////////////////////////////////////////////////////////////////////
            HLC=(High[bar]+Low[bar]+Close[bar])/3;
            if (H-L>0) OSC=(HLC-L)/(H-L)-0.5; // нормализация к нулевому значению
            if (H>H1) OscBorder=0.5; // Новый максимум
            if (L<L1) OscBorder=-0.5; // Новый минимум
            Buffer0[bar]=OSC;
            Buffer1[bar]=OscBorder; 
         break;
         case 3: // фиксируются экстремумы HL до формирования следующих
            if (L1>L)  LO=L; // сформировался очередной минимум 
            if (H1<H)  HI=H; // сформировался очередной максимум
            Buffer0[bar]=LO;
            Buffer1[bar]=HI; 
            Buffer2[bar]=H;
            Buffer3[bar]=L;  
         break;
         case 4: // фиксируются вершины экстремумов HL до формирования следующих
            if (L3>L2 && L2<=L1)  LO=L2; // сформировался очередной минимум 
            if (H3<H2 && H2>=H1)  HI=H2; // сформировался очередной максимум
            Buffer0[bar]=LO;
            Buffer1[bar]=HI; 
            Buffer2[bar]=H1;
            Buffer3[bar]=L1;  
         break;
         case 5: // фракталы по Hi Lo
            if (L3>L2 && L2<=L1)  OSC=1; // сформировался очередной минимум, тренд вверх 
            if (H3<H2 && H2>=H1)  OSC=-1; // сформировался очередной максимум, тренд вниз
            Buffer0[bar]=OSC;
            Buffer1[bar]=0; 
            Buffer2[bar]=0;
            Buffer3[bar]=0;  
         break;
         }
 
      }
   return(0);
   }//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
  
   

