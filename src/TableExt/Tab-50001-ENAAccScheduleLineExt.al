tableextension 50001 "ENA Acc. Schedule Line" extends "Acc. Schedule Line"
{
    fields
    {
        field(50000; "ENA Enavation Acct. No."; Code[100])
        {
            Caption = 'Enavation Acct. No.';
            DataClassification = CustomerContent;
        }
        field(50001; "ENA Explode Enavation Acct."; Boolean)
        {
            Caption = 'Explode Enavation Acct. No.';
            DataClassification = CustomerContent;
        }

    }
}
