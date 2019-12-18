#coding=utf-8
import pandas as pd
from datetime import datetime
import time
import codecs
import sys
reload(sys)
sys.setdefaultencoding('utf8')

def getQuarter(month):
    month = int(month)
    if month >= 1 and month <= 3:
        quarter = "一季度"
    elif month >= 4 and month <= 6:
        quarter = "二季度"
    elif month >= 7 and month <= 9:
        quarter = "三季度"
    elif month >= 10 and month <= 12:
        quarter = "四季度"
    quarter = str(quarter)
    return quarter

def getDate():
    beginDate = sys.argv[1]
    endDate = sys.argv[2]
    # endDate = '2007-1-3 00:00'
    for _ in list(pd.date_range(start=beginDate, end=endDate, freq='Min')):
        yield datetime.strftime(_, '%Y-%m-%d-%H-%M')

def main():
    output = codecs.open(sys.argv[3]+"/time_dimension.txt", "wb", "utf-8")
    for _ in getDate():
        timestemp = time.mktime(time.strptime(_, "%Y-%m-%d-%H-%M"))
        time_list = _.split("-")
        year = time_list[0]
        month = time_list[1]
        day = time_list[2]
        hour = time_list[3]
        minute = time_list[4]
        id = year + "-" + month + "-" + day + " " + hour + ":" + minute
        datetime_output = id + ":00"
        quarter = getQuarter(month)
        # print(id,quarter)

        str_output = "\t".join([id,year,month,day,hour, minute,datetime_output,quarter, str(timestemp)])
        # print(str_output)
        output.write(str_output+"\n")

    output.close()


if __name__ == "__main__":
    main()
