// Вот теперь может и сбудется...
#property copyright "Hohla"
#property link      "hohla@mail.ru"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrBlack
#property indicator_color2 clrBlack


extern int HL=1; // 1..9 Type
extern int iHL=8;// 1..8 Period
double HI[], LO[], max, min; 
int Per=1, SessionBars, BarsInDay, f=1;
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
int OnInit(void){
   string Name="HL "+DoubleToStr(HL,0)+"-";
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,HI);   SetIndexLabel(0,"HI");
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,LO);   SetIndexLabel(1,"LO");
   double Adpt=60/Period(); // адаптация периода индикатора к таймфрейму
   switch (HL){
         case 1:  Per=int(MathPow(iHL,1.7)*Adpt);  Name=Name+"Nearest F ("       +DoubleToStr(Per,0)+") iHL="+DoubleToStr(iHL,0); break; //  При пробитии одного из уровней ищутся ближайшие фракталы шириной Per бар. 
         case 2:  Per=int((iHL+1)*Adpt);           Name=Name+"Distant F(1) ATR*" +DoubleToStr(Per,0)+"  iHL="+DoubleToStr(iHL,0); break; // При пробитии одного из уровней ищутся фракталы шириной f=1 далее ATR*Per от текущей цены
         case 3:  Per=int((iHL+1)*Adpt);           Name=Name+"Tr Distant F(1) ATR*"+DoubleToStr(Per,0)+" iHL="+DoubleToStr(iHL,0); break; // Формирование хая на ближайшем фрактале(1) при удалении на ATR*Per от последнего лоу
         case 4:  Per=int((iHL+1)*Adpt);           Name=Name+"Trailing ATR*"     +DoubleToStr(Per,0)+"  iHL="+DoubleToStr(iHL,0); break; // При пробое Н ищется L далее Per*ATR от текущей цены 
         case 5:  Per=int(MathPow(iHL,1.7)*Adpt);  Name=Name+"Classic F("        +DoubleToStr(Per,0)+") iHL="+DoubleToStr(iHL,0); break; // Фракталы шириной Per бар. 
         case 6:  Per=int((iHL+1)*Adpt);           Name=Name+"Strong F(1)ATR*"   +DoubleToStr(Per,0)+"  iHL="+DoubleToStr(iHL,0); break; // При пробое одного из уровней ищутся фракталы шириной f=1 с отскоком (силой) более ATR*Per
         case 7:  Per=int(MathPow(iHL+1,1.7)*Adpt);Name=Name+"Classic ("         +DoubleToStr(Per,0)+") iHL="+DoubleToStr(iHL,0); break; // экстремумы на заданном периоде
         case 8:  Per=int((iHL-1)*3*Adpt);         Name=Name+"DayBegin ("        +DoubleToStr(Per,0)+") iHL="+DoubleToStr(iHL,0); break; // Hi/Lo за 24+N часов
         case 9:  Per=int(iHL*Adpt);               Name=Name+"VolumeCluster ("   +DoubleToStr(Per,0)+") iHL="+DoubleToStr(iHL,0); break; //  
         default: Per=int((iHL+1)*Adpt);           Name=Name+"no ("              +DoubleToStr(Per,0)+") iHL="+DoubleToStr(iHL,0); break;
         }
   BarsInDay=int(24*60/Period());         // кол-во бар в сессии
   SessionBars=int(Per*Adpt)+BarsInDay;   // кол-во бар с начала текущей сессии для (2)
   //Print(" BarsInDay=",BarsInDay," SessionBars=",SessionBars);      
   //Print(Name);  
   max=High[Bars-1]; min=Low[Bars-1];    
   IndicatorShortName(Name);
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ 
double SigHL,  H, L;
int TrendHL=0, DayBar=0;
int start(){ 
   int CountBars=Bars-IndicatorCounted()-1;
   int b=0;
   double D=0, h=0, l=0, c=0, o=0;
   for (int bar=CountBars; bar>0; bar--){ //    Print("HL(",HL,",",iHL,") ",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES));
      if (High[bar]>max)   max=High[bar]+(High[bar]-Low[bar]);
      if (Low [bar]<min)   min=Low [bar]-(High[bar]-Low[bar]);
      switch (HL){
         case 1: // Nearest F(Per). При пробое одного из уровней ищутся ближайшие фракталы шириной Per бар. 
            if (High[bar]>H || Low[bar]<L){   // пробитие одной из границ канала
               H=0; L=0; b=bar;
               f=Per;
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-Per*2) break; // счетчик бар                
                  if (!H && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)]) H=High[b+f]; // пока не найдется новый фрактал выше текущего бара заданной ширины
                  if (!L && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)]) L=Low [b+f];
               }  }
         break; 
         case 2: // Distant F(1). При пробое одного из уровней ищутся фракталы шириной f=1 далее ATR*Per от текущей цены 
            if (High[bar]>H || Low[bar]<L){   // пробитие одной из границ канала
               H=0; L=0; b=bar; 
               D=iATR(NULL,0,100,bar)*Per;
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (!H && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)] && High[b+f]-Low[bar]>D) H=High[b+f]; // пока не найдется новый фрактал выше текущего бара, 
                  if (!L && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)] && High[bar]-Low[b+f]>D) L=Low [b+f]; // давший движение более ATR*Per
               }  }
         break;       
         case 3: // Trend Distant F(1). Формирование хая на ближайшем фрактале(1) при удалении на ATR*Per от последнего лоу
            D=iATR(NULL,0,100,bar)*Per;
            if (TrendHL<=0){ // при нисходящем тренде
               if (Low[bar]<L) FIND_LO(bar,f); // при пробитии L ищем ниже ближайший фрактал шириной f=1
               if (High[bar]>L+D){// отдаление от нижней границы
                  TrendHL=1; 
                  FIND_HI(bar,f); // ближайший фрактал сверху шириной f=1
               }  }        
            if (TrendHL>=0){ // Тренд вверх
               if (High[bar]>H) FIND_HI(bar,f); // при пробитии H ищем выше ближайший фрактал шириной f=1
               if (Low[bar]<H-D){
                  TrendHL=-1;
                  FIND_LO(bar,f);
               }  }  
         break;             
         case 4: // Trailing - При пробое Н ищется L далее Per*ATR от текущей цены 
            if (Low[bar]<L){  // пробой нижней границы 
               H=0; L=0; b=bar; 
               D=Per*iATR(NULL,0,100,bar);
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (!H && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)] && High[b+f]-Low[bar]>D)   H=High[b+f]; // любой фрактал выше текущей цены на Per*ATR 
                  if (!L && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)])                             L=Low [b+f]; // любой ближайший фрактал снизу
               }  }
            if (High[bar]>H ){   // 
               H=0; L=0; b=bar; 
               D=iATR(NULL,0,100,bar)*Per;
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (!H && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)])                             H=High[b+f]; // любой ближайший фрактал сверху 
                  if (!L && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)] && High[bar]-Low[b+f]>D)   L=Low [b+f]; // любой фрактал ниже текущей цены на Per*ATR 
               }  }
         break;
         case 5: // Classic F(Per). Фракталы шириной Per бар. 
            if (bar>Bars-Per-1) break;
            if (High[bar]>H)  FIND_HI(bar,Per); // при пробое верхней границы ищем ближайший фрактал шириной Per
            else              if (High[bar+Per]==High[iHighest(NULL,0,MODE_HIGH,Per*2+1,bar)])  H=High[bar+Per]; // сформировался фрактал шириной Per
            if (Low[bar]<L)   FIND_LO(bar,Per); 
            else              if (Low[bar+Per] ==Low [iLowest (NULL,0,MODE_LOW ,Per*2+1,bar)])  L= Low[bar+Per];
         break;
         case 6:  // Strong F(1) При пробое одного из уровней ищутся фракталы шириной f=1 с отскоком (силой) более ATR*Per
            if (High[bar]>H || Low[bar]<L){   // пробитие одной из границ канала
               H=0; L=0; b=bar; 
               D=iATR(NULL,0,100,bar)*Per;
               double BackH=Low[bar], BackL=High[bar];   // уровни заднего фронта для H и L (величина отскока от пика)
               while (!H || !L){ // обе границы находим заново
                  b++; if (b>Bars-f*2) break; // счетчик бар
                  if (Low [b]<BackH)   BackH=Low[b]; // фиксируем максимальну и минимальную цены от текущего бара до искомых пиков, это будут
                  if (High[b]>BackL)   BackL=High[b];// их Back уровни - движения, которые дал пик.
                  if (!H && High[b+f]>High[bar] && High[b+f]==High[iHighest(NULL,0,MODE_HIGH,f*2+1,b)] && High[b+f]-BackH>D) H=High[b+f]; // пока не найдется новый фрактал выше текущего бара, 
                  if (!L && Low [b+f]<Low [bar] && Low [b+f]==Low [iLowest (NULL,0,MODE_LOW ,f*2+1,b)] && BackL-Low [b+f]>D) L=Low [b+f]; // давший движение более ATR*Per
               }  }
         break;       
         case 7: // HL_Classic 
            if (bar>Bars-Per-1) break;
            b=bar+1; H=High[bar]; L=Low[bar];
            //while(!BarCounter(b,bar,Per)){
            for (b=bar+1; b<=bar+Per; b++){
               if (High[b]>H) H=High[b];
               if (Low[b]<L)  L=Low[b];} 
                
         break;
         case 8: // DayBegin Hi/Lo за 24+N часов
            if (bar>Bars-2) break;
            DayBar++;// номер бара с начала дня
            if (TimeHour(Time[bar])<TimeHour(Time[bar+1])) DayBar=0; // новый день = обнуляем номер бара с начала дня
            if (DayBar==Per){// номер бара с начала дня совпал с заданным значением
               H=High[iHighest(NULL,0,MODE_HIGH,SessionBars,bar)]; // максимум с начала прошлой сессии до текущего бара
               L=Low [iLowest (NULL,0,MODE_LOW ,SessionBars,bar)];
               } 
            if (H<High[bar]) H=High[bar];
            if (L>Low[bar])  L=Low[bar];      
         break;
         case 9: // VolumeCluster
            if (bar>Bars-Per-f-1) break; 
            D=(13-Per)*0.03; // при Per=1..9, D=36%-12%, (25% у автора) 
            c=Close[bar+1];
            h=High[bar+1];
            l=Low [bar+1];
            for (b=bar+1; b<=bar+f+1; b++){
               if (High[b]>h) h=High[b];
               if (Low [b]<l) l=Low [b];
               o=Open[b];
               if (h-l>iATR(NULL,0,100,bar)*1.5){//  Не работаем в узком диапазоне
                  if ((h-o)/(h-l)<D && (h-c)/(h-l)<D) {L=l; H=h;  SigHL=L;} // Нижний "Фрактал" (открытие и закрытие в верхней части Bar баров)
                  if ((o-l)/(h-l)<D && (c-l)/(h-l)<D) {L=l; H=h;  SigHL=H;} // верхний "фрактал"
               }  }  
            if (H<High[bar]) H=High[bar];
            if (L>Low[bar])  L=Low[bar];      
         break;
         default://
            H=High[bar]; L=Low[bar];
         break;   
         }
      
      if (H>0) HI[bar]=H; 
      else HI[bar]=max;// попался исторический максимум, присваиваем максимальное значение графика 
      if (L>0) LO[bar]=L; //Print("HL: H=",H," L=",L);
      else LO[bar]=min;     
      }   
   return(0);
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
void FIND_HI(int bar, int width){
   H=0; int b=bar;
   while (!H){
      b++; if (b>Bars-width*2) break; // счетчик бар
      if (High[b+width]>High[bar] && High[b+width]==High[iHighest(NULL,0,MODE_HIGH,width*2+1,b)]) H=High[b+width];
   }  }   
