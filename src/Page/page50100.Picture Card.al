page 50100 "Picture Card"
{
    ApplicationArea = All;
    Caption = 'Pictures';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Picture List";

    layout
    {
        area(content)
        {
            field(Picture_BLOB; Rec.Picture_BLOB)
            {
                ApplicationArea = All;
                ToolTip = 'This is a BLOB data type';
                ShowCaption = false;
            }
            field(Picture_Media; Rec.Picture_Media)
            {
                ApplicationArea = All;
                ToolTip = 'This is a Media data type';
                ShowCaption = false;
            }
            field(Picture_MediaSet; Rec.Picture_MediaSet)
            {
                ApplicationArea = All;
                ToolTip = 'This is a MediaSet data type';
                ShowCaption = false;
            }

        }
    }
    actions
    {
        area(Processing)
        {
            action("Take Selfie")
            {
                Caption = 'Take Selfie';
                ApplicationArea = All;
                Image = Camera;
                Enabled = true;

                trigger OnAction()
                var
                    Ins: InStream;
                    Camera: Codeunit Camera;
                    PictureDesc: Text;
                begin
                    if Camera.GetPicture(Ins, PictureDesc) then begin
                        Clear(Rec.Picture_Media);
                        Rec.Picture_Media.ImportStream(Ins, PictureDesc, MimeTypeTok);
                        Rec.Modify(true);
                    end;
                end;
            }
        }
    }

    var
        MimeTypeTok: Label 'image/jpeg', locked = true;
}
