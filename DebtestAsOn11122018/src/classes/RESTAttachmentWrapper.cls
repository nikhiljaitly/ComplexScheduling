global class RESTAttachmentWrapper{
    public String attachmentId;
    public String contentDocumentId;
    public String name;
    public String description;
    public string fileData;
    public string parentId;
    public string fileType;
    public boolean isDeleted;
    public RESTAttachmentWrapper(ContentDocumentLink att,boolean isDeleted){
        this.attachmentId= att.Id;
        this.name=att.ContentDocument.LatestPublishedVersion.Title;
        this.description=att.ContentDocument.LatestPublishedVersion.Description;
        this.fileData=EncodingUtil.base64Encode(att.ContentDocument.LatestPublishedVersion.VersionData);
        this.parentId=att.linkedEntityID;
        this.fileType=att.ContentDocument.FileExtension;
        this.contentDocumentId=att.ContentDocumentId;
        this.isDeleted=isDeleted;
    }   
}