void FIND_LO(int bar, int width){   
   L=0; int b=bar;
   while (!L){
      b++; if (b>Bars-width*2) break; // счетчик бар
      if (Low [b+width]<Low [bar] && Low [b+width]==Low [iLowest (NULL,0,MODE_LOW ,width*2+1,b)]) L=Low [b+width];
   }  } 
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ    

//double Etalon, Counter;
//int BarCounter(int& b,  int bar,  int per){// способы вычисления периода инидикатора // ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
//   if (b>=Bars-1) return(1);// чтоб не добраться до конца графика :) 
//   switch (PerCnt){
//      case 0: // простой счетчик бар
//         b++;
//         if (b>=bar+per) return(1);   // отсчитали нужное кол-во бар  for (b=bar; b<bar+Per; b++){
//      break;      
//      case 1: // складываем тела свечей, пока сумма не достигнет эталонного значения
//         if (b==bar+1){
//            Etalon=per*iATR(NULL,0,100,bar)*0.5; // величина, к которой с каждым баром приближается длина кривой цены
//            Counter=0; // вначале обнуляем кривую цены
//            }
//         Counter+=MathAbs(Close[b]-Close[b+1]); // с каждым баром увеличиваем длину кривой цены
//         b++; 
//         if (Counter>=Etalon) return(1); // отмерили нужную длину
//      break;
//      case 2: // период эквивалентен количеству смены цветов свечей (равномерности тренда) 
//         if (b==bar+1){Etalon=0; Counter=0;} // обнуляем направление тренда и счетчик изменений этого направления
//         if (Etalon==0 && Close[b]-Open[b]>0){Etalon=1; Counter++;} //меняем направление тренда, фиксируем разворот
//         if (Etalon==1 && Close[b]-Open[b]<0){Etalon=0; Counter++;} //меняем направление тренда, фиксируем разворот
//         b++; 
//         if (Counter*2>per) return(1); // превысили нужное число изменений тренда       
//      break;     
//      }    
//   return(0);             
//   }      
 
   
   