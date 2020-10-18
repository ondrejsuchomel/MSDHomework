import sched
import time
import s3upload
s = sched.scheduler(time.time, time.sleep)

s.enter(36, 1, run_hourly_download, (s,)) #TODO change to 3600
s.run()