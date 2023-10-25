tableextension 50002 "ENA Acc. Schedule Name" extends "Acc. Schedule Name"
{
    fields
    {
        field(50000; "ENA Enavation Acc. Sch. Name"; Code[10])
        {
            Caption = 'Enavation Acc. Sch. Name';
            DataClassification = CustomerContent;
            TableRelation = "Acc. Schedule Name";
            trigger OnValidate()
            begin
                if rec.Name = "ENA Enavation Acc. Sch. Name" then
                    Error('You cannot use the same Acccount Scheduler for the Enavatation Account Schedule.');
            end;
        }
    }
}
