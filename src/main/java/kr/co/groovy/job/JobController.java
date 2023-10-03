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
        jobDiaryVO = service.getDiaryByDateAndId(date, id);
        model.addAttribute("vo", jobDiaryVO);
        return "employee/job/jobDiaryRead";
    }

    @PostMapping("/insertDiary")
    public String insertDiary(@ModelAttribute JobDiaryVO jobDiaryVO, Principal principal) {
        try {
            service.insertDiary(jobDiaryVO, principal.getName());
            return "redirect:/job/jobDiary";
        } catch (Exception e) {
            return "redirect:/job/jobDiary";
        }
    }

    @GetMapping("/jobDiary")
    public String jobDiary(Principal principal, Model model) {
        List<JobDiaryVO> list = service.getJobDiaryVOList(principal);
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
        service.insertxJob(jobVO, jobProgressVO, principal.getName());
    }

    @GetMapping("/getJobByNo")
    @ResponseBody
    public JobVO getJobByNo(int jobNo) {
        JobVO jobVO = service.getJobByNo(jobNo);
        return jobVO;
    }

    @GetMapping("/getReceiveJobByNo")
    @ResponseBody
    public JobVO getReceiveJobByNo(int jobNo) {
        JobVO jobVO = service.getReceiveJobByNo(jobNo);
        return jobVO;
    }

    @PutMapping("/updateJobStatus")
    @ResponseBody
    public void updateJobStatus(@RequestBody JobProgressVO jobProgressVO, Principal principal) {
        service.updateJobStatus(jobProgressVO, principal.getName());
    }

    @GetMapping("/getJobByNoAndId")
    @ResponseBody
    public JobVO getJobByNoAndId(int jobNo, Principal principal) {
        return service.getJobByNoAndId(jobNo, principal.getName());
    }

    @PutMapping("/updateJobProgress")
    @ResponseBody
    public void updateJobProgress(Principal principal, @RequestBody JobProgressVO jobProgressVO) {
        service.updateJobProgress(jobProgressVO, principal.getName());
    }

    @PutMapping("/updateJob")
    @ResponseBody
    public void updateJob(@RequestBody JobVO jobVO) {
        service.updateJob(jobVO);
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
    public List<String> getRequestMonth(String year, Principal principal) {
        return service.getRequestMonth(year, principal.getName());
    }

    @GetMapping("/getJobByDateFilter")
    @ResponseBody
    public List<JobVO> getJobByDateFilter(@RequestParam Map<String, Object> data, Principal principal) {
        data.put("jobRequstEmplId", principal.getName());
        return service.getJobByDateFilter(data);
    }
}
