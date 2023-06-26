
select 
user_id
,session_id
,class_name
,attendance_start_time
,duration
,attendance_type

from (select
user_id
,session_id
,class_name
,day
,min(attendance_start_time) attendance_start_time
,sum(coalesce(duration, 0)) duration
,max(attendance_type) attendance_type 


from (
select 
userid user_id, 
session_id, 
class_name, 
day,
FROM_UNIXTIME(init_ts) as attendance_start_time, 
cast (end_ts-init_ts as decimal (10,0))/60 duration, 
"lobby_attendance" as attendance_type 

from  (
  select sessionid, userid, day,
  max(UNIX_TIMESTAMP(STR_TO_DATE(timestamp, '%Y-%m-%dT%H:%i:%s.%fZ'))) end_ts,
  min(UNIX_TIMESTAMP(STR_TO_DATE(timestamp, '%Y-%m-%dT%H:%i:%s.%fZ'))) init_ts
       from (select sessionid, userid, day(from_unixtime(UNIX_TIMESTAMP(STR_TO_DATE(timestamp, '%Y-%m-%dT%H:%i:%s.%fZ')))) day 
	   , timestamp from lobby_events) c group by sessionid, userid, day) a 
       inner join session_details b
                          on a.sessionid=b.session_id
union

select 
userid user_id, 
session_id, 
class_name, 
day,
FROM_UNIXTIME(init_ts) as attendance_start_time, 
cast (end_ts-init_ts as decimal (10,0))/60 duration,  
"meeting_launch" as attendance_type 

from  (
  select sessionid, userid, day,
  max(UNIX_TIMESTAMP(STR_TO_DATE(timestamp, '%Y-%m-%dT%H:%i:%s.%fZ'))) end_ts,
  min(UNIX_TIMESTAMP(STR_TO_DATE(timestamp, '%Y-%m-%dT%H:%i:%s.%fZ'))) init_ts
       from (select sessionid, userid, day(from_unixtime(UNIX_TIMESTAMP(STR_TO_DATE(timestamp, '%Y-%m-%dT%H:%i:%s.%fZ')))) day 
	   , timestamp from meeting_launch_events) c group by sessionid, userid, day) a 
       inner join session_details b
                          on a.sessionid=b.session_id)
                          
               a                          

                          group by 1,2,3,4
                          order by duration desc ) a


    