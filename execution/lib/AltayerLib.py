import csv
import os
import random
import datetime
import requests
import json
import string
import re

__version__ = '1.0.1'


class AltayerLib(object):
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    my_dict = []

    def generate_website_url(self, version, language, country, brand):

        dir_path = os.getcwd()

        with open(dir_path + '/suite/execution/config/url_generator.json') as f:
            self.my_dict = json.load(f)

        url = str(self.my_dict[brand]['frontend'][version][language][country])
        return url

    def generate_admin_url(self, brand):

        dir_path = os.getcwd()

        with open(dir_path + '/suite/execution/config/url_generator.json') as f:
            self.my_dict = json.load(f)

        url = str(self.my_dict[brand]['admin'])
        return url

    def create_file_for_order(self):

        dir_path = os.getcwd()
        with open(dir_path + '/results/bulk-orders.csv', 'w+') as csv_file:
            file_writer = csv.writer(csv_file,
                                     delimiter=',',
                                     quotechar='|',
                                     quoting=csv.QUOTE_MINIMAL)
            file_writer.writerow(['Version',
                                  'Language',
                                  'Country',
                                  'Brand',
                                  'Order_id',
                                  'Type',
                                  'Time'])

    def get_random_domain(self, domains):

        return random.choice(domains)

    def get_random_name(self, letters, length):

        return ''.join(random.choice(letters) for i in range(length))

    def generate_random_emails(self, nb, length):

        letters = string.ascii_lowercase[:12]
        domains = ["hotmail.com", "gmail.com", "aol.com", "mail.com", "mail.kz", "yahoo.com"]

        return [self.get_random_name(letters, length)
                + '+test'
                + '@'
                + self.get_random_domain(domains) for i in range(nb)]

    def save_customer_info(self, customer):

        dir_path = os.getcwd()
        my_dict = customer
        print (dir_path + "this was executed")

        filename = "suite/user-info-csv/mycsvfile.csv"
        dirname = os.path.dirname(filename)
        if not os.path.exists(dirname):
            os.makedirs(dirname)

        with open(dir_path + 'suite/user-info-csv/mycsvfile.csv', 'w+') as f:
            w = csv.DictWriter(f, my_dict.keys())
            w.writeheader()
            w.writerow(my_dict)

    def get_customer_info(self, required_info):

        dir_path = os.getcwd()
        with open(dir_path + 'suite/user-info-csv/mycsvfile.csv', 'r') as f:
            reader = csv.reader(f)
            user_rows = list(reader)

        row1 = user_rows[0]
        row2 = user_rows[1]
        user_data = dict(zip(row1, row2))

        if required_info == 'email':
            return user_data['email']
        elif required_info == 'firstname':
            return user_data['firstname']
        elif required_info == 'lastname':
            return user_data['lastname']
        else:
            return user_data

    def write_to_log(self, log):

        now = datetime.datetime.now()
        text_file = open("altayer_error_logs.txt", "a+")
        text_file.write("%s  --  %s\n" % (str(now), log.encode("utf-8")))
        text_file.close()

    def cleanhtml(self, raw_html):
        raw_html = raw_html.decode('utf-8')
        clean_raw = re.compile('<.*?>')
        clean_text = re.sub(clean_raw, '', raw_html)
        return clean_text

    def get_browser_stack_build_id(self, user_name, access_key):

        self.write_to_log('-- getting build id --')

        url = "http://" \
              + user_name \
              + ":" \
              + access_key \
              + "@api.browserstack.com/automate/builds/"

        r = requests.get(url)
        loaded_json = json.loads(r.text)

        if loaded_json[0]["automation_build"]["hashed_id"] is not None:
            self.write_to_log('build id ' + loaded_json[0]["automation_build"]["hashed_id"])
            return loaded_json[0]["automation_build"]["hashed_id"]
        else:
            self.write_to_log('Error getting build id '
                              + loaded_json[0]["automation_build"]["hashed_id"])
