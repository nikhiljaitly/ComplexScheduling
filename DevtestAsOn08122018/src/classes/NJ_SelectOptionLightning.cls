/**
* Custom select option lightning class
* @author : Nikhil Jaitly
* @Created Date : 24/10/2018
* */
public class NJ_SelectOptionLightning {
    public NJ_SelectOptionLightning(String label) {
        this.label = label;
    }
    public NJ_SelectOptionLightning(String value, String label) {
        this.value = value;
        this.label = label;
        this.disabled = false;
        this.escapeItem = false;
    }
    public NJ_SelectOptionLightning(String value, String label, String color) {
        this.value = value;
        this.label = label;
        this.disabled = false;
        this.escapeItem = false;
        this.colorCode = color;
        this.total = 0;
    }
    public NJ_SelectOptionLightning(String value, String label, String color, String iconName) {
        this.value = value;
        this.label = label;
        this.disabled = false;
        this.escapeItem = false;
        this.colorCode = color;
        this.iconName = iconName;
        this.total = 0;
    }
    public NJ_SelectOptionLightning(String value, String label, Boolean isDisabled) {
        this.value = value;
        this.label = label;
        this.disabled = isDisabled;
        this.escapeItem = false;
    }
    public NJ_SelectOptionLightning(String value, String label, Boolean isDisabled, Boolean isSelected) {
        this.value = value;
        this.label = label;
        this.disabled = isDisabled;
        this.escapeItem = false;
        this.selected = isSelected;
    }
    @AuraEnabled
    public String label { get; set; }
    @AuraEnabled
    public String value { get;set; }
    @AuraEnabled
    public Boolean disabled { get;set; }
    @AuraEnabled
    public Boolean escapeItem { get;set; }
    @AuraEnabled
    public Integer total { get; set; }

    @AuraEnabled
    public Boolean selected { get; set; }
    @AuraEnabled
    public String colorCode { get; set; }
    @AuraEnabled
    public String iconName { get; set; }
}