package ninjasaga.data
{
   public final class NpcDataLang
   {
      
      public var textArr:Array = [];
      
      public function NpcDataLang()
      {
         super();
      }
      
      public function NpcDataLang_Process(param1:Object) : *
      {
         switch(AppData.lang)
         {
            case AppData.PT:
               param1[1].name = "Ryuma";
               param1[2].name = "Gekko";
               param1[3].name = "Shuji";
               param1[4].name = "Kazuya";
               param1[5].name = "Masaki";
               param1[6].name = "Keisuke";
               param1[7].name = "Mabuki";
               param1[8].name = "Hiroshi";
               break;
            case AppData.ZH:
               param1[1].name = "月光";
               param1[2].name = "龍馬";
               param1[3].name = "修司";
               param1[4].name = "和哉";
               param1[5].name = "正樹";
               param1[6].name = "惠介";
               param1[7].name = "麻吹";
               param1[8].name = "弘";
               break;
            case AppData.CN:
               param1[1].name = "月光";
               param1[2].name = "龙马";
               param1[3].name = "修司";
               param1[4].name = "和哉";
               param1[5].name = "正树";
               param1[6].name = "惠介";
               param1[7].name = "麻吹";
               param1[8].name = "弘";
               break;
            case AppData.DE:
               param1[1].name = "Ryuma";
               param1[2].name = "Gekko";
               param1[3].name = "Shuji";
               param1[4].name = "Kazuya";
               param1[5].name = "Masaki";
               param1[6].name = "Keisuke";
               param1[7].name = "Mabuki";
               param1[8].name = "Hiroshi";
               break;
            case AppData.ES:
               param1[1].name = "Ryuma";
               param1[2].name = "Gekko";
               param1[3].name = "Shuji";
               param1[4].name = "Kazuya";
               param1[5].name = "Masaki";
               param1[6].name = "Keisuke";
               param1[7].name = "Mabuki";
               param1[8].name = "Hiroshi";
               break;
            default:
               param1[1].name = "Ryuma";
               param1[2].name = "Gekko";
               param1[3].name = "Shuji";
               param1[4].name = "Kazuya";
               param1[5].name = "Masaki";
               param1[6].name = "Keisuke";
               param1[7].name = "Mabuki";
               param1[8].name = "Hiroshi";
         }
      }
   }
}

