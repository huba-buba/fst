#property copyright "Hohla"
#property link      "mail@hohla.ru"
#property version   "181.212" // yym.mdd
#property description "ATR_Dual"
#property strict // Указание компилятору на применение особого строгого режима проверки ошибок 
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 clrBlack
#property indicator_color2 clrRoyalBlue
#property indicator_color3 clrWhite

extern int a=4;
extern int A=200; 
double atr[],ATR[],HL[];
int MinBars;

int OnInit(void){//ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
   string short_name="ATR2: atr("+DoubleToStr(a,0)+"), ATR("+DoubleToStr(A,0)+")"; 
   IndicatorBuffers(3); // т.к. temp[] тоже считается
   IndicatorDigits(Digits);
   SetIndexStyle(0,DRAW_LINE);   SetIndexBuffer(0,atr);  SetIndexLabel(0,"atr"); //SetIndexDrawBegin(0,a);
   SetIndexStyle(1,DRAW_LINE);   SetIndexBuffer(1,ATR);  SetIndexLabel(1,"ATR"); //SetIndexDrawBegin(1,A);
   SetIndexBuffer(2,HL); 
   IndicatorShortName(short_name);
   MinBars=MathMax(a,A);
   CHART_SETTINGS();
   if (a<1 || A<1 ){ //  Bars<=
      Print("ATR: Wrong input parameter, a=",a," A=",A," Bars=",Bars," Time[Bars]=",TimeToStr(Time[Bars-1],TIME_DATE | TIME_MINUTES));
      return(INIT_FAILED);
      }
   return (INIT_SUCCEEDED); // "0"-Успешная инициализация.
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
int start(){
   int CountBars=Bars-IndicatorCounted()-1;  //Print("Start ATR(",a,",",A,") Bars=",Bars," IndicatorCounted=",IndicatorCounted()," CountBars=",CountBars);
   for (int bar=CountBars; bar>0; bar--)    HL[bar]=High[bar]-Low[bar]; 
   for (int bar=CountBars; bar>0; bar--){
      if (bar>Bars-MinBars-1){
         //Print("Not anougth bars for ATR: bar=",bar," Bars=",Bars," MinBars=",MinBars," Time=",TimeToStr(Time[bar],TIME_DATE | TIME_MINUTES)); 
         atr[bar]=0; 
         ATR[bar]=0;
      }else{
         atr[bar]=iMAOnArray(HL,0,a,0,MODE_SMA,bar); // Быстрый
         ATR[bar]=iMAOnArray(HL,0,A,0,MODE_SMA,bar); // Мэдлэнный
      }  }
   return(0);   
   }
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ
// ЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖЖ   
void CHART_SETTINGS(){// НАСТРОЙКИ ВНЕНШЕГО ВИДА ГРАФИКА
   //if (!Real) return;
   // Элементы
   ChartSetInteger(0,CHART_MODE,CHART_BARS);       // способ отображения ценового графика (CHART_BARS, CHART_CANDLES, CHART_LINE)
   ChartSetInteger(0,CHART_SHOW_GRID, false);      // Отображение сетки на графике
   ChartSetInteger(0,CHART_SHOW_PERIOD_SEP, false); // Отображение вертикальных разделителей между соседними периодами
   ChartSetInteger(0,CHART_SHOW_OHLC, false);      // Режим отображения значений OHLC в левом верхнем углу графика
   ChartSetInteger(0,CHART_FOREGROUND, true);      // Ценовой график на переднем плане
   ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,true);// Всплывающие описания графических объектов
   ChartSetInteger(0,CHART_SHOW_VOLUMES,false);    // Отображение объемов не нужно
   ChartSetInteger(0,CHART_SHOW_BID_LINE,true);
   ChartSetInteger(0,CHART_SHOW_ASK_LINE,true);
   // BLACK COLORS
   //ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrBlack);   // Цвет фона графика
   //ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrDimGray); // Цвет осей, шкалы и строки OHLC
   //ChartSetInteger(0,CHART_COLOR_GRID,clrDimGray);       // Цвет сетки
   //ChartSetInteger(0,CHART_COLOR_CHART_UP,clrLime);      // Бар вверх
   //ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrLime);    // Бар вниз
   //ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrLime);    // Линия
   //ChartSetInteger(0,CHART_COLOR_BID,clrDimGray);
   //ChartSetInteger(0,CHART_COLOR_ASK,clrDimGray);
   // WHITE COLORS
   color BARS_COLOR=clrWhite;
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrSilver);   // Цвет фона графика
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrBlack);      // Цвет осей, шкалы и строки OHLC
   ChartSetInteger(0,CHART_COLOR_GRID,clrSilver);           // Цвет сетки
   ChartSetInteger(0,CHART_COLOR_CHART_UP,BARS_COLOR);      // Бар вверх
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,BARS_COLOR);    // Бар вниз
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,BARS_COLOR);    // Линия
   ChartSetInteger(0,CHART_COLOR_BID,clrSilver);
   ChartSetInteger(0,CHART_COLOR_ASK,clrSilver);
   }  
   

