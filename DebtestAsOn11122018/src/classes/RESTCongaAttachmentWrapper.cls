global class RESTCongaAttachmentWrapper{
    public String attachmentId;
    public string fileData;
    public RESTCongaAttachmentWrapper(ContentVersion cv){
        this.attachmentId= cv.Id;
        this.fileData=EncodingUtil.base64Encode(cv.VersionData);
    }
}