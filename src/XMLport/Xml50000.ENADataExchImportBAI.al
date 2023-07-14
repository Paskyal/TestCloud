xmlport 50000 "ENA Data Exch. Import - BAI"
{
    Caption = 'Data Exch. Import - BAI';
    Direction = Import;
    Format = VariableText;
    TextEncoding = WINDOWS;
    UseRequestPage = false;
    schema
    {
        textelement(RootNodeName)
        {
            textelement(root)
            {
                MinOccurs = Zero;
                tableelement("Data Exch."; "Data Exch.")
                {
                    AutoSave = false;
                    XmlName = 'DataExchDocument';
                    textelement(col1)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        XmlName = 'col1';

                        trigger OnAfterAssignVariable()
                        begin
                            ColumnNo := 1;
                            CheckLineType();
                            InsertColumn(ColumnNo, col1);
                        end;
                    }
                    textelement(colx)
                    {
                        MinOccurs = Zero;
                        Unbound = true;
                        XmlName = 'colx';

                        trigger OnAfterAssignVariable()
                        begin
                            ColumnNo += 1;
                            InsertColumn(ColumnNo, colx);
                        end;
                    }

                    trigger OnAfterInitRecord()
                    begin
                        FileLineNo += 1;
                    end;

                    trigger OnBeforeInsertRecord()
                    begin
                        ValidateHeaderTag();
                    end;
                }
            }
        }
    }
    trigger OnPostXmlPort()
    begin
        if (not LastLineIsFooter and SkipLine) or HeaderWarning then
            Error(LastLineIsHeaderErr);
    end;

    trigger OnPreXmlPort()
    begin
        InitializeGlobals();
    end;

    local procedure InitializeGlobals()
    var
        DataExchDef: Record "Data Exch. Def";
        TypeHelper: Codeunit "Type Helper";
        CRLF: Text[2];
    begin
        DataExchEntryNo := "Data Exch.".GetRangeMin("Entry No.");
        "Data Exch.".Get(DataExchEntryNo);
        DataExchLineDefCode := "Data Exch."."Data Exch. Line Def Code";
        DataExchDef.Get("Data Exch."."Data Exch. Def Code");
        HeaderLines := DataExchDef."Header Lines";
        ImportedLineNo := 0;
        FileLineNo := 0;
        HeaderTag := DataExchDef."Header Tag";
        FooterTag := DataExchDef."Footer Tag";
        HeaderLineCount := 0;
        CurrentLineType := LineType::Unknown;
        FullHeaderLine := '';
        currXMLport.FieldSeparator(DataExchDef.ColumnSeparatorChar());
        case DataExchDef."File Encoding" of
            DataExchDef."File Encoding"::"MS-DOS":
                currXMLport.TextEncoding(TEXTENCODING::MSDos);
            DataExchDef."File Encoding"::"UTF-8":
                currXMLport.TextEncoding(TEXTENCODING::UTF8);
            DataExchDef."File Encoding"::"UTF-16":
                currXMLport.TextEncoding(TEXTENCODING::UTF16);
            DataExchDef."File Encoding"::WINDOWS:
                currXMLport.TextEncoding(TEXTENCODING::Windows);
        end;

        CRLF := TypeHelper.CRLFSeparator();
        case DataExchDef."Line Separator" of
            DataExchDef."Line Separator"::CR:
                currXMLport.RecordSeparator := CRLF[1];
            DataExchDef."Line Separator"::LF:
                currXMLport.RecordSeparator := CRLF[2];
        end;
    end;

    local procedure CheckLineType()
    begin
        IdentifyLineType();
        SkipLine := CurrentLineType <> LineType::Data;

        if not SkipLine then
            ImportedLineNo += 1;
    end;

    local procedure IdentifyLineType()
    begin
        case true of
            col1 = '02':
                CurrentLineType := LineType::HeaderDate;
            col1 = '03':
                CurrentLineType := LineType::HeaderAccount;
            col1 = '16':
                CurrentLineType := LineType::Data;
            else
                CurrentLineType := LineType::Unknown;
        end;
    end;

    local procedure InsertColumn(columnNumber: Integer; var columnValue: Text)
    var
        savedColumnValue: Text;
    // DecimalText: Text;
    // IntegerText: Text;
    // FundsType: Text[1];
    // Int: Integer;
    // factor: Integer;
    // savedColumnValueInt: Integer;
    // Dec: Decimal;
    begin
        savedColumnValue := columnValue;
        columnValue := '';
        if SkipLine then begin
            if (CurrentLineType = LineType::HeaderDate) and (columnNumber = 5) then // Transaction Date
                TransactionDate := savedColumnValue;
            if (CurrentLineType = LineType::HeaderAccount) and (columnNumber = 2) then // Bank Account No.
                if savedColumnValue <> BankAccount."Bank Account No." then
                    Error(BankAccountIncorrectErr, savedColumnValue, BankAccount."Bank Account No.", FileLineNo, columnNumber)
                else
                    AccountNo := CopyStr(savedColumnValue, 1, MaxStrLen(AccountNo));
            exit;
        end;
        case true of

            columnNumber = 1: // inserts the transaction date YYMMDD
                InsertDataExchField(100, TransactionDate); // Column 100 must be defined in Data Exchange Definition
            columnNumber = 2:
                begin  // transaction code
                    Message('Test'); //todelete
                    // TransactionCode := savedColumnValue;
                    // Evaluate(TrasactionCodeInt, TransactionCode);
                    InsertDataExchField(columnNumber, savedColumnValue);
                end;

        end;
    end;

    local procedure InsertDataExchField(columnNumber: Integer; savedColumnValue: Text);
    begin
        if savedColumnValue <> '' then begin
            DataExchField.Init();
            DataExchField.Validate("Data Exch. No.", DataExchEntryNo);
            DataExchField.Validate("Line No.", ImportedLineNo);
            DataExchField.Validate("Column No.", columnNumber);
            DataExchField.Validate(Value, CopyStr(savedColumnValue, 1, MaxStrLen(DataExchField.Value)));
            DataExchField.Validate("Data Exch. Line Def Code", DataExchLineDefCode);
            DataExchField.Insert(true);
        end;
    end;

    local procedure ValidateHeaderTag()
    begin
        if SkipLine and (CurrentLineType = LineType::Header) and (HeaderTag <> '') then
            if StrPos(FullHeaderLine, HeaderTag) = 0 then
                Error(WrongHeaderErr);
    end;

    var
        BankAccount: Record "Bank Account";
        DataExchField: Record "Data Exch. Field";
        AccountNo: Text[30];
        DataExchEntryNo: Integer;
        ImportedLineNo: Integer;
        FileLineNo: Integer;
        HeaderLines: Integer;
        HeaderLineCount: Integer;
        ColumnNo: Integer;
        HeaderTag: Text;
        FooterTag: Text;
        SkipLine: Boolean;
        LastLineIsFooter: Boolean;
        HeaderWarning: Boolean;
        LineType: Option Unknown,Header,HeaderDate,HeaderAccount,Footer,FooterAccount,FooterDate,Data;
        CurrentLineType: Option;
        FullHeaderLine: Text;
        TransactionDate: Text; // TODO PAP have doubts, shold it be date or text
        LastLineIsHeaderErr: Label 'The imported file contains unexpected formatting. One or more lines may be missing in the file.';
        WrongHeaderErr: Label 'The imported file contains unexpected formatting. One or more headers are incorrect.';
        BankAccountIncorrectErr: label 'Bank Account is incorrect %1,%2,%3,%4', Comment = '%1,%2,%3,%4';
        DataExchLineDefCode: Code[20];
}