FROM python:alpine3.19
WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt  && adduser -D adenilson
USER adenilson
EXPOSE 5000
COPY . . 
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000", "--reload"]