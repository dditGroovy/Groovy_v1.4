package kr.co.groovy.alarm;

import kr.co.groovy.employee.EmployeeService;
import kr.co.groovy.enums.Department;
import kr.co.groovy.vo.AlarmVO;
import kr.co.groovy.vo.EmployeeVO;
import kr.co.groovy.vo.NotificationVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@Controller
@Slf4j
@RequestMapping("/alarm")
public class AlarmController {
    final EmployeeService employeeService;
    final AlarmService service;

    public AlarmController(EmployeeService employeeService, AlarmService service) {
        this.employeeService = employeeService;
        this.service = service;
    }

    //전체한테 보내기
    @PostMapping("/insertAlarm")
    @ResponseBody
    public void insertAlarm(AlarmVO alarmVO, String dept, Principal principal) {
        service.insertAlarm(alarmVO, dept, principal.getName());
    }

    //특정인에게 알람 보내기
    @PostMapping("/insertAlarmTarget")
    @ResponseBody
    public void insertAlarmTarget(AlarmVO alarmVO) {
        service.insertAlarmTarget(alarmVO);
    }

    @PostMapping("/insertAlarmTargeList")
    @ResponseBody
    public void insertAlarmTargetList(AlarmVO alarmVO) {
        service.insertAlarmTargetList(alarmVO);
    }

    @GetMapping("/all")
    public String all() {
        return "common/allAlarm";
    }

    @GetMapping("/getAllAlarm")
    @ResponseBody
    public List<AlarmVO> alarmList(Principal principal) {
        return service.getAlarmList(principal.getName());
    }

    @DeleteMapping("/deleteAlarm")
    @ResponseBody
    public void deleteAlarm(Principal principal, AlarmVO alarmVO) {
        service.deleteAlarm(alarmVO, principal.getName());
    }

    @GetMapping("/getMaxAlarm")
    @ResponseBody
    public int getMaxAlarm() {
        return service.getMaxAlarm();
    }
}
