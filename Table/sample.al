table 50100 MyTable
{
    TableType = Temporary;

    fields
    {
        field(1; MyField; Integer)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; MyField)
        {
            Clustered = true;
        }
       
    }

    fieldgroups
    {
        // Add changes to field groups here
        fieldgroup(Brick; MyField){

        }
        

    }


    var
        myInt: Integer;





    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin
 
    end;

    trigger OnDelete()
    begin

          error('You do not have right to delete')
    end;

    trigger OnRename()
    begin

    end;

}