package kr.co.groovy.job;

import kr.co.groovy.vo.EmployeeVO;
import kr.co.groovy.vo.JobDiaryVO;
import kr.co.groovy.vo.JobProgressVO;
import kr.co.groovy.vo.JobVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface JobMapper {
    String getLeader(String emplId);

    int insertDiary(JobDiaryVO jobDiaryVO);

    EmployeeVO getInfoById(String emplId);

    List<JobDiaryVO> getDiaryByDept(String commonCodeDept);

    List<JobDiaryVO> getDiaryByInfo(EmployeeVO employeeVO);

    JobDiaryVO getDiaryByDateAndId(JobDiaryVO jobDiaryVO);

    int getMaxJobNo();

    void insertJob(JobVO jobVO);

    void insertJobProgress(JobProgressVO jobProgressVO);

    List<JobVO> getAllJobById(String jobRequstEmplId);

    JobVO getJobByNo(int jobNo);

    List<JobVO> getAllReceiveJobById(String jobRecptnEmplId);

    JobVO getReceiveJobByNo(int jobNo);

    void updateJobStatus(JobProgressVO jobProgressVO);

    void updateJobProgress(JobProgressVO jobProgressVO);

    void updateJob(JobVO jobVO);

    List<JobVO> getJobByDate(Map<String, Object> map);

    List<JobVO> getJobByDateFilter(Map<String, Object> map);

    JobVO getJobByNoAndId(JobProgressVO jobProgressVO);

    List<String> getRequestYear(String jobRequstEmplId);

    List<String> getRequestMonth(Map<String, Object> map);

    List<JobVO> getReceiveJobToHome(String emplId);
}
