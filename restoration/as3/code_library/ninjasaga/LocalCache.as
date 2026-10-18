package ninjasaga
{
   import com.utils.Out;
   import de.polygonal.ds.HashMap;
   
   public final class LocalCache
   {
      
      private static var instance:LocalCache;
      
      private static var petStorage:HashMap = new HashMap();
      
      private var storage:HashMap = new HashMap();
      
      public function LocalCache(param1:SingletonBlocker)
      {
         super();
         if(param1 == null)
         {
            throw new Error("Error: Instantiation failed: Use LocalCache.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : LocalCache
      {
         if(instance == null)
         {
            instance = new LocalCache(new SingletonBlocker());
         }
         return instance;
      }
      
      public static function hasPet(param1:String) : Boolean
      {
         if(petStorage.containsKey(param1))
         {
            return true;
         }
         return false;
      }
      
      public function get(param1:String) : *
      {
         return this.storage.find(param1);
      }
      
      public function set(param1:String, param2:*) : void
      {
         this.storage.insert(param1,param2);
      }
   }
}

class SingletonBlocker
{
   
   public function SingletonBlocker()
   {
      super();
   }
}
