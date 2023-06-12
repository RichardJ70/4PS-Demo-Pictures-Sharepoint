page 50101 "Picture List"
{
    ApplicationArea = All;
    Caption = 'Picture List';
    PageType = List;
    SourceTable = "Picture List";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Picture_URL; Rec.Picture_URL)
                {
                    ExtendedDatatype = URL;
                }
            }
        }
        area(FactBoxes)
        {
            part(Pictures; "Picture Card")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = Code = field(Code);
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Import Picture")
            {
                Caption = 'Import Picture';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Ins: InStream;
                    OutS: OutStream;
                    Filename: Text;
                    Client: HttpClient;
                    Response: HttpResponseMessage;
                    DocumentMgt: Codeunit "Document Management";

                begin
                    if Rec.Picture_URL <> '' then begin
                        Client.Get(Rec.Picture_URL, Response);
                        if Response.IsSuccessStatusCode then begin
                            Clear(rec.Picture_Media);
                            Response.Content.ReadAs(Ins);
                            Rec.Picture_Media.ImportStream(Ins, 'URL Picture' + Rec.Code, MimeTypeTok);
                            Rec.Modify(true);
                        end;
                        exit;
                    end;
                    if Confirm('Upload into Blob field?') then begin
                        if UploadIntoStream('Select file', '', '', Filename, Ins) then begin
                            TempBlob.CreateOutStream(OutS); //Write into the BLOB
                            CopyStream(OutS, Ins); //Copy to Outstream from instream

                            Rec.CalcFields(Picture_BLOB);
                            Rec.Picture_BLOB.CreateOutStream(OutS); //Need to put something into the blob field
                            TempBlob.CreateInStream(Ins); //Get the data out of the tempblob
                            CopyStream(OutS, Ins);
                        end;
                    end else begin
                        if Confirm('Upload into Media field?') then begin
                            if UploadIntoStream('Select file', '', '', Filename, Ins) then begin
                                Clear(Rec.Picture_Media);
                                Rec.Picture_Media.ImportStream(Ins, 'Demo picture' + Format(Rec.Code), MimeTypeTok);
                                Rec.Modify(true);
                            end;
                        end else begin
                            if Confirm('Upload into MediaSet field?') then begin
                                if UploadIntoStream('Select file', '', '', Filename, Ins) then begin
                                    Rec.Picture_MediaSet.ImportStream(Ins, 'Demo picture' + Format(Rec.Code), MimeTypeTok);
                                    Rec.Modify(true);
                                end;
                            end;
                        end;
                    end;
                end;
            }
            action(PrintReport)
            {
                RunObject = Report PrintPicture;
                Image = Print;

            }
        }
    }
    var
        TempBlob: Codeunit "Temp Blob";
        MimeTypeTok: Label 'image/jpeg', locked = true;
}
