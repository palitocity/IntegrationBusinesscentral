

namespace Education.Studendprofile;

table 50100 "Student Profile"
{
    DataClassification = ToBeClassified;
    Caption = 'Student Profile Record';
    Description = 'This is responsible for storing our student record';


    fields
    {
        field(1; "Matric Number"; Integer)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            // declarating of local variable 
            var
                age: Integer;
            begin
                myName := 'daniel';
            end;

        }
        field(2; "First Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            // declarating of local variable 
            var
                age: Integer;
            begin
                myName := 'daniel';
            end;

        }

    }

    keys
    {
        key(Key1; "Matric Number")
        {
            Clustered = true;
        }
        key(Key2; "First Name")
        {

        }

    }

    fieldgroups
    {
        // Add changes to field groups here
        fieldgroup(DropDown; "Matric Number", "First Name")
        {

        }
        fieldgroup(Brick; "Matric Number", "First Name")
        {

        }

    }
    // global variable , 
    var

        myName: text;
        age: Integer;


    local procedure SayHelloWorld()
    var
        age: Integer;
    begin

    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}