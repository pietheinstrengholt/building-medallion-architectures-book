MERGE INTO Bronze_Customer AS t  
USING Landing_Customer AS s  
ON t.CustomerID = s.CustomerID  
WHEN MATCHED THEN  
    UPDATE SET  
        t.Name = s.Name,  
        t.ContactDetails = s.ContactDetails,  
        t.PurchaseHistory = s.PurchaseHistory  
WHEN NOT MATCHED THEN  
    INSERT (CustomerID, Name, ContactDetails, PurchaseHistory)  
    VALUES (s.CustomerID, s.Name, s.ContactDetails, s.PurchaseHistory);