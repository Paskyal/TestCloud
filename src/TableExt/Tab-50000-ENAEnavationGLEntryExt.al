tableextension 50000 "ENA Enavation G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(50000; "ENA Enavation G/L Code"; Code[100])
        {
            Caption = 'ENA Enavation G/L Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    keys
    {
        key(GLSegment; "ENA Enavation G/L Code")
        {
        }
    }

    trigger OnBeforeInsert()
    begin
        UpdateEnavationIfChanged(xRec, Rec);
    end;

    trigger OnBeforeModify()
    begin
        UpdateEnavationIfChanged(xRec, Rec);
    end;

    local procedure UpdateEnavationIfChanged(var xGLEntry: Record "G/L Entry"; var GLEntry: Record "G/L Entry")
    var
        EnavationGLSetup: Record "ENA Enavation G/L Setup";
        EnavationGLMgmt: Codeunit "ENA Enavation G/L Management";
    begin
        if not (EnavationGLSetup.Get() and EnavationGLSetup."Enable G/L Segments" and EnavationGLSetup."Update Segment During Posting") then exit;

        GLEntry."ENA Enavation G/L Code" := EnavationGLMgmt.GenerateGLSegmentCodeForEntry(GLEntry)
    end;
}
