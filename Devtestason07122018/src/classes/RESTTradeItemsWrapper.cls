global class RESTTradeItemsWrapper{
    // properties
    public String workType;
    public List<RESTTradeItemWrapper> trades;
    public RESTTradeItemsWrapper(WorkType workType,List<RESTTradeItemWrapper> tradeItemWrapper){
        this.workType = workType.Name;
        this.trades = tradeItemWrapper;
    }
}