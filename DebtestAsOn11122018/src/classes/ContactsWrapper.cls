//Wrapper for Contacts
public class ContactsWrapper{
    String Name;
    String Email;
    String Phone;
    String MobilePhone;
    public ContactsWrapper(Contact con){
        this.Name=con.Name;
        this.Email=con.Email;
        this.Phone=con.Phone;
        this.MobilePhone=con.MobilePhone;
    }
}