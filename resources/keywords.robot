*** Settings ***
Library    QWeb
Library    String
Library    Collections

*** Variables ***

@{price_list}
@{price_list_basket}
@{names_items}
@{names_items_basket}

*** Keywords ***
Setup Browser
    OpenBrowser    about:blank    chrome    options=add_experimental_option("detach", True)
    GoTo    https://www.tpd.sk/    

Cookies and category
    Click Element    //button[contains(@id,'AllowAll')]
    Hover Text    Počítače a smartfóny
    Click Text    Mobilné Telefóny    smartfóny Samsung

Sorting high to low
    Click Text    Od najdrahšieho
    
Price sorting control
#Create List of prices
    ${elements_count}    Get Element Count    //div[contains(@class,'products__item')]
    
    FOR    ${counter}    IN RANGE    ${elements_count}
        ${element_num}    Evaluate    ${counter}+1
        ${xpath}    Set Variable    //div[contains(@class,'products__item')][${element_num}]//span[contains(@class,'number left')]
        ${price_txt}    Get Text    ${xpath}    between=???€
        ${price_txt2}    Remove String    ${price_txt}    ${SPACE}
        ${price_txt3}    Fetch From Left    ${price_txt2}    ,
        ${price_num}    Convert To Number    ${price_txt3}
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

Get Name of items
    [Arguments]    ${num_of_items}
    FOR    ${counter}    IN RANGE    ${num_of_items}
        ${element_num}    Evaluate    ${counter}+1
        ${name}    Get Text    //div[contains(@class,'products__item')][${element_num}]//div[contains(@class,'valign')]    between=???${SPACE}- 
        Append To List    ${names_items}    ${name}
    END
    Log To Console    ${names_items}

Add items to basket
#Add 3 most expensive items to basket 
    [Arguments]    ${num_of_items}                      
    FOR    ${counter}    IN RANGE    ${num_of_items}
        ${element_num}    Evaluate    ${counter}+1
        Click Element    //div[contains(@class,'products__item')][${element_num}]//button[contains(@class,'buy')]
        #IF    ($counter==3)
        #    BREAK
        #END
        Click Element    //a[contains(@data-dismiss,'modal')]
    END

Open basket
    Click Element    //span[contains(@class,'minicart')][1]//r-span[contains(@data-element,'cart')]
    Click Text    Prejsť    Celková suma

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