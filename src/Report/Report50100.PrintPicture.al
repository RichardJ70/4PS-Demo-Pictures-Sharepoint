report 50100 PrintPicture
{
    ApplicationArea = All;
    Caption = 'Print Picture';
    UsageCategory = Tasks;
    DefaultLayout = RDLC;
    RDLCLayout = 'src/Report/rdlc/Report50100.PrintPicture.rdlc';

    dataset
    {
        dataitem("Picture List"; "Picture List")
        {
            column(Code; Code)
            {

            }
            column(Description; Description)
            {

            }
            column(Picture_BLOB; Picture_BLOB)
            {

            }
            column(Picture_Media; TenantMedia.Content)
            {

            }
            column(Picture_URL; Picture_URL)
            {

            }

            trigger OnAfterGetRecord()
            var
                Client: HttpClient;
                Content: HttpContent;
                TempBlob: Codeunit "Temp Blob";
                FileMgt: Codeunit "File Management";
                DocumentServiceManagement: Codeunit "Document Service Management";
                StorageType: enum "File Storage Type 4PS";
                Response: HttpResponseMessage;
                Instr: InStream;
                Ostr: OutStream;

            begin
                //Client.Get(Uri, Response);
                //if Response.IsSuccessStatusCode then begin
                //  Response.Content.ReadAs(Instr);

                if "Picture List".Picture_URL <> '' then begin
                    DocumentServiceManagement.SetUseDocumentService4PS(true);
                    DocumentServiceManagement.DownloadFileFromCloudToStream("Picture List".Picture_URL, Instr);

                    //MediaType datatype or MediaSet datatype
                    "Picture List".Picture_Media.ImportStream(Instr, 'Demo Media Picture' + "Picture List".Code);
                    "Picture List".Modify();

                    if "Picture List".Picture_Media.HasValue then begin
                        TenantMedia.Get("Picture List".Picture_Media.MediaId);
                        TenantMedia.CalcFields(Content);
                    end;
                    //Blob datatype
                    "Picture List".Picture_BLOB.CreateOutStream(OStr); //Create outstream for field to put something in the stream
                    CopyStream(Ostr, Instr);  //Put the data from the instream to the outstream
                    "Picture List".Modify();

                end;
                "Picture List".CalcFields(Picture_BLOB);
            end;
        }
    }

    var
        Uri: Text;
        TenantMedia: Record "Tenant Media";
}
