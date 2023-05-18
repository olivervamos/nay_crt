from QWeb.keywords.element import get_element_count
from QWeb.keywords.text import get_text
from robot.libraries.String import String
import logging


def price_sorting_control(): #Create List of prices
    elements_count = get_element_count("//div[contains(@class,'products__item')]")
    prices = []
    for i in range(elements_count):
        locator = "//div[contains(@class,'products__item')][{}]//span[contains(@class,'number left')]".format(i+1)
        price_txt = get_text(locator, between="???€")
        price_txt2 = price_txt.replace(' ','')
        price_txt3 = String.fetch_from_left(String, price_txt2, ',')
        price_num = float(price_txt3)
        prices.append(price_num)

    for i in range(elements_count-1):
        logging.info('toto je prvy index {} a toto je druhy index {}'.format(prices[i], prices[i+1]))
        if prices[i] < prices[i+1]:
            raise AssertionError('sorting of items is not corect form high to low')