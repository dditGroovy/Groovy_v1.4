package kr.co.groovy.job;

import kr.co.groovy.common.CommonService;
import kr.co.groovy.commute.CommuteService;
import kr.co.groovy.enums.*;
import kr.co.groovy.vo.EmployeeVO;
import kr.co.groovy.vo.JobDiaryVO;
import kr.co.groovy.vo.JobProgressVO;
import kr.co.groovy.vo.JobVO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/job")
public class JobController {
    final JobService service;
    final CommonService commonService;
    final CommuteService commuteService;

    public JobController(JobService service, CommonService commonService, CommuteService commuteService) {
        this.service = service;
        this.commonService = commonService;
        this.commuteService = commuteService;
    }

    //업무일지
    @GetMapping("/write")
    public String jobDiaryWrite() {
        return "employee/job/jobDiaryWrite";
    }

    @GetMapping("/read")
    public String jobDiaryRead(String date, String id, JobDiaryVO jobDiaryVO, Model model) {
        jobDiaryVO.setJobDiaryReportDate(date);
        jobDiaryVO.setJobDiaryWrtingEmplId(id);
        jobDiaryVO = service.getDiaryByDateAndId(jobDiaryVO);
        jobDiaryVO.setJobDiaryReportDate(date);
        model.addAttribute("vo", jobDiaryVO);
        return "employee/job/jobDiaryRead";
    }

    @PostMapping("/insertDiary")
    public String insertDiary(@ModelAttribute JobDiaryVO jobDiaryVO, Principal principal, Model model) {
        String emplId = principal.getName();
        jobDiaryVO.setJobDiaryWrtingEmplId(emplId);

        try {
            String recptnEmplId = service.getLeader(emplId);
            jobDiaryVO.setJobDiaryRecptnEmplId(recptnEmplId);
            service.insertDiary(jobDiaryVO);
            return "redirect:/job/jobDiary";
        } catch (Exception e) {
            return "redirect:/job/jobDiary";
        }
    }

    @GetMapping("/jobDiary")
    public String jobDiary(EmployeeVO employeeVO, Principal principal, Model model) {
        List<JobDiaryVO> list = new ArrayList<>();
        String emplId = principal.getName();
        employeeVO = service.getInfoById(emplId);
        employeeVO.setEmplId(emplId);
        try {
            if (employeeVO.getCommonCodeClsf().equals(ClassOfPosition.CLSF012.name())) {
                list = service.getDiaryByDept(employeeVO.getCommonCodeDept());
            } else {
                list = service.getDiaryByInfo(employeeVO);
            }
        } catch (Exception e) {

        }
        model.addAttribute("list", list);
        return "employee/job/jobDiary";
    }

    //조직도
    @GetMapping("/jobOrgChart")
    public String jobOrgChart(Model model) {
        List<String> departmentCodes = Arrays.asList("DEPT010", "DEPT011", "DEPT012", "DEPT013", "DEPT014", "DEPT015");
        for (String deptCode : departmentCodes) {
            List<EmployeeVO> deptEmployees = commonService.loadOrgChart(deptCode);
            for (EmployeeVO vo : deptEmployees) {
                vo.setCommonCodeDept(Department.valueOf(vo.getCommonCodeDept()).label());
                vo.setCommonCodeClsf(ClassOfPosition.valueOf(vo.getCommonCodeClsf()).label());
            }
            model.addAttribute(deptCode + "List", deptEmployees);
        }
        return "/employee/job/jobOrgChart";
    }

    //내 할 일
    @GetMapping("/main")
    public String jobMain(Principal principal, Model model) {
        String emplId = principal.getName();
        List<JobVO> requestJobList = service.getAllJobById(emplId);
        List<JobVO> receiveJobList = service.getAllReceiveJobById(emplId);

        List<Map<String, Object>> dayOfWeek = service.dayOfWeek();
        List<List<JobVO>> jobListByDate = service.jobListByDate(emplId);

        model.addAttribute("dayOfWeek", dayOfWeek);
        model.addAttribute("requestJobList", requestJobList);
        model.addAttribute("receiveJobList", receiveJobList);
        model.addAttribute("jobListByDate", jobListByDate);

        return "employee/job/job";
    }

