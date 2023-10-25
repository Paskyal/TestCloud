report 50000 "ENA Detail Trial Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ENDetailTrialBalance.rdl';
    AdditionalSearchTerms = 'payment due,order status';
    ApplicationArea = Basic, Suite;
    Caption = 'Detail Trial Balance';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = WHERE("Account Type" = CONST(Posting));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Income/Balance", "Debit/Credit", "Date Filter";

            column(No_GLAcc; "No.")
            {
            }

            column(Name_GLAcc; "G/L Account".Name)
            {
            }

            column(PeriodGLDtFilter; StrSubstNo(Text000, GLDateFilter))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName)
            {
            }
            column(ExcludeBalanceOnly; ExcludeBalanceOnly)
            {
            }
            column(PrintReversedEntries; PrintReversedEntries)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(PrintClosingEntries; PrintClosingEntries)
            {
            }
            column(PrintOnlyCorrections; PrintOnlyCorrections)
            {
            }
            column(GLAccTableCaption; TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(EmptyString; '')
            {
            }
            column(DetailTrialBalCaption; DetailTrialBalCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(PeriodCaption; PeriodCaptionLbl)
            {
            }
            column(OnlyCorrectionsCaption; OnlyCorrectionsCaptionLbl)
            {
            }
            column(NetChangeCaption; NetChangeCaptionLbl)
            {
            }
            column(GLEntryDebitAmtCaption; GLEntryDebitAmtCaptionLbl)
            {
            }
            column(GLEntryCreditAmtCaption; GLEntryCreditAmtCaptionLbl)
            {
            }
            column(GLBalCaption; GLBalCaptionLbl)
            {
            }
            column(EnavationAccountNoCaptionLbl; EnavationAccountNoCaptionLbl)
            {
            }

            dataItem("Enavation G/L Account"; "ENA Enavation G/L Account")
            {
                DataItemLink = "G/L Account No." = FIELD("No.");
                DataItemTableView = SORTING("Enavation G/L Account No.");

                column(EnavationAccountNo; "Enavation G/L Account"."Enavation G/L Account No.")
                {
                }

                column(StartBalance; StartBalance)
                {
                    AutoFormatType = 1;
                }
                column(TotalBeginBalance; TotalBeginBalance)
                {

                }
                column(GrandTotalEnding; GrandTotalEnding)
                {

                }

                dataitem("G/L Entry"; "G/L Entry")
                {
                    DataItemLink =
                        "Posting Date" = FIELD("Date Filter"),
                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                        "Business Unit Code" = FIELD("Business Unit Filter");
                    DataItemLinkReference = "Enavation G/L Account";

                    column(VATAmount_GLEntry; "VAT Amount")
                    {
                        IncludeCaption = true;
                    }
                    column(DebitAmount_GLEntry; "Debit Amount")
                    {
                    }
                    column(CreditAmount_GLEntry; "Credit Amount")
                    {
                    }
                    column(PostingDate_GLEntry; Format("Posting Date"))
                    {
                    }
                    column(DocumentNo_GLEntry; "Document No.")
                    {
                    }
                    column(ExtDocNo_GLEntry; "External Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_GLEntry; Description)
                    {
                    }
                    column(GLBalance; GLBalance)
                    {
                        AutoFormatType = 1;
                    }
                    column(EntryNo_GLEntry; "Entry No.")
                    {
                    }
                    column(ClosingEntry; ClosingEntry)
                    {
                    }
                    column(Reversed_GLEntry; Reversed)
                    {
                    }
                    column(SourceNo_GLEntry; "Source No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if PrintOnlyCorrections then
                            if not (("Debit Amount" < 0) or ("Credit Amount" < 0)) then
                                CurrReport.Skip();
                        if not PrintReversedEntries and Reversed then
                            CurrReport.Skip();

                        GLBalance := GLBalance + Amount;
                        if ("Posting Date" = ClosingDate("Posting Date")) and
                        not PrintClosingEntries
                        then begin
                            "Debit Amount" := 0;
                            "Credit Amount" := 0;
                        end;

                        if "Posting Date" = ClosingDate("Posting Date") then
                            ClosingEntry := true
                        else
                            ClosingEntry := false;
                        GrandTotalEnding := GrandTotalEnding + Amount;
                    end;

                    trigger OnPreDataItem()
                    begin

                        GLBalance := StartBalance;
                        SetRange("G/L Entry"."ENA Enavation G/L Code", "Enavation G/L Account"."Enavation G/L Account No.");

                        OnAfterOnPreDataItemGLEntry("G/L Entry");
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    GLEntry: Record "G/L Entry";
                    Date: Record Date;
                begin
                    StartBalance := 0;
                    if GLDateFilter <> '' then begin
                        Date.SetRange("Period Type", Date."Period Type"::Date);
                        Date.SetFilter("Period Start", GLDateFilter);
                        if Date.FindFirst then begin
                            SetRange("Date Filter", 0D, ClosingDate(Date."Period Start" - 1));
                            CalcFields("Net Change");
                            StartBalance := "Net Change";
                            SetFilter("Date Filter", GLDateFilter);
                        end;
                    end;

                    if PrintOnlyOnePerPage then begin
                        GLEntry.Reset();
                        GLEntry.SetRange("G/L Account No.", "G/L Account"."No.");
                    end;
                    TotalBeginBalance := TotalBeginBalance + StartBalance;
                    GrandTotalEnding := GrandTotalEnding + StartBalance;
                end;

                trigger OnPreDataItem()
                begin
                    PageGroupNo := 1;

                    // Apply filters from request page
                    if "G/L Entry".GetFilter("Shortcut Dimension 4 Code") <> '' then
                        "Enavation G/L Account".Setfilter("Enavation G/L Account"."Enavation G/L Account No.", '%1', "G/L Entry".GetFilter("Shortcut Dimension 4 Code"));
                    "Enavation G/L Account".SetSegmentFilters(SegmentFilters);
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NewPageperGLAcc; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per G/L Acc.';
                        ToolTip = 'Specifies if each G/L account information is printed on a new page if you have chosen two or more G/L accounts to be included in the report.';
                    }
                    field(ExcludeGLAccsHaveBalanceOnly; ExcludeBalanceOnly)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exclude G/L Accs. That Have a Balance Only';
                        MultiLine = true;
                        ToolTip = 'Specifies if you do not want the report to include entries for G/L accounts that have a balance but do not have a net change during the selected time period.';
                    }
                    field(InclClosingEntriesWithinPeriod; PrintClosingEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Closing Entries Within the Period';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want the report to include closing entries. This is useful if the report covers an entire fiscal year. Closing entries are listed on a fictitious date between the last day of one fiscal year and the first day of the next one. They have a C before the date, such as C123194. If you do not select this field, no closing entries are shown.';
                    }
                    field(IncludeReversedEntries; PrintReversedEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Reversed Entries';
                        ToolTip = 'Specifies if you want to include reversed entries in the report.';
                    }
                    field(PrintCorrectionsOnly; PrintOnlyCorrections)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Corrections Only';
                        ToolTip = 'Specifies if you want the report to show only the entries that have been reversed and their matching correcting entries.';
                    }
                }
                Group(SegmentName)
                {
                    Caption = 'Enavation Account No.';

                    field("Segment 1 Filter"; SegmentFilters[1])
                    {
                        ToolTip = 'Specifies a filter for Segment 1';
                        ApplicationArea = All;
                        Visible = Segment1Visible;
                        CaptionClass = 'EnavationSegment,1';
                        trigger OnAssistEdit()
                        begin
                            if not getsegmentfilter(1, SegmentFilters[1]) then;
                        end;
                    }
                    field("Segment 2 Filter"; SegmentFilters[2])
                    {
                        ToolTip = 'Specifies a filter for Segment 2';
                        ApplicationArea = All;
                        Visible = Segment2Visible;
                        CaptionClass = 'EnavationSegment,2';
                        trigger OnAssistEdit()
                        begin
                            if not getsegmentfilter(2, SegmentFilters[2]) then;
                        end;
                    }
                    field("Segment 3 Filter"; SegmentFilters[3])
                    {
                        ToolTip = 'Specifies a filter for Segment 3';
                        ApplicationArea = All;
                        Visible = Segment3Visible;
                        CaptionClass = 'EnavationSegment,3';
                        trigger OnAssistEdit()
                        begin
                            if not getsegmentfilter(3, SegmentFilters[3]) then;
                        end;
                    }
                    field("Segment 4 Filter"; SegmentFilters[4])
                    {
                        ToolTip = 'Specifies a filter for Segment 4';
                        ApplicationArea = All;
                        Visible = Segment4Visible;
                        CaptionClass = 'EnavationSegment,4';
                        trigger OnAssistEdit()
                        begin
                            if not getsegmentfilter(4, SegmentFilters[4]) then;
                        end;
                    }
                    field("Segment 5 Filter"; SegmentFilters[5])
                    {
                        ToolTip = 'Specifies a filter for Segment 5';
                        ApplicationArea = All;
                        Visible = Segment5Visible;
                        CaptionClass = 'EnavationSegment,5';
                        trigger OnAssistEdit()
                        begin
                            if not getsegmentfilter(5, SegmentFilters[5]) then;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        var
            EnavationGLSetup: Record "ENA Enavation G/L Setup";
        begin
            if (EnavationGLSetup.FindFirst()) then begin
                Segment1Visible := EnavationGLSetup."Segment 1" <> Enum::"ENA Enavation G/L Segment"::" ";
                Segment2Visible := EnavationGLSetup."Segment 2" <> Enum::"ENA Enavation G/L Segment"::" ";
                Segment3Visible := EnavationGLSetup."Segment 3" <> Enum::"ENA Enavation G/L Segment"::" ";
                Segment4Visible := EnavationGLSetup."Segment 4" <> Enum::"ENA Enavation G/L Segment"::" ";
                Segment5Visible := EnavationGLSetup."Segment 5" <> Enum::"ENA Enavation G/L Segment"::" ";
            end;
        end;
    }

    labels
    {
        PostingDateCaption = 'Posting Date';
        DocNoCaption = 'Document No.';
        DescCaption = 'Description';
        VATAmtCaption = 'Tax Amount';
        EntryNoCaption = 'Entry No.';
        SourceNoCaption = 'Source No.';
        BeginningBalanceCaption = 'Beginning Balance';
        DebitTotalCaption = 'Debit Total';
        CreditTotalCaption = 'Credit Total';
        GrandTotalEndingBalanceCaption = 'Grand Total Ending Balance';

    }

    trigger OnPreReport()
    begin
        GLFilter := "G/L Account".GetFilters;
        GLDateFilter := "G/L Account".GetFilter("Date Filter");

        OnAfterOnPreReport("G/L Account");
    end;

    var
        EnavationGLManagement: Codeunit "ENA Enavation G/L Management";
        Text000: Label 'Period: %1';
        GLDateFilter: Text;
        GLFilter: Text;
        GLBalance: Decimal;
        StartBalance: Decimal;
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        PrintClosingEntries: Boolean;
        PrintOnlyCorrections: Boolean;
        PrintReversedEntries: Boolean;
        PageGroupNo: Integer;
        ClosingEntry: Boolean;
        DetailTrialBalCaptionLbl: Label 'Detail Trial Balance';
        PageCaptionLbl: Label 'Page';
        BalanceCaptionLbl: Label 'This also includes general ledger accounts that only have a balance.';
        PeriodCaptionLbl: Label 'This report also includes closing entries within the period.';
        OnlyCorrectionsCaptionLbl: Label 'Only corrections are included.';
        NetChangeCaptionLbl: Label 'Net Change';
        GLEntryDebitAmtCaptionLbl: Label 'Debit';
        GLEntryCreditAmtCaptionLbl: Label 'Credit';
        GLBalCaptionLbl: Label 'Balance';
        EnavationAccountNoCaptionLbl: Label 'Enavation No.';
        SegmentFilters: Array[5] of Text;
        Segment1Visible: Boolean;
        Segment2Visible: Boolean;
        Segment3Visible: Boolean;
        Segment4Visible: Boolean;
        Segment5Visible: Boolean;
        TotalBeginBalance: Decimal;
        GrandTotalEnding: Decimal;

    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean; NewExcludeBalanceOnly: Boolean; NewPrintClosingEntries: Boolean; NewPrintReversedEntries: Boolean; NewPrintOnlyCorrections: Boolean)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
        ExcludeBalanceOnly := NewExcludeBalanceOnly;
        PrintClosingEntries := NewPrintClosingEntries;
        PrintReversedEntries := NewPrintReversedEntries;
        PrintOnlyCorrections := NewPrintOnlyCorrections;
    end;

    local procedure SetGLEntryFilters(var GLEntry: Record "G/L Entry")
    var
    begin
        EnavationGLManagement.SetSegmentFilters("G/L Entry", SegmentFilters);
    end;

    local procedure GetSegmentFilter(SegmentNo: Integer; var OldValue: Text): Boolean
    var
        DimValues: Record "Dimension Value";
        EnavationSetup: Record "ENA Enavation G/L Setup";
        GLMgmgt: Codeunit "ENA Enavation G/L Management";
        Segment: enum "ENA Enavation G/L Segment";
        GLAccountList: Page "G/L Account List";
        OldText: Text;
        DimValueList: Page "Dimension Value List";
        DimCode: Code[20];
    begin
        EnavationSetup.get();


        case SegmentNo of
            1:
                Segment := EnavationSetup."Segment 1";
            2:
                Segment := EnavationSetup."Segment 2";
            3:
                Segment := EnavationSetup."Segment 3";
            4:
                Segment := EnavationSetup."Segment 4";
            5:
                Segment := EnavationSetup."Segment 5";
        end;

        case segment of
            Segment::" ":
                exit;
            Segment::"G/L Account No.":
                begin
                    begin
                        OldText := OldValue;
                        GLAccountList.LookupMode(true);
                        if not (GLAccountList.RunModal = ACTION::LookupOK) then
                            exit(false);

                        OldValue := OldText + GLAccountList.GetSelectionFilter;
                        exit(true);
                    end;
                end;
            else begin
                DimCode := GLMgmgt.GetSegmentDimension(Segment);
                DimValues.SetFilter("Dimension Code", DimCode);

                OldText := OldValue;
                DimValueList.SetTableView(DimValues);
                DimValueList.LookupMode(true);
                if not (DimValueList.RunModal() = action::LookupOK) then
                    exit(false);
                OldValue := OldText + DimValueList.GetSelectionFilter();
                exit(true);
            end;

        end

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnPreDataItemGLEntry(var GLEntry: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnPreReport(var GLAccount: Record "G/L Account")
    begin
    end;
}

