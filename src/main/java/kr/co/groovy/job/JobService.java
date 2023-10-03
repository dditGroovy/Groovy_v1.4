package kr.co.groovy.job;

import kr.co.groovy.enums.ClassOfPosition;
import kr.co.groovy.enums.DutyKind;
import kr.co.groovy.enums.DutyProgress;
import kr.co.groovy.enums.DutyStatus;
import kr.co.groovy.vo.EmployeeVO;
import kr.co.groovy.vo.JobDiaryVO;
import kr.co.groovy.vo.JobProgressVO;
import kr.co.groovy.vo.JobVO;
import org.springframework.stereotype.Service;

import java.security.Principal;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class JobService {
    final JobMapper mapper;

    public JobService(JobMapper mapper) {
        this.mapper = mapper;
    }

    public int insertDiary(JobDiaryVO jobDiaryVO, String emplId) {
        jobDiaryVO.setJobDiaryWrtingEmplId(emplId);
        String recptnEmplId = mapper.getLeader(emplId);
        jobDiaryVO.setJobDiaryRecptnEmplId(recptnEmplId);
        return mapper.insertDiary(jobDiaryVO);
    }

    public List<JobDiaryVO> getJobDiaryVOList(Principal principal) {
        EmployeeVO employeeVO;
        List<JobDiaryVO> list = new ArrayList<>();
        String emplId = principal.getName();
        employeeVO = mapper.getInfoById(emplId);
        employeeVO.setEmplId(emplId);
        try {
            if (employeeVO.getCommonCodeClsf().equals(ClassOfPosition.CLSF011.name())) {
                list = mapper.getDiaryByDept(employeeVO.getCommonCodeDept());
            } else {
                list = mapper.getDiaryByInfo(employeeVO);
            }
        } catch (Exception e) {

        }
        return list;
    }

    public List<JobDiaryVO> getDiaryByDept(String commonCodeDept) {
        return mapper.getDiaryByDept(commonCodeDept);
    }

    public List<JobDiaryVO> getDiaryByInfo(EmployeeVO employeeVO) {
        return mapper.getDiaryByInfo(employeeVO);
    }

    public JobDiaryVO getDiaryByDateAndId(String date, String id) {
        JobDiaryVO jobDiaryVO = new JobDiaryVO();
        jobDiaryVO.setJobDiaryReportDate(date);
        jobDiaryVO.setJobDiaryWrtingEmplId(id);
        JobDiaryVO vo = mapper.getDiaryByDateAndId(jobDiaryVO);
        vo.setJobDiaryReportDate(date);
        return vo;
    }

    public void insertxJob(JobVO jobVO, JobProgressVO jobProgressVO, String emplId) {
        int maxJobNo = mapper.getMaxJobNo() + 1;
        jobVO.setJobNo(maxJobNo);
        jobVO.setJobRequstEmplId(emplId);
        mapper.insertJob(jobVO);

        jobProgressVO.setJobNo(maxJobNo);
        if (jobVO.getSelectedEmplIds() != null) { //나 -> 다른이
            List<String> selectedEmplIds = jobVO.getSelectedEmplIds();
            for (String selectedEmplId : selectedEmplIds) {
                jobProgressVO.setJobRecptnEmplId(selectedEmplId);
                jobProgressVO.setCommonCodeDutySttus(DutyStatus.getValueOfByLabel("대기"));
                mapper.insertJobProgress(jobProgressVO);
            }
        } else { //나 -> 나
            jobProgressVO.setJobRecptnEmplId(emplId);
            jobProgressVO.setCommonCodeDutySttus(DutyStatus.getValueOfByLabel("승인"));
            mapper.insertJobProgress(jobProgressVO);
        }
    }

    public List<JobVO> getAllJobById(String jobRequstEmplId) {
        List<JobVO> jobVOList = mapper.getAllJobById(jobRequstEmplId);
        for (JobVO jobVO : jobVOList) {
            jobVO.setCommonCodeDutyKind(DutyKind.getLabelByValue(jobVO.getCommonCodeDutyKind()));
        }
        return jobVOList;
    }

    public JobVO getJobByNo(int jobNo) {
        JobVO jobVO = mapper.getJobByNo(jobNo);
        List<JobProgressVO> jobProgressVOList = jobVO.getJobProgressVOList();
        for (JobProgressVO jobProgressVO : jobProgressVOList) {
            String dutyStatus = DutyStatus.getLabelByValue(jobProgressVO.getCommonCodeDutySttus());
            String dutyProgress = DutyProgress.getLabelByValue(jobProgressVO.getCommonCodeDutyProgrs());
            jobProgressVO.setCommonCodeDutySttus(dutyStatus);
            jobProgressVO.setCommonCodeDutyProgrs(dutyProgress);
        }
        return jobVO;
    }

    public List<JobVO> getAllReceiveJobById(String jobRecptnEmplId) {
        return mapper.getAllReceiveJobById(jobRecptnEmplId);
    }

    public JobVO getReceiveJobByNo(int jobNo) {
        JobVO jobVO = mapper.getReceiveJobByNo(jobNo);
        String dutyKind = DutyKind.getLabelByValue(jobVO.getCommonCodeDutyKind());
        jobVO.setCommonCodeDutyKind(dutyKind);
        return jobVO;
    }

    public void updateJobStatus(JobProgressVO jobProgressVO, String emplId) {
        jobProgressVO.setJobRecptnEmplId(emplId);
        String dutyStatus = jobProgressVO.getCommonCodeDutySttus();
        jobProgressVO.setCommonCodeDutySttus(DutyStatus.getValueOfByLabel(dutyStatus));
        mapper.updateJobStatus(jobProgressVO);
    }

    public void updateJobProgress(JobProgressVO jobProgressVO, String emplId) {
        jobProgressVO.setJobRecptnEmplId(emplId);
        mapper.updateJobProgress(jobProgressVO);
    }

    public void updateJob(JobVO jobVO) {
        jobVO.setCommonCodeDutyKind(DutyKind.getValueOfByLabel(jobVO.getCommonCodeDutyKind()));
        mapper.updateJob(jobVO);
    }

    public List<JobVO> getJobByDate(Map<String, Object> map) {
        return mapper.getJobByDate(map);
    }

    public List<JobVO> getJobByDateFilter(Map<String, Object> map) {
        List<JobVO> jobVOList = mapper.getJobByDateFilter(map);
        for (JobVO jobVO : jobVOList) {
            jobVO.setCommonCodeDutyKind(DutyKind.getLabelByValue(jobVO.getCommonCodeDutyKind()));
        }
        return jobVOList;
    }

    public List<String> getRequestYear(String jobRequestEmplId) {
        return mapper.getRequestYear(jobRequestEmplId);
    }

    public List<String> getRequestMonth(String year, String jobRequestEmplId) {
        Map<String, Object> map = new HashMap<>();
        map.put("year", year);
        map.put("jobRequestEmplId", jobRequestEmplId);
        return mapper.getRequestMonth(map);
    }

    public List<JobVO> getReceiveJobToHome(String emplId) {
        List<JobVO> jobVOList = mapper.getReceiveJobToHome(emplId);
        for (JobVO jobVO : jobVOList) {
            List<JobProgressVO> jobProgressVOList = jobVO.getJobProgressVOList();
            for (JobProgressVO jobProgressVO : jobProgressVOList) {
                jobProgressVO.setCommonCodeDutyProgrs(DutyProgress.getLabelByValue(jobProgressVO.getCommonCodeDutyProgrs()));
            }
        }
        return jobVOList;
    }

    public JobVO getJobByNoAndId(int jobNo, String emplId) {
        JobProgressVO jobProgressVO = new JobProgressVO();
        jobProgressVO.setJobNo(jobNo);
        jobProgressVO.setJobRecptnEmplId(emplId);
        JobVO jobVO = mapper.getJobByNoAndId(jobProgressVO);
        jobVO.setCommonCodeDutyKind(DutyKind.getLabelByValue(jobVO.getCommonCodeDutyKind()));
        List<JobProgressVO> jobProgressVOList = jobVO.getJobProgressVOList();
        for (JobProgressVO progressVO : jobProgressVOList) {
            progressVO.setCommonCodeDutyProgrs(DutyProgress.getLabelByValue(progressVO.getCommonCodeDutyProgrs()));
        }
        return jobVO;
    }

    public List<Map<String, Object>> dayOfWeek() {
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
