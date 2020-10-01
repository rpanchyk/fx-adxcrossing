//+------------------------------------------------------------------+
//|                                              AdxCrossingINGM.mq4 |
//|                                         Copyright 2020, GoNaMore |
//|       Based on 'ADX Crossing.mq4' from Amir - http://forexbig.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, GoNaMore"
#property link "https://github.com/gonamore/fx-adxcrossing-ind"
#property description "Indicator shows possible entry points by ADX"
#property version "1.0"
#property strict

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrLime
#property indicator_color2 clrRed

// input parameters
extern int adxBars = 14;
extern int period = 350;

// buffers
double buff1[];
double buff2[];

// runtime
double b4plusdi;
double nowplusdi;
double b4minusdi;
double nowminusdi;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(2);

   SetIndexBuffer(0, buff1);
   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 108);

   SetIndexBuffer(1, buff2);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1, 108);

   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int availableBars = period >= Bars ? Bars : period;

   SetIndexDrawBegin(0, Bars - availableBars);
   SetIndexDrawBegin(1, Bars - availableBars);

   int countedBars = IndicatorCounted();

   if(countedBars < 0) // check for possible errors
     {
      Print("Error: No counted bars");
      return -1;
     }

   if(countedBars < 1) // initial zero
     {
      for(int i = 1; i <= availableBars; i++)
        {
         buff1[availableBars - i] = 0;
         buff2[availableBars - i] = 0;
        }
     }

   for(int i = availableBars; i >= 0; i--)
     {
      b4plusdi = iADX(NULL, 0, adxBars, PRICE_CLOSE, MODE_PLUSDI, i - 1);
      nowplusdi = iADX(NULL, 0, adxBars, PRICE_CLOSE, MODE_PLUSDI, i);
      b4minusdi = iADX(NULL, 0, adxBars, PRICE_CLOSE, MODE_MINUSDI, i - 1);
      nowminusdi = iADX(NULL, 0, adxBars, PRICE_CLOSE, MODE_MINUSDI, i);

      if(b4plusdi > b4minusdi && nowplusdi < nowminusdi)
        {
         buff1[i] = Low[i] - 5 * Point;
        }

      if(b4plusdi < b4minusdi && nowplusdi > nowminusdi)
        {
         buff2[i] = High[i] + 5 * Point;
        }
     }
   return rates_total;
  }
//+------------------------------------------------------------------+
