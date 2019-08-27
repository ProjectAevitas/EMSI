report 50002 PurchaseHeader
{
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            { }
            column(PoNo_; "No.")
            { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            { }
            column(Buy_from_Address; "Buy-from Address")
            { }
            column(Buy_from_Address_2; "Buy-from Address 2")
            { }
            column(Buy_from_City; "Buy-from City")
            { }
            column(Buy_from_Contact; "Buy-from Contact")
            { }
            column(Buy_from_Country_Region_Code; "Buy-from Country/Region Code")
            { }
            column(Posting_Date; "Posting Date")
            { }
            column(Due_Date; "Due Date")
            { }
            column(Purchaser_Code; "Purchaser Code")
            { }
            column(Currency_Code; "Currency Code")
            { }
            //
            dataitem("Purchase Line"; "Purchase Line")
            {
                column(No_; "No.")
                { }
                column(Description; Description)
                { }
                column(Quantity; Quantity)
                { }
                column(Unit_of_Measure; "Unit of Measure")
                { }
                column(Direct_Unit_Cost; "Direct Unit Cost")
                { }
                column(Line_Amount; "Line Amount")
                { }
                column(Amount; Amount)
                { }
                column(Amount_Including_VAT; "Amount Including VAT")
                { }
                //
                trigger OnPreDataItem()
                begin
                    _NoUrut := 0;
                end;

                trigger OnAfterGetRecord()

                begin
                    if "Purchase Line".Type <> "Purchase Line".Type::" " then
                        _NoUrut := _NoUrut + 1
                    else
                        _NoUrut := _NoUrut + 0;
                end;
            }
            // Trigger
            trigger OnAfterGetRecord()
            begin
                Clear(_VendorInfo);
                Clear(_ShipToInfo);
                Clear(_CompanyInfo);

                _PaymentTerms.reset;


            end;
        }
    }

    labels
    {
        ReportName = 'PURCHASE ORDER';
    }

    var
        //myInt: Integer;
        _Vendor: Record Vendor;
        _VendorInfo: array[6] of Text[200];
        _ShipToInfo: array[6] of Text[200];
        _Company: Record "Company Information";
        _CompanyInfo: array[5] of Text[200];

        //
        _PaymentTerms: Record "Payment Terms";
        _PaymentDesc: Text;
        _SalesPersonName: Text;
        _Negara: Text;
        _LCYCode: Text;
        _VendPhone: Text;
        _NoUrut: Integer;
        //
    procedure GetDetailInformation(var ToValue: array[6] of Text[200]; CodeNo: Code[20])
    var
        gLocation: Record Location;
    begin
        if _Vendor.Get(CodeNo) then begin
            ToValue[1] := _Vendor."No.";
            ToValue[2] := _Vendor.Name;
            ToValue[3] := _Vendor.Address;
            ToValue[4] := _Vendor.City;
            ToValue[5] := _Vendor."Phone No.";
            ToValue[6] := _Vendor."Post Code";
        end else begin
            if gLocation.Get(CodeNo) then begin
                ToValue[1] := gLocation.Code;
                ToValue[2] := gLocation.Name;
                ToValue[3] := gLocation.Address;
                ToValue[4] := gLocation.City;
                ToValue[5] := gLocation."Phone No.";
                ToValue[6] := gLocation."Post Code";
            end;
        end;
    end;

    procedure GetCompanyInformation()
    var
        _Country: Record "Country/Region";
    begin
        _Company.Get;
        _CompanyInfo[1] := _Company.Name;
        _CompanyInfo[2] := _Company.Address + ' ' + _Company."Address 2";
        _CompanyInfo[3] := _Company.City;
        _Company.TestField("Country/Region Code");
        _Country.Get(_Company."Country/Region Code");
        _CompanyInfo[4] := _Company.Name;
        _CompanyInfo[5] := _Company."Post Code";
    end;
}