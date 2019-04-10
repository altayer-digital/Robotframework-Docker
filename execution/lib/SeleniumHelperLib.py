from robot.libraries.BuiltIn import BuiltIn
import time


class SeleniumHelperLib(object):

    def scroll_to_element(self, elem):

        se2lib = BuiltIn().get_library_instance('Selenium2Library')
        browser = se2lib._current_browser()
        browser.execute_script("arguments[0].scrollIntoView({block: 'center'});", elem)

    def wait_for_ajax(self):

        print("wait for ajax...")
        se2lib = BuiltIn().get_library_instance('Selenium2Library')
        browser = se2lib._current_browser()
        response = browser.execute_script("return jQuery.active == 0")
        while response is False:
            time.sleep(0.5)
            if browser.execute_script("return jQuery.active == 0") is True:
                break
