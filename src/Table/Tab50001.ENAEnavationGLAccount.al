table 50001 "ENA Enavation G/L Account"
{
    Caption = 'Enavation G/L Account';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Enavation G/L Account No."; Code[100])
        {
            Caption = 'Enavation G/L Account No.';
            DataClassification = CustomerContent;
        }
        field(2; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
        }
        field(3; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(4; "Account Type"; Enum "G/L Account Type")
        {
            Caption = 'Account Type';
        }
        field(5; Totaling; Text[250])
        {
            Caption = 'Totaling';
        }
        field(10; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
        }
        field(11; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
        }
        field(12; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = CustomerContent;
        }
        field(13; "Shortcut Dimension 4 Code"; Code[20])
        {

            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = CustomerContent;
        }
        field(14; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = CustomerContent;
        }
        field(15; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            DataClassification = CustomerContent;
        }
        field(16; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            DataClassification = CustomerContent;
        }
        field(17; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            DataClassification = CustomerContent;
        }
        field(29; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
        }
        field(30; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
        }
        field(42; "Business Unit Filter"; Code[20])
        {
            Caption = 'Business Unit Filter';
            FieldClass = FlowFilter;
        }

        field(100; "Balance at Date"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("ENA Enavation G/L Code" = FIELD("Enavation G/L Account No."),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                        "Dimension Set ID" = FIELD("Dimension Set ID Filter")));
            Caption = 'Balance at Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Net Change"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("ENA Enavation G/L Code" = FIELD("Enavation G/L Account No."),
                                                        "G/L Account No." = FIELD(FILTER(Totaling)),
                                                        "Business Unit Code" = FIELD("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Dimension Set ID" = FIELD("Dimension Set ID Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(400; "Dimension Set ID Filter"; Integer)
        {
            Caption = 'Dimension Set ID Filter';
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(PK; "Enavation G/L Account No.")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// Sets filters for active segments.
    /// </summary>
    /// <param name="FilterText">Segment filters in configured segment order.</param>
    procedure SetSegmentFilters(FilterText: Array[5] of Text)
    var
        EnavationGLSetup: Record "ENA Enavation G/L Setup";
    begin
        if EnavationGLSetup.FindFirst() then begin
            if ((EnavationGLSetup."Segment 1" <> Enum::"ENA Enavation G/L Segment"::" ") and (FilterText[1] <> '')) then
                SetSegmentFilter(EnavationGLSetup."Segment 1", FilterText[1]);
            if ((EnavationGLSetup."Segment 2" <> Enum::"ENA Enavation G/L Segment"::" ") and (FilterText[2] <> '')) then
                SetSegmentFilter(EnavationGLSetup."Segment 2", FilterText[2]);
            if ((EnavationGLSetup."Segment 3" <> Enum::"ENA Enavation G/L Segment"::" ") and (FilterText[3] <> '')) then
                SetSegmentFilter(EnavationGLSetup."Segment 3", FilterText[3]);
            if ((EnavationGLSetup."Segment 4" <> Enum::"ENA Enavation G/L Segment"::" ") and (FilterText[4] <> '')) then
                SetSegmentFilter(EnavationGLSetup."Segment 4", FilterText[4]);
            if ((EnavationGLSetup."Segment 5" <> Enum::"ENA Enavation G/L Segment"::" ") and (FilterText[5] <> '')) then
                SetSegmentFilter(EnavationGLSetup."Segment 5", FilterText[5]);
        end;
    end;

    /// <summary>
    /// Sets a filter on the specified segment.
    /// </summary>
    /// <param name="Segment">The segment to apply the filter to.</param>
    /// <param name="FilterText">The filter text.</param>
    procedure SetSegmentFilter(Segment: Enum "ENA Enavation G/L Segment"; FilterText: Text)
    var
        PreviousFilterGroup: Integer;
    begin
        PreviousFilterGroup := Rec.FilterGroup;
        Rec.FilterGroup := 100;

        case Segment of
            Segment::"G/L Account No.":
                SetFilter("G/L Account No.", "FilterText");
            Segment::"Global Dimension 1":
                SetFilter("Global Dimension 1 Code", FilterText);
            Segment::"Global Dimension 2":
                SetFilter("Global Dimension 2 Code", FilterText);
            Segment::"Shortcut Dimension 3":
                SetFilter("Shortcut Dimension 3 Code", FilterText);
            Segment::"Shortcut Dimension 4":
                SetFilter("Shortcut Dimension 4 Code", FilterText);
            Segment::"Shortcut Dimension 5":
                SetFilter("Shortcut Dimension 5 Code", FilterText);
            Segment::"Shortcut Dimension 6":
                SetFilter("Shortcut Dimension 6 Code", FilterText);
            Segment::"Shortcut Dimension 7":
                SetFilter("Shortcut Dimension 7 Code", FilterText);
            Segment::"Shortcut Dimension 8":
                SetFilter("Shortcut Dimension 8 Code", FilterText);
        end;

        Rec.FilterGroup := PreviousFilterGroup;
    end;
}
