unschedule_mongo_backup_job:
  schedule.absent:
    - name: mongo_backup_job
