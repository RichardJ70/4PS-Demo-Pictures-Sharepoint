table 50100 "Picture List"
{
    Caption = 'Picture List';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(10; Picture_Media; Media)
        {
            Caption = 'Picture_Media';
            DataClassification = ToBeClassified;
        }
        field(20; Picture_MediaSet; MediaSet)
        {
            Caption = 'Picture_MediaSet';
            DataClassification = ToBeClassified;
        }
        field(30; Picture_BLOB; Blob)
        {
            Caption = 'Picture_BLOB';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(40; Picture_URL; Text[1024])
        {
            Caption = 'Picture_URL';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
