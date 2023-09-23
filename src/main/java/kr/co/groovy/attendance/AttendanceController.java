package kr.co.groovy.attendance;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
@Slf4j
@Controller
@RequestMapping("/attendance")
public class AttendanceController {
    final
    AttendanceService service;

    public AttendanceController(AttendanceService service) {
        this.service = service;
    }

    @GetMapping("/manage")
    public String manageDclz(Model model) {
        List<Integer> deptTotalWorkTime = service.deptTotalWorkTime();
        List<Integer> deptAvgWorkTime = service.deptAvgWorkTime();
        String allDclzList = service.loadAllDclz();
        model.addAttribute("deptTotalWorkTime", deptTotalWorkTime);
        model.addAttribute("deptAvgWorkTime", deptAvgWorkTime);
        model.addAttribute("allDclzList", allDclzList);

        return "admin/hrt/attendance/all";
    }

    @GetMapping("/manage/{deptCode}")
    public String manageDclzDept(Model model, @PathVariable String deptCode) {
        String deptDclzList = service.loadDeptDclz(deptCode);
        model.addAttribute("deptDclzList", deptDclzList);
        return "admin/hrt/attendance/dept";
    }
}
