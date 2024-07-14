pageextension 60000 CustomeExt extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
    }



key(key1; matric no;department,faculty)





    actions
    {
        // Add changes to page actions here
        addafter("Customer List")
        {
            action(customerList)
            {
                Promoted = true;
                ApplicationArea = Basic, Suite;
                PromotedCategory = Category4;
                trigger OnAction()
                var
                    FetchList: Codeunit "Fetch Customer List";
                begin
                    FetchList.FetchData();
                end;

            }
            action(PostCustomer)
            {
                Promoted = true;
                ApplicationArea = Basic, Suite;
                PromotedCategory = Category4;
                Caption = 'Transfer Customers';
                trigger OnAction()
                var
                    FetchList: Codeunit "Fetch Customer List";
                begin
                    FetchList.PostCustomersToAPI();
                    ;
                end;

            }
        }
    }

    var
        myInt: Integer;


        trigger OnAfterGetCurrRecord() begin 
          if Rec.status then begin 
            djdkjdjdjdjdjdjdjdjdj
          end
        end;

        trigger OnAfterGetRecord() begin 
          
        end;

        trigger OnClosePage() begin 
            
        end;

        trigger OnDeleteRecord(): Boolean begin 

        end;

        trigger OnInsertRecord(BelowxRec: Boolean): Boolean begin 

        end;

        trigger OnModifyRecord(): Boolean begin 

        end;
         trigger OnNewRecord(BelowxRec: Boolean) begin 

         end;
         trigger OnOpenPage() begin 
                  if fauser and has cu then error( you dont have access to this page)
         end;
}



GET , Setrange , Setfilter   document page  > sales header => sales line 
salesheader.setrange(nO,documenttype)
customer , vendor 
 if vendor.get(no) then begin

end




customer   applicationArea = all  , No.  , No.
 Record > properties > Fields > keys 

















