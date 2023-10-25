codeunit 50000 "ENA Enavation G/L Management"
{
    Permissions = tabledata "G/L Entry" = RM;

    /// <summary>
    /// Gets the value of a segment from an account;
    /// </summary>
    /// <param name="GLSegmentAccount">The account to get the segment value from.</param>
    /// <param name="Segment">The segment whose code should be retrieved.</param>
    /// <returns>The value of the desired segment.</returns>
    procedure GetSegmentCodeValue(var GLSegmentAccount: Record "ENA Enavation G/L Account"; Segment: Enum "ENA Enavation G/L Segment"): Code[20]
    var
    begin
        case Segment of
            Segment::"Global Dimension 1":
                exit(GLSegmentAccount."Global Dimension 1 Code");
            Segment::"Global Dimension 2":
                exit(GLSegmentAccount."Global Dimension 2 Code");
            Segment::"Shortcut Dimension 3":
                exit(GLSegmentAccount."Shortcut Dimension 3 Code");
            Segment::"Shortcut Dimension 4":
                exit(GLSegmentAccount."Shortcut Dimension 4 Code");
            Segment::"Shortcut Dimension 5":
                exit(GLSegmentAccount."Shortcut Dimension 5 Code");
            Segment::"Shortcut Dimension 6":
                exit(GLSegmentAccount."Shortcut Dimension 6 Code");
            Segment::"Shortcut Dimension 7":
                exit(GLSegmentAccount."Shortcut Dimension 7 Code");
            Segment::"Shortcut Dimension 8":
                exit(GLSegmentAccount."Shortcut Dimension 8 Code");
        end;
    end;

    /// <summary>
    /// Gets descriptions of each configured segment.
    /// </summary>
    /// <param name="SegNames">Populated with the segment names.</param>
    procedure GetSegmentDescriptions(var SegNames: Array[5] of Code[20])
    var
        EnavationGLSetup: Record "ENA Enavation G/L Setup";
    begin
        if (EnavationGLSetup.FindFirst()) then begin
            SegNames[1] := GetSegmentDescr(EnavationGLSetup."Segment 1");
            SegNames[2] := GetSegmentDescr(EnavationGLSetup."Segment 2");
            SegNames[3] := GetSegmentDescr(EnavationGLSetup."Segment 3");
            SegNames[4] := GetSegmentDescr(EnavationGLSetup."Segment 4");
            SegNames[5] := GetSegmentDescr(EnavationGLSetup."Segment 5");
        end;
    end;

    /// <summary>
    /// Sets filters on a GL entry for active segments.
    /// </summary>
    /// <param name="GLEntry">The entry to apply filters to.</param>
    /// <param name="FilterText">Segment filters.</param>
    procedure SetSegmentFilters(var GLEntry: Record "G/L Entry"; FilterText: Array[5] of Text)
    var
        EnavationGLSetup: Record "ENA Enavation G/L Setup";
    begin
        if EnavationGLSetup.FindFirst() then begin
            if ((EnavationGLSetup."Segment 1" <> Enum::"ENA Enavation G/L Segment"::" ") and (FilterText[1] <> '')) then
                SetSegmentFilter(GLEntry, EnavationGLSetup."Segment 1", FilterText[1]);
            if ((EnavationGLSetup."Segment 2" <> Enum::"ENA Enavation G/L Segment"::" ") and (FilterText[2] <> '')) then
                SetSegmentFilter(GLEntry, EnavationGLSetup."Segment 2", FilterText[2]);
            if ((EnavationGLSetup."Segment 3" <> Enum::"ENA Enavation G/L Segment"::" ") and (FilterText[3] <> '')) then
                SetSegmentFilter(GLEntry, EnavationGLSetup."Segment 3", FilterText[3]);
            if ((EnavationGLSetup."Segment 4" <> Enum::"ENA Enavation G/L Segment"::" ") and (FilterText[4] <> '')) then
                SetSegmentFilter(GLEntry, EnavationGLSetup."Segment 4", FilterText[4]);
            if ((EnavationGLSetup."Segment 5" <> Enum::"ENA Enavation G/L Segment"::" ") and (FilterText[5] <> '')) then
                SetSegmentFilter(GLEntry, EnavationGLSetup."Segment 5", FilterText[5]);
        end;
    end;

    /// <summary>
    /// Sets a filter on the specified segment.
    /// </summary>
    /// <param name="GLEntry">The entry to apply a filter to.</param>
    /// <param name="Segment">The segment to apply the filter to.</param>
    /// <param name="FilterText">The filter text.</param>
    procedure SetSegmentFilter(var GLEntry: Record "G/L Entry"; Segment: Enum "ENA Enavation G/L Segment"; FilterText: Text)
    var
        FilterGroup: Integer;
    begin
        FilterGroup := GLEntry.FilterGroup;
        GLEntry.FilterGroup := 100;

        case Segment of
            Segment::"G/L Account No.":
                GLEntry.SetFilter("G/L Account No.", "FilterText");
            Segment::"Global Dimension 1":
                GLEntry.SetFilter("Global Dimension 1 Code", FilterText);
            Segment::"Global Dimension 2":
                GLEntry.SetFilter("Global Dimension 2 Code", FilterText);
            Segment::"Shortcut Dimension 3":
                GLEntry.SetFilter("Shortcut Dimension 3 Code", FilterText);
            Segment::"Shortcut Dimension 4":
                GLEntry.SetFilter("Shortcut Dimension 4 Code", FilterText);
            Segment::"Shortcut Dimension 5":
                GLEntry.SetFilter("Shortcut Dimension 5 Code", FilterText);
            Segment::"Shortcut Dimension 6":
                GLEntry.SetFilter("Shortcut Dimension 6 Code", FilterText);
            Segment::"Shortcut Dimension 7":
                GLEntry.SetFilter("Shortcut Dimension 7 Code", FilterText);
            Segment::"Shortcut Dimension 8":
                GLEntry.SetFilter("Shortcut Dimension 8 Code", FilterText);
        end;

        GLEntry.FilterGroup := FilterGroup;
    end;

    /// <summary>
    /// Returns the specified segment from GL setup.
    /// </summary>
    /// <param name="EnavationSegment">Enum "ENA Enavation G/L Segment".</param>
    procedure GetSegmentDimension(EnavationSegment: Enum "ENA Enavation G/L Segment"): Code[20]
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.get();
        case EnavationSegment of
            "ENA Enavation G/L Segment"::"Global Dimension 1":
                exit(GeneralLedgerSetup."Global Dimension 1 Code");
            "ENA Enavation G/L Segment"::"Global Dimension 2":
                exit(GeneralLedgerSetup."Global Dimension 2 Code");
            "ENA Enavation G/L Segment"::"Shortcut Dimension 3":
                exit(GeneralLedgerSetup."Shortcut Dimension 3 Code");
            "ENA Enavation G/L Segment"::"Shortcut Dimension 4":
                exit(GeneralLedgerSetup."Shortcut Dimension 4 Code");
            "ENA Enavation G/L Segment"::"Shortcut Dimension 5":
                exit(GeneralLedgerSetup."Shortcut Dimension 5 Code");
            "ENA Enavation G/L Segment"::"Shortcut Dimension 6":
                exit(GeneralLedgerSetup."Shortcut Dimension 6 Code");
            "ENA Enavation G/L Segment"::"Shortcut Dimension 7":
                exit(GeneralLedgerSetup."Shortcut Dimension 7 Code");
            "ENA Enavation G/L Segment"::"Shortcut Dimension 8":
                exit(GeneralLedgerSetup."Shortcut Dimension 8 Code");
        end;
    end;

    /// <summary>
    /// Updates segments and accounts to use the configured codes.
    /// </summary>
    /// <param name="Regenerate">boolean.</param>
    procedure UpdateGLSegmentCodes(Regenerate: boolean)
    var
        ENEnavationGLAccount: Record "ENA Enavation G/L Account";
        EnavationGLSetup: Record "ENA Enavation G/L Setup";
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        Progress: Dialog;
        LastNo: Integer;
        UpdatingText: TextConst ENU = 'Updating Entry #1########### out of #2############';
    begin
        if not (EnavationGLSetup.Get() and EnavationGLSetup."Enable G/L Segments") then exit;

        if not Regenerate then
            GLEntry.SetFilter("ENA Enavation G/L Code", '%1', '')
        else begin
            ENEnavationGLAccount.Reset();
            ENEnavationGLAccount.DeleteAll();
        end;

        if not GLEntry.FindLast() then
            exit
        else
            LastNo := GLEntry."Entry No.";

        Progress.Open(UpdatingText);
        Progress.Update(1, 0);
        Progress.Update(2, LastNo);

        if GLEntry.FindSet() then
            repeat
                Progress.Update(1, GLEntry."Entry No.");
                GLEntry."ENA Enavation G/L Code" := GenerateGLSegmentCodeForEntry(GLEntry);
                GLEntry.Modify();
            until GLEntry.Next() = 0;

        //Totals
        GLAccount.Setfilter("Account Type", '<>%1', GLAccount."Account Type"::Posting);
        if GLAccount.FindSet() then
            repeat
                ENEnavationGLAccount.Init();
                ENEnavationGLAccount."Account Type" := GLAccount."Account Type";
                ENEnavationGLAccount."Enavation G/L Account No." := GLAccount."No.";
                ENEnavationGLAccount.Name := GLAccount.Name;
                ENEnavationGLAccount.Totaling := GLAccount.Totaling;
                if not ENEnavationGLAccount.Insert() then ENEnavationGLAccount.Modify();
            until GLAccount.Next() = 0;
    end;

    /// <summary>
    /// Determins if a segment is actively used in the Enavation account numbers.
    /// </summary>
    procedure SegmentIsActive(Segment: Enum "ENA Enavation G/L Segment"): boolean
    var
        EnavationGLSetup: Record "ENA Enavation G/L Setup";
    begin
        if EnavationGLSetup.FindFirst() then begin
            exit(
                Segment in [
                    EnavationGLSetup."Segment 1",
                    EnavationGLSetup."Segment 2",
                    EnavationGLSetup."Segment 3",
                    EnavationGLSetup."Segment 4",
                    EnavationGLSetup."Segment 5"
                ]
            )
        end;
    end;

    local procedure GetSegmentDescr(var SegmentIn: Enum "ENA Enavation G/L Segment"): Code[20]
    var
    begin
        case SegmentIn of
            SegmentIn::"G/L Account No.":
                exit('G/L Account No.');
            SegmentIn::" ":
                exit('');
            else
                exit(GetSegmentDimension(SegmentIn));
        end;
    end;

    procedure GenerateGLSegmentCodeForEntry(GLEntry: Record "G/L Entry"): Code[100]
    var
        EnavationGLAcctTemp: Record "ENA Enavation G/L Account" temporary;
        EnavationGLSetup: Record "ENA Enavation G/L Setup";
    begin
        if not (EnavationGLSetup.Get() and EnavationGLSetup."Enable G/L Segments") then exit;

        // Unravel this for perf - internal function can be expensive
        if EnavationGLSetup."Segment 1" <> Enum::"ENA Enavation G/L Segment"::" " then
            CreateSegmentAccountFromEntry(EnavationGLAcctTemp, EnavationGLSetup."Segment Separator", EnavationGLSetup."Segment 1", GLEntry);
        if EnavationGLSetup."Segment 2" <> Enum::"ENA Enavation G/L Segment"::" " then
            CreateSegmentAccountFromEntry(EnavationGLAcctTemp, EnavationGLSetup."Segment Separator", EnavationGLSetup."Segment 2", GLEntry);
        if EnavationGLSetup."Segment 3" <> Enum::"ENA Enavation G/L Segment"::" " then
            CreateSegmentAccountFromEntry(EnavationGLAcctTemp, EnavationGLSetup."Segment Separator", EnavationGLSetup."Segment 3", GLEntry);
        if EnavationGLSetup."Segment 4" <> Enum::"ENA Enavation G/L Segment"::" " then
            CreateSegmentAccountFromEntry(EnavationGLAcctTemp, EnavationGLSetup."Segment Separator", EnavationGLSetup."Segment 4", GLEntry);
        if EnavationGLSetup."Segment 5" <> Enum::"ENA Enavation G/L Segment"::" " then
            CreateSegmentAccountFromEntry(EnavationGLAcctTemp, EnavationGLSetup."Segment Separator", EnavationGLSetup."Segment 5", GLEntry);

        EnsureEnavationAcctExists(EnavationGLAcctTemp);

        exit(EnavationGLAcctTemp."Enavation G/L Account No.");
    end;

    internal procedure ExplodeAccSch(SchName: code[10])
    var
        AccSchLine: Record "Acc. Schedule Line";

        ExpAccSchLine: Record "Acc. Schedule Line";
        AccSchName: Record "Acc. Schedule Name";
        ExpAccSchName: Record "Acc. Schedule Name";
        EnavationCOA: Record "ENA Enavation G/L Account";
        IndentLevel: Integer;
        LineNo: Integer;
        NoLinesErr: Label 'No Lines on Account Schedule.';
        NoLinesToExplodeErr: Label 'No Lines to Explode.';
    begin
        AccSchName.get(SchName);

        AccSchLine.setrange("Schedule Name", AccSchName.Name);
        if not AccSchLine.findset() then
            Error(NoLinesErr);

        AccSchLine.SetRange("ENA Explode Enavation Acct.", true);
        if not AccSchLine.findset() then
            Error(NoLinesToExplodeErr);

        AccSchLine.SetRange("ENA Explode Enavation Acct.");

        UpdateExpAccSchName(AccSchName);
        commit();

        ExpAccSchName.get(AccSchName."ENA Enavation Acc. Sch. Name");
        ExpAccSchName.TransferFields(AccSchName, false);
        ExpAccSchName."ENA Enavation Acc. Sch. Name" := '';
        ExpAccSchName.Modify();

        ExpAccSchLine.setrange("Schedule Name", ExpAccSchName.Name);
        ExpAccSchLine.DeleteAll();

        AccSchLine.reset();
        AccSchLine.setrange("Schedule Name", AccSchName.Name);
        AccSchLine.FindFirst();
        repeat
            LineNo := LineNo + 10000;
            if AccSchLine."ENA Explode Enavation Acct." then begin
                AccSchLine."ENA Explode Enavation Acct." := false;

                EnavationCOA.reset();
                EnavationCOA.SetRange("G/L Account No.", AccSchLine.Totaling);
                if EnavationCOA.FindSet() then begin
                    //Header
                    IndentLevel := AccSchLine.Indentation;
                    ExpAccSchLine.init();
                    ExpAccSchLine.copy(AccSchLine);
                    ExpAccSchLine."Schedule Name" := ExpAccSchName.Name;
                    ExpAccSchLine."Line No." := LineNo;
                    ExpAccSchLine.Bold := true;
                    ExpAccSchLine.Totaling := '';
                    ExpAccSchLine."Row No." := '';
                    ExpAccSchLine.Insert();

                    //Lines
                    IndentLevel := IndentLevel + 1;

                    EnavationCOA.reset();
                    EnavationCOA.SetRange("G/L Account No.", AccSchLine.Totaling);
                    if EnavationCOA.FindSet() then
                        repeat
                            LineNo := LineNo + 10000;
                            ExpAccSchLine.init();
                            ExpAccSchLine.copy(AccSchLine);
                            ExpAccSchLine."Schedule Name" := ExpAccSchName.Name;
                            ExpAccSchLine."Line No." := LineNo;
                            ExpAccSchLine."ENA Enavation Acct. No." := EnavationCOA."Enavation G/L Account No.";
                            ExpAccSchLine.Indentation := IndentLevel;
                            ExpAccSchLine.Insert();
                        until EnavationCOA.Next() = 0;

                    //Footer
                    LineNo := LineNo + 10000;
                    IndentLevel := IndentLevel - 1;
                    ExpAccSchLine.init();
                    ExpAccSchLine.copy(AccSchLine);
                    ExpAccSchLine.Bold := true;
                    ExpAccSchLine."Schedule Name" := ExpAccSchName.Name;
                    ExpAccSchLine."Line No." := LineNo;
                    ExpAccSchLine.Insert();
                end else begin
                    ExpAccSchLine.init();
                    ExpAccSchLine.copy(AccSchLine);
                    ExpAccSchLine."Schedule Name" := ExpAccSchName.Name;
                    ExpAccSchLine."Line No." := LineNo;
                    ExpAccSchLine.Insert();
                end;
            end else begin
                ExpAccSchLine.init();
                ExpAccSchLine.copy(AccSchLine);
                ExpAccSchLine."Schedule Name" := ExpAccSchName.Name;
                ExpAccSchLine."Line No." := LineNo;
                ExpAccSchLine.Insert();
            end;

        until AccSchLine.Next() = 0;

    end;

    local procedure EnsureEnavationAcctExists(var EnavationGLAccountTemp: Record "ENA Enavation G/L Account" temporary)
    var
        EnavationGLAccount: Record "ENA Enavation G/L Account";
    begin
        if not EnavationGLAccount.Get(EnavationGLAccountTemp."Enavation G/L Account No.") then begin
            EnavationGLAccount.Copy(EnavationGLAccountTemp);
            EnavationGLAccount.Insert();
        end;
    end;

    local procedure CreateSegmentAccountFromEntry(var EnavationGLAccountTemp: Record "ENA Enavation G/L Account" temporary; SegmentSeparator: code[1]; Segment: Enum "ENA Enavation G/L Segment"; GLEntry: Record "G/L Entry")
    var
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();
        GLEntry.CalcFields("Shortcut Dimension 3 Code", "Shortcut Dimension 4 Code", "Shortcut Dimension 5 Code", "Shortcut Dimension 6 Code",
            "Shortcut Dimension 7 Code", "Shortcut Dimension 8 Code", "G/L Account Name");

        if EnavationGLAccountTemp."Enavation G/L Account No." <> '' then
            EnavationGLAccountTemp."Enavation G/L Account No." := EnavationGLAccountTemp."Enavation G/L Account No." + SegmentSeparator;

        if EnavationGLAccountTemp."G/L Account No." = '' then
            EnavationGLAccountTemp."G/L Account No." := GLEntry."G/L Account No.";

        if EnavationGLAccountTemp.Name = '' then
            EnavationGLAccountTemp.Name := GLEntry."G/L Account Name";

        case Segment of
            Segment::"G/L Account No.":
                EnavationGLAccountTemp."Enavation G/L Account No." := EnavationGLAccountTemp."Enavation G/L Account No." + GLEntry."G/L Account No.";
            Segment::"Global Dimension 1":
                begin
                    EnavationGLAccountTemp."Enavation G/L Account No." := EnavationGLAccountTemp."Enavation G/L Account No." + GLEntry."Global Dimension 1 Code";
                    EnavationGLAccountTemp."Global Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
                end;
            Segment::"Global Dimension 2":
                begin
                    EnavationGLAccountTemp."Enavation G/L Account No." := EnavationGLAccountTemp."Enavation G/L Account No." + GLEntry."Global Dimension 2 Code";
                    EnavationGLAccountTemp."Global Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
                end;
            Segment::"Shortcut Dimension 3":
                begin
                    EnavationGLAccountTemp."Enavation G/L Account No." := EnavationGLAccountTemp."Enavation G/L Account No." + GLEntry."Shortcut Dimension 3 Code";
                    EnavationGLAccountTemp."Shortcut Dimension 3 Code" := GLEntry."Shortcut Dimension 3 Code";
                end;
            Segment::"Shortcut Dimension 4":
                begin
                    EnavationGLAccountTemp."Enavation G/L Account No." := EnavationGLAccountTemp."Enavation G/L Account No." + GLEntry."Shortcut Dimension 4 Code";
                    EnavationGLAccountTemp."Shortcut Dimension 4 Code" := GLEntry."Shortcut Dimension 4 Code";
                end;
            Segment::"Shortcut Dimension 5":
                begin
                    EnavationGLAccountTemp."Enavation G/L Account No." := EnavationGLAccountTemp."Enavation G/L Account No." + GLEntry."Shortcut Dimension 5 Code";
                    EnavationGLAccountTemp."Shortcut Dimension 5 Code" := GLEntry."Shortcut Dimension 5 Code";
                end;
            Segment::"Shortcut Dimension 6":
                begin
                    EnavationGLAccountTemp."Enavation G/L Account No." := EnavationGLAccountTemp."Enavation G/L Account No." + GLEntry."Shortcut Dimension 6 Code";
                    EnavationGLAccountTemp."Shortcut Dimension 6 Code" := GLEntry."Shortcut Dimension 6 Code";
                end;
            Segment::"Shortcut Dimension 7":
                begin
                    EnavationGLAccountTemp."Enavation G/L Account No." := EnavationGLAccountTemp."Enavation G/L Account No." + GLEntry."Shortcut Dimension 7 Code";
                    EnavationGLAccountTemp."Shortcut Dimension 7 Code" := GLEntry."Shortcut Dimension 7 Code";
                end;
            Segment::"Shortcut Dimension 8":
                begin
                    EnavationGLAccountTemp."Enavation G/L Account No." := EnavationGLAccountTemp."Enavation G/L Account No." + GLEntry."Shortcut Dimension 8 Code";
                    EnavationGLAccountTemp."Shortcut Dimension 8 Code" := GLEntry."Shortcut Dimension 8 Code";
                end;
        end
    end;

    local procedure GetAnalysisDims(EnavationGLSetup: Record "ENA Enavation G/L Setup"; var DimensionCode: array[4] of Code[20])
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.get();
        clear(DimensionCode);
        if EnavationGLSetup."Segment 2" <> "ENA Enavation G/L Segment"::" " then
            DimensionCode[1] := GetSegmentDimension(EnavationGLSetup."Segment 2");
        if EnavationGLSetup."Segment 2" <> "ENA Enavation G/L Segment"::" " then
            DimensionCode[2] := GetSegmentDimension(EnavationGLSetup."Segment 3");
        if EnavationGLSetup."Segment 2" <> "ENA Enavation G/L Segment"::" " then
            DimensionCode[3] := GetSegmentDimension(EnavationGLSetup."Segment 4");
        if EnavationGLSetup."Segment 2" <> "ENA Enavation G/L Segment"::" " then
            DimensionCode[4] := GetSegmentDimension(EnavationGLSetup."Segment 5");
    end;

    local procedure UpdateExpAccSchName(var AccSchName: Record "Acc. Schedule Name")
    var
        AccSchNames: Record "Acc. Schedule Name";
        ActionCancelledErr: Label 'Action cancelled by user.';
        MustAssignExplAccSchQst: Label 'You must first assign an Account Schedule for the exploded lines. Do you wish to continue.';
        SelectAnotherAccSchQst: Label 'Do you wish to select another Account Schedule.';
        UpdateExistingAccSchQst: Label 'This will update Account Schedule %1. Do you wish to continue.';
    begin
        if AccSchName."ENA Enavation Acc. Sch. Name" = '' then begin
            if not Confirm(MustAssignExplAccSchQst, false) then
                Error(ActionCancelledErr);

            if Page.RunModal(page::"Account Schedule Names", AccSchNames) = Action::LookupOK then begin
                AccSchName."ENA Enavation Acc. Sch. Name" := AccSchNames.Name;
                AccSchName.modify();
            end else
                error(ActionCancelledErr);
        end else begin
            if not Confirm(UpdateExistingAccSchQst, false, AccSchName."ENA Enavation Acc. Sch. Name") then begin
                if not Confirm(SelectAnotherAccSchQst, false) then
                    Error(ActionCancelledErr);

                if Page.RunModal(page::"Account Schedule Names", AccSchNames) = Action::LookupOK then begin
                    AccSchName."ENA Enavation Acc. Sch. Name" := AccSchNames.Name;
                    AccSchName.modify();
                end else
                    error(ActionCancelledErr);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Caption Class", 'OnResolveCaptionClass', '', true, true)]
    local procedure ResolveSegmentCaptions(CaptionArea: Text; CaptionExpr: Text; Language: Integer; var Caption: Text; var Resolved: Boolean)
    var
        EnavationGLSetup: Record "ENA Enavation G/L Setup";
    begin
        if (not EnavationGLSetup.FindFirst()) and (CaptionArea <> 'EnavationSegment') then
            exit;

        case CaptionExpr of
            '1':
                begin
                    Caption := GetSegmentDescr(EnavationGLSetup."Segment 1");
                    Resolved := true;
                end;
            '2':
                begin
                    Caption := GetSegmentDescr(EnavationGLSetup."Segment 2");
                    Resolved := true;
                end;
            '3':
                begin
                    Caption := GetSegmentDescr(EnavationGLSetup."Segment 3");
                    Resolved := true;
                end;
            '4':
                begin
                    Caption := GetSegmentDescr(EnavationGLSetup."Segment 4");
                    Resolved := true;
                end;
            '5':
                begin
                    Caption := GetSegmentDescr(EnavationGLSetup."Segment 5");
                    Resolved := true;
                end;
        end;
    end;

    /// <summary>
    /// Used to support calculations in Account Schedules. Sets a filter on GL entries that corresponds to a line's Enavation Account No.
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::AccSchedManagement, 'OnAfterSetGLAccGLEntryFilters', '', true, true)]
    procedure OnAfterSetGLAccGLEntryFilters(var GLAccount: Record "G/L Account"; var GLEntry: Record "G/L Entry"; var AccSchedLine: Record "Acc. Schedule Line"; var ColumnLayout: Record "Column Layout"; UseBusUnitFilter: Boolean; UseDimFilter: Boolean)
    var
    begin
        if (AccSchedLine."ENA Enavation Acct. No." <> '') then
            GLEntry.SetRange("ENA Enavation G/L Code", AccSchedLine."ENA Enavation Acct. No.");
    end;
}
