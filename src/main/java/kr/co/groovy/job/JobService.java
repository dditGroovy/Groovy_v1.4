package kr.co.groovy.job;

import kr.co.groovy.enums.DutyKind;
import kr.co.groovy.enums.DutyProgress;
import kr.co.groovy.vo.EmployeeVO;
import kr.co.groovy.vo.JobDiaryVO;
import kr.co.groovy.vo.JobProgressVO;
import kr.co.groovy.vo.JobVO;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class JobService {
    final JobMapper mapper;

    public JobService(JobMapper mapper) {
        this.mapper = mapper;
    }

    public String getLeader(String emplId) {
        return mapper.getLeader(emplId);
    }

    public int insertDiary(JobDiaryVO jobDiaryVO) {
        return mapper.insertDiary(jobDiaryVO);
    }

    public EmployeeVO getInfoById(String emplId) {
        return mapper.getInfoById(emplId);
    }

    public List<JobDiaryVO> getDiaryByDept(String commonCodeDept) {
        return mapper.getDiaryByDept(commonCodeDept);
    }

    public List<JobDiaryVO> getDiaryByInfo(EmployeeVO employeeVO) {
        return mapper.getDiaryByInfo(employeeVO);
    }

    public JobDiaryVO getDiaryByDateAndId(JobDiaryVO jobDiaryVO) {
        return mapper.getDiaryByDateAndId(jobDiaryVO);
    }

    public int getMaxJobNo() {return mapper.getMaxJobNo();}

    public void insertJob(JobVO jobVO) {mapper.insertJob(jobVO);}

    public void insertJobProgress(JobProgressVO jobProgressVO) {mapper.insertJobProgress(jobProgressVO);}

    public List<JobVO> getAllJobById(String jobRequstEmplId) {
        List<JobVO> jobVOList = mapper.getAllJobById(jobRequstEmplId);
        for (JobVO jobVO : jobVOList) {
            jobVO.setCommonCodeDutyKind(DutyKind.getLabelByValue(jobVO.getCommonCodeDutyKind()));
        }
        return jobVOList;
    }

    public JobVO getJobByNo(int jobNo) {
        return mapper.getJobByNo(jobNo);
    }

    public List<JobVO> getAllReceiveJobById(String jobRecptnEmplId) {
        return mapper.getAllReceiveJobById(jobRecptnEmplId);
    }

    public JobVO getReceiveJobByNo(int jobNo) {
        return mapper.getReceiveJobByNo(jobNo);
    }

    public void updateJobStatus(JobProgressVO jobProgressVO) {
        mapper.updateJobStatus(jobProgressVO);
    }

    public void updateJobProgress(JobProgressVO jobProgressVO) {
        mapper.updateJobProgress(jobProgressVO);
    }

    public List<JobVO> getJobByDate(Map<String, Object> map) {
        return mapper.getJobByDate(map);
    }

    public List<JobVO> getJobByDateFilter(Map<String, Object> map) {
        return mapper.getJobByDateFilter(map);
    }

    List<String> getRequestYear(String jobRequestEmplId) {return mapper.getRequestYear(jobRequestEmplId); }

    List<String> getRequestMonth(Map<String, Object> map) {return mapper.getRequestMonth(map); }

    public JobVO getJobByNoAndId(JobProgressVO jobProgressVO) {
        JobVO jobVO = mapper.getJobByNoAndId(jobProgressVO);
        jobVO.setCommonCodeDutyKind(DutyKind.getLabelByValue(jobVO.getCommonCodeDutyKind()));
        List<JobProgressVO> jobProgressVOList = jobVO.getJobProgressVOList();
        for (JobProgressVO progressVO : jobProgressVOList) {
            progressVO.setCommonCodeDutyProgrs(DutyProgress.getLabelByValue(progressVO.getCommonCodeDutyProgrs()));
        }
        return jobVO;
    }

    public List<Map<String,Object>> dayOfWeek() {
        List<Map<String, Object>> weekly = new ArrayList<>();
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
        Date startDate = new Date(calendar.getTimeInMillis());
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd (E)");

        for (int i = 0; i < 5; i++) {
            String formattedDate = dateFormat.format(startDate);

            Map<String, Object> dayInfo = new HashMap<>();
            dayInfo.put("date", startDate);
            dayInfo.put("day", formattedDate.substring(formattedDate.indexOf("(") + 1, formattedDate.indexOf(")")));

            weekly.add(dayInfo);
            calendar.add(Calendar.DATE, 1);
            startDate = new Date(calendar.getTimeInMillis());
        }
        return weekly;
    }

    public List<List<JobVO>> jobListByDate(String emplId) {
        List<List<JobVO>> jobListByDate = new ArrayList<>();
        List<Map<String, Object>> dayOfWeek = dayOfWeek();
        for (Map<String, Object> map : dayOfWeek) {
            Map<String, Object> jobMap = new HashMap<>();
            jobMap.put("jobRecptnEmplId", emplId);
            Date date = (Date) map.get("date");
            jobMap.put("date", date);
            List<JobVO> jobByDate = getJobByDate(jobMap);
            for (JobVO jobVO : jobByDate) {
                String dutyKind = DutyKind.getLabelByValue(jobVO.getCommonCodeDutyKind());
                jobVO.setCommonCodeDutyKind(dutyKind);
                List<JobProgressVO> jobProgressVOList = jobVO.getJobProgressVOList();
                for (JobProgressVO jobProgressVO : jobProgressVOList) {
                    String dutyProgress = DutyProgress.getLabelByValue(jobProgressVO.getCommonCodeDutyProgrs());
                    jobProgressVO.setCommonCodeDutyProgrs(dutyProgress);
                }
            }
            jobListByDate.add(jobByDate);
        }
        return jobListByDate;
    }
}
