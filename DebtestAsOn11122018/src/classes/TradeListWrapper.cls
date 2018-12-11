//Wrapper for Trade List
public class TradeListWrapper{
    String workType;
    List<TradeWrapper> tradeListWrapper =new List<TradeWrapper>();
    public TradeListWrapper(WorkType workType,List<TradeWrapper> tradeListWrapper){
        this.workType = workType.Name;
        this.tradeListWrapper = tradeListWrapper;
    }
    //Wrapper for Trade
    public class TradeWrapper{
        String Name;
        public TradeWrapper(Product2 trade){
            this.Name=trade.Name;
            
        }
    }   
}