#! /usr/bin/env python
# -*- coding: utf-8 -*- 
#
# test-changeDetail.py
#
# Created by ruibin.chow on 2017/12/04.
# Copyright (c) 2017年 ruibin.chow All rights reserved.
# 

"""

"""

import requests

url = "http://127.0.0.1:5000/service/quickTalk/account/change_detail"
data = {
    "user_uuid": "cea8b1c3aebe31823fa86e069de496b9",
    "detail":"通过dispatch_barrier_async添加的操作会暂时阻塞当前队列，即等待前面的并发操作都完成后执行该阻塞操作，待其完成后后面的并发操作才可继续。可以将其比喻为一根霸道的独木桥，是并发队列中的一个并发障碍点，或者说中间瓶颈，临时阻塞并独占。注意dispatch_barrier_async只有在并发队列中才能起作用，在串行队列中队列本身就是独木桥，将失去其意义。"
}

# response = requests.post(url=url, params=params, files=files)

r = requests.post(url=url, data=data)    

print r.text


if __name__ == '__main__':
    pass