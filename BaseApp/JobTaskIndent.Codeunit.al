codeunit 1003 "Job Task-Indent"
{
    TableNo = "Job Task";

    trigger OnRun()
    begin
        TestField("Job No.");
        if not
           Confirm(
             Text000 +
             Text001 +
             Text002 +
             Text003, true)
        then
            exit;
        JT := Rec;
        Indent("Job No.");
    end;

    var
        Text000: Label 'This function updates the indentation of all the Job Tasks.';
        Text001: Label 'All Job Tasks between a Begin-Total and the matching End-Total are indented one level. ';
        Text002: Label 'The Totaling for each End-total is also updated.';
        Text003: Label '\\Do you want to indent the Job Tasks?';
        Text004: Label 'Indenting the Job Tasks #1##########.';
        Text005: Label 'End-Total %1 is missing a matching Begin-Total.';
        ArrayExceededErr: Label 'You can only indent %1 levels for job tasks of the type Begin-Total.', Comment = '%1 = A number bigger than 1';
        JT: Record "Job Task";
        Window: Dialog;
        JTNo: array[10] of Code[20];
        i: Integer;

    procedure Indent(JobNo: Code[20])
    begin
        Window.Open(Text004);
        JT.SetRange("Job No.", JobNo);
        with JT do
            if Find('-') then
                repeat
                    Window.Update(1, "Job Task No.");

                    if "Job Task Type" = "Job Task Type"::"End-Total" then begin
                        if i < 1 then
                            Error(
                              Text005,
                              "Job Task No.");
                        Totaling := JTNo[i] + '..' + "Job Task No.";
                        i := i - 1;
                    end;

                    Indentation := i;
                    Modify;

                    if "Job Task Type" = "Job Task Type"::"Begin-Total" then begin
                        i := i + 1;
                        if i > ArrayLen(JTNo) then
                            Error(ArrayExceededErr, ArrayLen(JTNo));
                        JTNo[i] := "Job Task No.";
                    end;
                until Next = 0;

        Window.Close;
    end;
}

