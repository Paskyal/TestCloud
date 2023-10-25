table 50000 "ENA Enavation G/L Setup"
{
    Caption = 'Enavation G/L Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Segment 1"; Enum "ENA Enavation G/L Segment")
        {
            Caption = 'Segment 1';
            DataClassification = CustomerContent;
        }
        field(3; "Segment 2"; Enum "ENA Enavation G/L Segment")
        {
            Caption = 'Segment 2';
            DataClassification = CustomerContent;
        }
        field(4; "Segment 3"; Enum "ENA Enavation G/L Segment")
        {
            Caption = 'Segment 3';
            DataClassification = CustomerContent;
        }
        field(5; "Segment 4"; Enum "ENA Enavation G/L Segment")
        {
            Caption = 'Segment 4';
            DataClassification = CustomerContent;
        }
        field(6; "Segment 5"; Enum "ENA Enavation G/L Segment")
        {
            Caption = 'Segment 5';
            DataClassification = CustomerContent;
        }
        field(9; "Segment Separator"; Code[1])
        {
            Caption = 'Segment Separator';
            DataClassification = CustomerContent;
            InitValue = '-';
            NotBlank = true;
        }
        field(10; "Enable G/L Segments"; Boolean)
        {
            Caption = 'Enable G/L Segments';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Enable G/L Segments" then
                    TestField("Segment 1");
            end;
        }
        field(20; "Update Segment During Posting"; Boolean)
        {
            DataClassification = CustomerContent;
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
