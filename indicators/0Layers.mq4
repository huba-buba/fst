// Вот теперь может и сбудется...
#property copyright "Hohla"
#property link      "hohla@mail.ru"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 White    // H1
#property indicator_color2 Yellow    // H2
#property indicator_color3 Orange    // H3
#property indicator_color4 Red // H4
#property indicator_color5 White // L1
#property indicator_color6 Yellow // L2
#property indicator_color7 Orange // L3
#property indicator_color8 Red // L4

extern int N=5; 
double   H1[],H2[],H3[],H4[],
         L1[],L2[],L3[],L4[], 
         H, L, C, P;       
         
int OnInit(void){//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   IndicatorBuffers(8);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexStyle(7,DRAW_LINE);
   SetIndexBuffer(0,H1);
   SetIndexBuffer(1,H2);
   SetIndexBuffer(2,H3);
   SetIndexBuffer(3,H4);
   SetIndexBuffer(4,L1);
   SetIndexBuffer(5,L2);
   SetIndexBuffer(6,L3);
   SetIndexBuffer(7,L4);
   IndicatorShortName("Extremums ");
   SetIndexLabel(0,"H1");
   SetIndexLabel(1,"H2");
   SetIndexLabel(2,"H3");
   SetIndexLabel(3,"H4");
   SetIndexLabel(4,"L1");
   SetIndexLabel(5,"L2");
   SetIndexLabel(6,"L3");
   SetIndexLabel(7,"L4");
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ

int start(){//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
   int bar,j,CountBars=Bars-IndicatorCounted()-1;
   double time, time1;
   for (bar=CountBars; bar>0; bar--){
      if (N<3){
         j=1440/Period(); // щитаем, скока баров в дне
         if (TimeHour(Time[bar])<TimeHour(Time[bar+1])){  // ищем конец прошлого дня
            H=High[iHighest(NULL,0,MODE_HIGH,j,bar)];   // щитаем экстремумы
            L=Low [iLowest (NULL,0,MODE_LOW,j,bar)];    // прошлого дня
            C=Close[bar+1];                             // и его цену закрытия
            P=(H+L+C)/3;
            }
         if (N==0){// Camarilla Equation ORIGINAL
            H4[bar]=C+(H-L)*1.1/2;    
            H3[bar]=C+(H-L)*1.1/4;    
            H2[bar]=C+(H-L)*1.1/6;  
            H1[bar]=C+(H-L)*1.1/12;
            L4[bar]=C-(H-L)*1.1/2;    
            L3[bar]=C-(H-L)*1.1/4;    
            L2[bar]=C-(H-L)*1.1/6;  
            L1[bar]=C-(H-L)*1.1/12;  
            }
         if (N==1){ // Camarilla Equation My Edition
            H4[bar]=C+(H-L)*4/4;    
            H3[bar]=C+(H-L)*3/4;    
            H2[bar]=C+(H-L)*2/4;  
            H1[bar]=C+(H-L)*1/4;
            L4[bar]=C-(H-L)*4/4;    
            L3[bar]=C-(H-L)*3/4;    
            L2[bar]=C-(H-L)*2/4;  
            L1[bar]=C-(H-L)*1/4;  
            }
         if (N==2){// Метод Гнинспена (Валютный спекулянт-48, с.62)
            H1[bar]=P; L1[bar]=P;  
            H2[bar]=2*P-L;    
            L2[bar]=2*P-H;    
            H3[bar]=P+(H-L);  
            L3[bar]=P-(H-L);
            H4[bar]=H3[bar]; L4[bar]=L3[bar];  
         }  }
      else{ // if (N>=3) Метод Гнинспена (Валютный спекулянт-48, с.62), экстремум ищется не на прошлом дне, а на барах с 0 часов до N бара текущего дня
         int TimeBar=N;
         if (Period()>60) TimeBar=MathFloor(N*60/Period())+1; // для ТФ>часа делаем N кратно ТФ. Для Н4:  при N=3 TimeBar=0;  при N=6 TimeBar=1;  при N=10 TimeBar=2;
         if (TimeBar>1440/Period()-1) TimeBar=1440/Period()-1; // 1440/Period()- число бар в дне для ТФ с периодом Period()   
         time =(TimeHour(Time[bar  ])*60+TimeMinute(Time[bar  ])) / Period(); // приводим текущее время в количество бар с начала дня
         time1=(TimeHour(Time[bar+1])*60+TimeMinute(Time[bar+1])) / Period(); 
         if (time>=TimeBar && time1<TimeBar){ // текущее время соответствует заданному количеству бар
            for (j=TimeBar; j>0; j--) if (TimeDay(Time[bar+j])!=TimeDay(Time[bar+j+1])) break; // вычисляем, скока бар назад был 0 час. В идиале j=N, но это если в истории нет пропусков  
            H=High[iHighest(NULL,0,MODE_HIGH,j,bar)];
            L=Low [iLowest (NULL,0,MODE_LOW,j,bar)];
            C=Close[bar];
            P=(H+L+C)/3;
            } 
         H1[bar]=P; L1[bar]=P;  
         H2[bar]=2*P-L;    
         L2[bar]=2*P-H;    
         H3[bar]=P+(H-L);  
         L3[bar]=P-(H-L);
         H4[bar]=H3[bar]; L4[bar]=L3[bar];  
      }  }
   return(0);
   }//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
 
   