    @PostMapping("/insertJob")
    @ResponseBody
    public void insertJob(JobVO jobVO, JobProgressVO jobProgressVO, Principal principal) {
        int maxJobNo = service.getMaxJobNo() + 1;
        String emplId = principal.getName();
        jobVO.setJobNo(maxJobNo);
        jobVO.setJobRequstEmplId(emplId);
        service.insertJob(jobVO);

        jobProgressVO.setJobNo(maxJobNo);
        if (jobVO.getSelectedEmplIds() != null) { //나 -> 다른이
            List<String> selectedEmplIds = jobVO.getSelectedEmplIds();
            for (String selectedEmplId : selectedEmplIds) {
                jobProgressVO.setJobRecptnEmplId(selectedEmplId);
                jobProgressVO.setCommonCodeDutySttus(DutyStatus.getValueOfByLabel("대기"));
                service.insertJobProgress(jobProgressVO);
            }
        } else { //나 -> 나
            jobProgressVO.setJobRecptnEmplId(emplId);
            jobProgressVO.setCommonCodeDutySttus(DutyStatus.getValueOfByLabel("승인"));
            service.insertJobProgress(jobProgressVO);
        }
    }

    @GetMapping("/getJobByNo")
    @ResponseBody
    public JobVO getJobByNo(int jobNo) {
        JobVO jobVO = service.getJobByNo(jobNo);
        List<JobProgressVO> jobProgressVOList = jobVO.getJobProgressVOList();
        for (JobProgressVO jobProgressVO : jobProgressVOList) {
            String dutyStatus = DutyStatus.getLabelByValue(jobProgressVO.getCommonCodeDutySttus());
            String dutyProgress = DutyProgress.getLabelByValue(jobProgressVO.getCommonCodeDutyProgrs());
            jobProgressVO.setCommonCodeDutySttus(dutyStatus);
            jobProgressVO.setCommonCodeDutyProgrs(dutyProgress);
        }
        return jobVO;
    }

    @GetMapping("/getReceiveJobByNo")
    @ResponseBody
    public JobVO getReceiveJobByNo(int jobNo) {
        JobVO jobVO = service.getReceiveJobByNo(jobNo);
        String dutyKind = DutyKind.getLabelByValue(jobVO.getCommonCodeDutyKind());
        jobVO.setCommonCodeDutyKind(dutyKind);
        return jobVO;
    }

    @PutMapping("/updateJobStatus")
    @ResponseBody
    public void updateJobStatus(@RequestBody JobProgressVO jobProgressVO, Principal principal) {
        jobProgressVO.setJobRecptnEmplId(principal.getName());
        String dutyStatus = jobProgressVO.getCommonCodeDutySttus();
        jobProgressVO.setCommonCodeDutySttus(DutyStatus.getValueOfByLabel(dutyStatus));

        service.updateJobStatus(jobProgressVO);
    }

    @GetMapping("/getJobByNoAndId")
    @ResponseBody
    public JobVO getJobByNoAndId(int jobNo, Principal principal, JobProgressVO jobProgressVO) {
        String emplId = principal.getName();
        jobProgressVO.setJobNo(jobNo);
        jobProgressVO.setJobRecptnEmplId(emplId);
        return service.getJobByNoAndId(jobProgressVO);
    }

    @PutMapping("/updateJobProgress")
    @ResponseBody
    public void updateJobProgress(Principal principal, @RequestBody JobProgressVO jobProgressVO) {
        String emplId = principal.getName();
        jobProgressVO.setJobRecptnEmplId(emplId);
        service.updateJobProgress(jobProgressVO);
    }

    //요청한 업무 내역
    @GetMapping("/request")
    public String requestMain(Principal principal, Model model) {
        List<JobVO> jobList = service.getAllJobById(principal.getName());
        model.addAttribute("jobList", jobList);
        return "employee/job/jobRequestList";
    }

    @GetMapping("/getRequestYear")
    @ResponseBody
    public List<String> getRequestYear(Principal principal) {
        return service.getRequestYear(principal.getName());
    }

    @GetMapping("/getRequestMonth")
    @ResponseBody
    public List<String> getRequestMonth(String year, Principal principal, Map<String, Object> map) {
        map.put("year", year);
        map.put("jobRequestEmplId", principal.getName());
        return service.getRequestMonth(map);
    }

    @GetMapping("/getJobByDateFilter")
    @ResponseBody
    public List<JobVO> getJobByDateFilter(@RequestParam Map<String, Object> data, Principal principal) {
        data.put("jobRequstEmplId", principal.getName());
        return service.getJobByDateFilter(data);
    }
}
