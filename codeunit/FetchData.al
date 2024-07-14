codeunit 60000 "Fetch Customer List"
{


    
    procedure PostCustomersToAPI()
    var
        Customers: Record Customer;
        Url: Text;
        HttpClient: HttpClient;
        Response: HttpResponseMessage;
        HttpHeader: HttpHeaders;
        HttpContent: HttpContent;
        JsonData: JsonObject;
        isSucessful, Sent : Boolean;
        httpRequest: HttpRequestMessage;
        body, error : Text;


    begin
        url := 'https://connect.squareupsandbox.com/v2/customers';
        HttpClient.Clear();


        if not Customers.IsEmpty then begin
            repeat
                Clear(JsonData);
                Clear(body);
                JsonData.Add('given_name', 'oom');
                JsonData.Add('birthday', '1997-01-01');
                JsonData.Add('company_name', Customers.Name);
                JsonData.Add('email_address', Customers."E-Mail");
                JsonData.Add('family_name', Customers.Name);
                JsonData.Add('reference_id', Customers."No.");
                JsonData.Add('nickname', Customers.Name);
                JsonData.Add('note', Customers."No." + ' ' + Customers.name);
                HttpContent.Clear();
                HttpClient.Clear();
                Clear(httpRequest);
                HttpClient.DefaultRequestHeaders().Clear();
                httpRequest.GetHeaders(HttpHeader);
                JsonData.WriteTo(body);
                HttpContent.WriteFrom(body);
                HttpContent.GetHeaders(HttpHeader);
                HttpHeader.Clear();
                HttpHeader.Add('Content-Type', 'application/json');
                HttpClient.DefaultRequestHeaders().Add('Square-Version', '2024-06-04');
                HttpClient.DefaultRequestHeaders().Add('Authorization', 'Bearer Secret_key');
                httpRequest.Content := HttpContent;
                httpRequest.SetRequestUri(Url);
                httpRequest.Method := 'POST';
                if StrLen(body) < 1 then exit;
                isSucessful := HttpClient.Send(httpRequest, response);

                if not isSucessful then Error('Kindly check the url %1', url);
                Response.Content.ReadAs(error);
                if not Response.IsSuccessStatusCode then Error('API Returned a status of %1', Response.HttpStatusCode);
                if Response.IsSuccessStatusCode then Sent := true;

            until Customers.Next() = 0;
        end;

        if Sent then Message('Posted Sucessfully!!!');

    end;




    procedure FetchData()
    var
        Client: HttpClient;
        url, Result, Arraydata : Text;
        Response: HttpResponseMessage;
        ClientContent: HttpContent;
        JsonObj: JsonObject;
        JsonArr: JsonArray;
        JsonToken, ResultToken : JsonToken;
        isSucessful: Boolean;
        id: code[50];
        name, nickname, email, note, companyName : text;
        index: Integer;
        Customer: Record customer;
        noSeriesMgt: Codeunit "No. Series";
        ReceiableSetup: Record "Sales & Receivables Setup";

    begin
        url := 'https://connect.squareupsandbox.com/v2/customers';
        Client.Clear();
        Client.DefaultRequestHeaders().Add('Square-Version', '2024-05-15');
        Client.DefaultRequestHeaders().Add('Authorization', 'Bearer Secret_key');
        isSucessful := Client.Get(url, Response);
        if not isSucessful then Error('Kindly check the url %1', url);

        if not Response.IsSuccessStatusCode then Error('API Returned a status of %1', Response.HttpStatusCode);

        ClientContent.Clear();
        ClientContent := Response.Content;
        ClientContent.ReadAs(Result);
        JsonObj.ReadFrom(Result);
        if JsonObj.Get('customers', JsonToken) then begin
            JsonToken.WriteTo(Arraydata);
            JsonArr.ReadFrom(Arraydata);

            for index := 0 to JsonArr.Count do begin
                Clear(JsonToken);
                if JsonArr.Get(index, JsonToken) then begin
                    if JsonToken.AsObject().Get('id', ResultToken) then
                        id := ResultToken.AsValue().AsCode();
                    if JsonToken.AsObject().Get('given_name', ResultToken) then
                        name := ResultToken.AsValue().AsText();
                    if JsonToken.AsObject().Get('nickname', ResultToken) then
                        nickname := ResultToken.AsValue().AsText();
                    if JsonToken.AsObject().Get('email_address', ResultToken) then
                        email := ResultToken.AsValue().AsText();
                    if JsonToken.AsObject().Get('company_name', ResultToken) then
                        companyName := ResultToken.AsValue().AsText();
                    ReceiableSetup.Get();
                    Customer.SetRange("Name 2", id);
                    if not Customer.FindFirst() then begin
                        Customer.Reset();
                        Customer.Init();
                        Customer."No." := noSeriesMgt.GetNextNo(ReceiableSetup."Customer Nos.");
                        Customer.Name := name;
                        Customer."Name 2" := id;
                        Customer."E-Mail" := email;
                        if Customer.Insert() = true then Message('Customer Record %1 updated sucessfully!!!');
                    end else
                        Message('Customer List is up-to date');


                end;
            end;


        end else
            Message('Failed to fetech data');




    end;



    procedure PostItemToAPI()
    var
        Item: Record Item;
        HttpClient: HttpClient;
        Url, urltoken, Result, Arraydata, TokenText : Text;
        Response, tokenResponse : HttpResponseMessage;
        httpRequest: HttpRequestMessage;
        HttpContent, TokenContent, TokenContentC : HttpContent;
        JsonData: JsonObject;
        JsonArray: JSONArray;
        JsonToken, ResaultToken : JsonToken;
        IsSucessful, istheretoken, Sent : Boolean;
        id: code[50];
        itemNo, name, cateogryID, usertext : Text;
        secretusertext: SecretText;
        index: integer;
        HttpHeader: HttpHeaders;
        noseries: Codeunit NoSeriesManagement;
        Date: Date;
        Base64: Codeunit "Base64 Convert";
        body, error : Text;
        ItemList: Page "Item List";


    begin
        Url := 'http://cloud.cds-jo.com:60202/OSFAAPI/api/item/1';
        urltoken := 'http://cloud.cds-jo.com:60202/OSFAAPI/api/token';
        usertext := '{"userid":"integ","userpwd":"111"}';

        HttpClient.Clear();
        //if Item.FindFirst() then begin
        if not Item.IsEmpty then begin
            repeat
                Clear(JsonData);
                Clear(body);
                JsonData.Add('itemNo', Item."No.");
                JsonData.Add('name', Item.Description);
                JsonData.Add('cateogryID', Item."Item Category Code");

                /*
                body := '{"itemNo": "' + Item."No." + '",' +
                '"name": "' + Item.Description + '",' +
                '"cateogryID": "' + Item."Item Category Code" + '"}';
                */
                HttpContent.Clear();
                HttpClient.Clear();
                Clear(httpRequest);
                HttpClient.DefaultRequestHeaders().Clear();
                httpRequest.GetHeaders(HttpHeader);
                JsonData.WriteTo(body);

                TokenContent.WriteFrom(usertext);
                TokenContent.GetHeaders(HttpHeader);
                HttpHeader.Remove('Content-Type');
                TokenContent.GetHeaders(HttpHeader);
                istheretoken := HttpClient.Post(urltoken, TokenContent, tokenResponse);
                TokenContentC := tokenResponse.Content;
                TokenContentC.ReadAs(TokenText);
                HttpClient.DefaultRequestHeaders().Add('Authorization', 'Bearer ' + TokenText);
                HttpHeader.Add('Content-Type', 'application/json');
                TokenContent.WriteFrom(body);

                httpRequest.Content := HttpContent;
                httpRequest.SetRequestUri(Url);
                httpRequest.Method := 'POST';
                if StrLen(body) < 1 then exit;
                isSucessful := HttpClient.Send(httpRequest, response);

                if not isSucessful then Error('Kindly check the url %1', Url);
                Response.Content.ReadAs(error);
                if not Response.IsSuccessStatusCode then Error('API Returned a status of 1%', Response.HttpStatusCode);
                if Response.IsSuccessStatusCode then Sent := true;


            Until Item.Next() = 0;

        end;
        if Sent then Message('Posted Sucessfully !!!');
    end;



    procedure PostItemCategoryToAPI()
    var
        ItemC: Record "Item Category";
        HttpClient: HttpClient;
        Url, urltoken, Result, Arraydata, TokenText : Text;
        Response, tokenResponse : HttpResponseMessage;
        httpRequest: HttpRequestMessage;
        HttpContent, TokenContent, TokenContentC : HttpContent;
        JsonData: JsonObject;
        JsonArray: JSONArray;
        JsonToken, ResaultToken : JsonToken;
        IsSucessful, istheretoken, Sent : Boolean;
        usertext: Text;
        index: integer;
        HttpHeader: HttpHeaders;
        noseries: Codeunit NoSeriesManagement;
        Date: Date;
        Base64: Codeunit "Base64 Convert";
        body, error : Text;
        ItemList: Page "Item Categories";


    begin
        Url := 'http://cloud.cds-jo.com:60202/OSFAAPI/api/itemcategories/1';
        urltoken := 'http://cloud.cds-jo.com:60202/OSFAAPI/api/token';
        usertext := '{"userid":"integ","userpwd":"111"}';

        HttpClient.Clear();
        //if Item.FindFirst() then begin
        if not ItemC.IsEmpty then begin
            repeat
                Clear(JsonData);
                Clear(body);

                JsonData.Add('id', ItemC.Code);
                JsonData.Add('name', ItemC.Description);
                JsonData.WriteTo(body);


                /*body := '{"id": "' + ItemC.Code + '",' +
                '"name": "' + ItemC.Description + '"}';
                */

                HttpContent.Clear();

                HttpClient.Clear();
                Clear(httpRequest);
                HttpClient.DefaultRequestHeaders().Clear();
                httpRequest.GetHeaders(HttpHeader);


                TokenContent.WriteFrom(body);
                TokenContent.GetHeaders(HttpHeader);
                HttpHeader.Remove('Content-Type');
                HttpHeader.Add('Content-Type', 'application/json');
                istheretoken := HttpClient.Post(urltoken, TokenContent, tokenResponse);
                TokenContentC := tokenResponse.Content;
                /* Message('Format %1', TokenContentC);*/
                TokenContentC.ReadAs(TokenText);
                clear(httpRequest);
                httpRequest.Content := TokenContent;
                httpRequest.SetRequestUri(Url);
                httpRequest.Method := 'POST';

                clear(response);
                if StrLen(body) < 1 then exit;
                if TokenText <> '' then begin
                    HttpClient.DefaultRequestHeaders().Add('Authorization', 'Bearer ' + TokenText);
                    isSucessful := HttpClient.Send(httpRequest, response);
                    if not isSucessful then Error('Kindly check the url %1', Url);
                    Response.Content.ReadAs(error);
                    if not Response.IsSuccessStatusCode then Error('API Returned a status of %1', Response.HttpStatusCode);
                    if Response.IsSuccessStatusCode then Sent := true;

                end else
                    Message('Token does not exist');
            Until ItemC.Next() = 0;

        end;
        if Sent then Message('Posted Sucessfully !!!');
    end;

}










