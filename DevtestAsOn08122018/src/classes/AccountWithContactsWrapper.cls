//Wrapper for AccountWithContacts
public class AccountWithContactsWrapper{
    String workType;
    List<TradeListWrapper> tradeList=new List<TradeListWrapper>();
    public AccountWithContactsWrapper(WorkType workType,List<TradeListWrapper> tradeWrapperList){
        this.workType=workType.Name;
        this.tradeList=tradeWrapperList;
    }
    //Wrapper for TradeList
    public class TradeListWrapper{
        String Name;
        public TradeListWrapper(Product2 trade){
            this.Name=trade.Name;
        }
    }
    
}