package kr.co.groovy.vacation;

import kr.co.groovy.vo.VacationUseVO;
import kr.co.groovy.vo.VacationVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/vacation")
public class VacationController {

    private final VacationService service;

    public VacationController(VacationService vacationService) {
        this.service = vacationService;
    }

    /* 내 휴가 관련 */
    @GetMapping("")
    public String myVacation(Model model, Principal principal) {
        String emplId = principal.getName();
        Map<String, Object> vacationCnt = service.loadVacationCnt(emplId);
        List<VacationUseVO> myVacation = service.loadConfirmedVacation(emplId);
        List<VacationUseVO> teamMemVacation = service.loadTeamMemVacation(emplId);
        model.addAttribute("usedVacationCnt", vacationCnt.get("usedVacationCnt"));
        model.addAttribute("nowVacationCnt", vacationCnt.get("nowVacationCnt"));
        model.addAttribute("totalVacationCnt", vacationCnt.get("totalVacationCnt"));
        model.addAttribute("myVacation", myVacation);
        model.addAttribute("teamMemVacation", teamMemVacation);
        return "employee/myVacation";
    }

    @GetMapping("/record")
    public String vacationRecord(Model model, Principal principal) {
        String emplId = principal.getName();
        List<VacationUseVO> vacationRecord = service.loadVacationRecord(emplId);
        model.addAttribute("vacationRecord", vacationRecord);
        return "employee/vacation/record";
    }

    @GetMapping("/detail/{yrycUseDtlsSn}")
    public String vacationDetail(@PathVariable int yrycUseDtlsSn, Model model) {
        VacationUseVO vo = service.loadVacationDetail(yrycUseDtlsSn);
        model.addAttribute("detailVO", vo);
        return "employee/vacation/detail";
    }

    @GetMapping("/loadData/{yrycUseDtlsSn}")
    @ResponseBody
    public ResponseEntity<VacationUseVO> loadVacationData(@PathVariable int yrycUseDtlsSn) {
        VacationUseVO vo = service.loadVacationDetail(yrycUseDtlsSn);
        return ResponseEntity.ok(vo);
    }


    /* 휴가 신청 폼 */
    @GetMapping("/request")
    public String requestVacation() {
        return "employee/vacation/request";
    }

    /* 휴가 신청 submit */
    @PostMapping("/request")
    public String inputVacation(VacationUseVO vo) {
        service.inputVacation(vo);
        int generatedKey = vo.getYrycUseDtlsSn();
        return "redirect:/vacation/detail/" + generatedKey;
    }

    @GetMapping("/manage")
    public String manageVacation(Model model) {
        List<VacationVO> allEmplVacation = service.loadAllEmplVacation();
        model.addAttribute("allEmplVacation", allEmplVacation);
        return "admin/hrt/employee/vacation";
    }

    @PostMapping("/manage")
    @ResponseBody
    public int modifyYrycNowCo(@RequestBody VacationVO vacationVO) {
        return service.modifyYrycNowCo(vacationVO);
    }
}
