package kr.co.groovy.alarm;

import kr.co.groovy.employee.EmployeeService;

import kr.co.groovy.memo.MemoService;
import kr.co.groovy.vo.AlarmVO;
import kr.co.groovy.vo.MemoVO;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/alarm")
public class AlarmController {
	final MemoService memoService;
    final EmployeeService employeeService;
    final AlarmService service;

    public AlarmController(EmployeeService employeeService, AlarmService service, MemoService memoService) {
        this.memoService = memoService;
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
    @ResponseBody
    public Map<String, Object> all(Principal principal) {
        List<MemoVO> list = memoService.getMemo(principal.getName());
        MemoVO memoVO = memoService.getFixMemo(principal.getName());

        Map<String, Object> map = new HashMap<>();
        map.put("list", list);
        map.put("memoVO", memoVO);

        return map;
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

    @DeleteMapping("/deleteAllAlarm")
    @ResponseBody
    public void deleteAllAlarm(Principal principal) {
        service.deleteAllAlarm(principal.getName());
    }

    @GetMapping("/getMaxAlarm")
    @ResponseBody
    public int getMaxAlarm() {
        return service.getMaxAlarm();
    }


    @PutMapping("/updateMemoAlarm/{memoSn}")
    @ResponseBody
    public int updateMemoAlarm(@PathVariable int memoSn, Principal principal) {
        String memoEmplId = principal.getName();
        return memoService.updateMemoAlarm(memoSn, memoEmplId);
    }
    
    
    @GetMapping("/updateMemoAlarm/{memoSn}")
    @ResponseBody
    public MemoVO getOneMemoAlarm(@PathVariable int memoSn) {
    	return memoService.getOneMemo(memoSn);
    }
    
    
    @PutMapping("/noFix/{memoSn}")
    @ResponseBody
    public int noFix(@PathVariable int memoSn) {
    	return memoService.noFix(memoSn);
    }

}