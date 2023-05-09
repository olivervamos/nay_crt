*** Settings ***
Library    QWeb
Library    String
Library    Collections
Library    QForce

*** Variables ***

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
    ${price_list}    Create List
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
           Log    ${ListItem1}' and '${ListItem2}
       END

Price sorting control in basket
#Create List of prices
    ${elements_count}    Get Element Count    //div[contains(@class,'inventory_item_price')]
    ${price_list_basket}    Create List
    FOR    ${counter}    IN RANGE    ${elements_count}
        ${element_num}    Evaluate    ${counter}+1
        ${xpath}    Set Variable    //div[contains(@class,'cart__products__row ')][${element_num}]//r-span[contains(@data-type,'finalPriceVat')]
        ${price_txt}    Get Text    ${xpath}    between=???€
        ${price_txt2}    Remove String    ${price_txt}    ${SPACE}
        ${price_txt3}    Fetch From Left    ${price_txt2}    ,
        ${price_num}    Convert To Number    ${price_txt3}
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
        Log    ${ListItem1}' and '${ListItem2}
    END     

Get Names of items
    [Arguments]    ${num_of_items}
    ${NAMES_ITEMS}    Create List
    FOR    ${counter}    IN RANGE    ${num_of_items}
        ${element_num}    Evaluate    ${counter}+1
        ${name}    Get Text    //div[contains(@class,'products__item')][${element_num}]//div[contains(@class,'valign')]    between=???${SPACE}- 
        Append To List    ${NAMES_ITEMS}    ${name}
    END
    Set Test Variable    ${NAMES_ITEMS}
    Log    List of items names after sorting> ${NAMES_ITEMS}

Get Names of items in basket
    [Arguments]    ${num_of_items}
    ${NAMES_ITEMS_BASKET}    Create List
    FOR    ${counter}    IN RANGE    ${num_of_items}
        ${element_num}    Evaluate    ${counter}+1
        ${name}    Get Text    //div[contains(@class,'cart__products__row ')][${element_num}]//strong 
        Append To List    ${NAMES_ITEMS_BASKET}    ${name}
    END
    Set Test Variable    ${NAMES_ITEMS_BASKET}
    Log    List of items names in basket> ${NAMES_ITEMS_BASKET}

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

Delete from basket and verify remove
    ${delete_item}    Get From List    ${NAMES_ITEMS_BASKET}    0
    ClickElement    //i[contains(@class,'ico--x')]
    #UseModal
    ClickElement    //button[contains(@class,'confirm')]
    VerifyNoText    ${delete_item}
    Log    ${delete_item}