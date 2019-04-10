FROM python:3.7.2-stretch

MAINTAINER "Hammad Ahmed" <hamahmed@altayer.com>

LABEL name="Docker build for testing using the robot framework"

RUN apt-get update
RUN apt-get install -y build-essential libssl-dev libffi-dev figlet
RUN apt-get install -y gcc phantomjs
RUN apt-get install -y xvfb zip wget
RUN apt-get install ca-certificates
RUN apt-get install ntpdate

RUN apt-get update && apt-get install -y libnss3-dev libxss1 libappindicator3-1 libindicator7 gconf-service libgconf-2-4 libpango1.0-0 xdg-utils fonts-liberation libasound2 lsb-release

RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz
RUN tar xvzf geckodriver-v0.24.0-linux64.tar.gz
RUN rm geckodriver-v0.24.0-linux64.tar.gz
RUN cp geckodriver /usr/local/bin && chmod +x /usr/local/bin/geckodriver

RUN apt-get clean autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "Europe/Helsinki" > /etc/timezone \
    && rm /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` \
    && mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION \
    && curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip \
    && unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION  \
    && rm /tmp/chromedriver_linux64.zip \
    && chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver \
    && ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver \
    && curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get -yqq update \
    && apt-get -yqq install google-chrome-stable \
    && rm -rf /var/lib/apt/lists/* \
    && chmod a+x /usr/bin/google-chrome

ENV DBUS_SESSION_BUS_ADDRESS /dev/null
ENV DISPLAY=:99

COPY requirements.txt /tmp/
RUN pip -V
RUN pip install --upgrade pip
RUN pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt

ENTRYPOINT ["/bin/bash", "/suite/execution/scripts/async.sh"]
CMD ["/execution/scripts/suite_runner.sh"]