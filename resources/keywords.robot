*** Settings ***
Library    QWeb
Library    String
Library    Collections

*** Variables ***
${cookie_agree}    //span[@id='cookies-agree']
@{price_list}
@{price_list_basket}

*** Keywords ***
Setup Browser
    OpenBrowser    about:blank    chrome
    GoTo    https://www.nay.sk/    

Cookies and category
    Click Element    ${cookie_agree}
    Click Text    Mobily
    Click Text    Mobilné
    Click Text    Smartfóny
    Click Text    Všetko    Android

Sorting high to low
    Drop Down    //button[contains(@id,'8570')]    Najdrahšie
    
Price sorting control
#Create List of prices
    ${elements_count}    Get Element Count    //strong[contains(@class,'typo-complex-16')] 
    
    FOR    ${counter}    IN RANGE    ${elements_count}
        ${element_num}    Evaluate    ${counter}+1
        ${xpath}    Set Variable    //div[@class="inventory_item"][${element_num}]//div[@class="inventory_item_price"]
        ${price_txt}    Get Text    ${xpath}    between=$???
        ${price_num}    Convert To Number    ${price_txt}
        Append To List    ${price_list}    ${price_num}
    END
    #Price sorting control
    ${ListCount-1}=    Evaluate    ${elements_count}-1
       FOR    ${counter}    IN RANGE    ${elements_count}
           ${counter+1}=    Evaluate    ${counter}+1
           IF    $counter == ${ListCount-1}    BREAK
           ${ListItem1}=    Get From List    ${price_list}    ${counter}
           ${ListItem2}=    Get From List    ${price_list}    ${counter+1}
           Should Be True    ${ListItem1}>=${ListItem2}
           Log To Console    ${ListItem1}' and '${ListItem2}
       END

Price sorting control in basket
#Create List of prices
    ${elements_count}    Get Element Count    //div[contains(@class,'inventory_item_price')]

    FOR    ${counter}    IN RANGE    ${elements_count}
        ${element_num}    Evaluate    ${counter}+1
        ${xpath}    Set Variable    //div[@class="cart_item"][${element_num}]//div[@class="inventory_item_price"]
        ${price_txt}    Get Text    ${xpath}    between=$???
        ${price_num}    Convert To Number    ${price_txt}
        Append To List    ${price_list_basket}    ${price_num}
    END
    #Price sorting control
    ${ListCount-1}=    Evaluate    ${elements_count}-1
    FOR    ${counter}    IN RANGE    ${elements_count}
        ${counter+1}=    Evaluate    ${counter}+1
        IF    $counter == ${ListCount-1}    BREAK
        ${ListItem1}=    Get From List    ${price_list_basket}    ${counter}
        ${ListItem2}=    Get From List    ${price_list_basket}    ${counter+1}
        Should Be True    ${ListItem1}>=${ListItem2}
        Log To Console    ${ListItem1}' and '${ListItem2}
    END     

Add items to basket
#Add 3 most expensive items to basket 
    [Arguments]    ${num_of_items}                      
    FOR    ${counter}    IN RANGE    ${num_of_items}
        Click Element    //button[contains(@data-test,'add-to-cart')]
    END

Open basket
    Click Element    //a[contains(@class,'shopping_cart_link')]

Delete from basket
    [Arguments]    ${num_delete}
    FOR    ${counter}    IN RANGE    ${num_delete}
        Click Element    //button[contains(@name,'remove')]
    END

Checkout and fill data
    [Arguments]    ${surname}    ${lastname}    ${postal_code}
    Click Element    //button[contains(@id,'checkout')]
    Type Text    //input[contains(@id,'first-name')]    ${surname}
    Type Text    //input[contains(@id,'last-name')]    ${lastname}
    Type Text    //input[contains(@id,'postal-code')]    ${postal_code}
    Click Element    //input[contains(@id,'continue')]
    Click Element    //button[contains(@id,'finish')]    