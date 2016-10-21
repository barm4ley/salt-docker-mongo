schedule_mongo_backup_job:
  schedule.present:
    - name: mongo_backup_job
    - function: state.apply
    - job_args:
      - mongo.make_backup
    - when: 1:00am
    #- seconds: 120

