package com.xxl.job.xxljobadmin.core.alarm;

import com.xxl.job.xxljobadmin.core.model.XxlJobInfo;
import com.xxl.job.xxljobadmin.core.model.XxlJobLog;

/**
 * @author xuxueli 2020-01-19
 */
public interface JobAlarm {

    /**
     * job alarm
     *
     * @param info
     * @param jobLog
     * @return
     */
    public boolean doAlarm(XxlJobInfo info, XxlJobLog jobLog);

}
