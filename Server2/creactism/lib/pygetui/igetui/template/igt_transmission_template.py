__author__ = 'wei'

from protobuf import *
import igt_base_template


class TransmissionTemplate(igt_base_template.BaseTemplate):
    def __init__(self):
        igt_base_template.BaseTemplate.__init__(self)
        self.transmissionType = 0
        self.transmissionContent = ""
        self.pushType = "TransmissionMsg"

    def getActionChains(self):

        #set actionChain
        actionChain1 = gt_req_pb2.ActionChain()
        actionChain1.actionId = 1
        actionChain1.type = gt_req_pb2.ActionChain.Goto
        actionChain1.next = 10030

        #appStartUp
        appStartUp = gt_req_pb2.AppStartUp()
        appStartUp.android = ""
        appStartUp.symbia = ""
        appStartUp.ios = ""

        #start up app
        actionChain2 = gt_req_pb2.ActionChain()
        actionChain2.actionId = 10030
        actionChain2.type = gt_req_pb2.ActionChain.startapp
        actionChain2.appid = ""
        actionChain2.autostart = (True if self.transmissionType == 1 else False)
        actionChain2.appstartupid.CopyFrom(appStartUp)
        actionChain2.failedAction = 100
        actionChain2.next = 100

        #end
        actionChain3 = gt_req_pb2.ActionChain()
        actionChain3.actionId = 100
        actionChain3.type = gt_req_pb2.ActionChain.eoa

        actionChains = [actionChain1, actionChain2, actionChain3]
        return actionChains

    def set3rdNotifyInfo(self, notify):
        if notify.getTitle() is None or notify.getContent() is None:
            raise Exception("notify title or content cannot be null")

        notifyInfo = gt_req_pb2.NotifyInfo()
        notifyInfo.title = notify.getTitle().decode("utf-8")
        notifyInfo.content = notify.getContent().decode("utf-8")
        if notify.getPayload() is not None:
            notifyInfo.payload = notify.getPayload().decode("utf-8")
        self.getPushInfo().notifyInfo.CopyFrom(notifyInfo)
        self.getPushInfo().validNotify = True

    def getTemplateId(self):
        """templateid support,you do not need to call this function explicitly"""
        return 4