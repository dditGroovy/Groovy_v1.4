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

    /* 휴가 결재 관련 */
    @GetMapping("/request")
    public String requestVacation() {
        return "employee/vacation/request";
    }

    @GetMapping("/record")
    @ResponseBody
    public List<VacationUseVO> loadVacationRecord(Principal principal) {
        return service.loadVacationRecord(principal.getName());
    }


    // enum 처리 안 함(코드 그대로)
    @GetMapping("/data/{yrycUseDtlsSn}")
    @ResponseBody
    public ResponseEntity<VacationUseVO> loadVacationData(@PathVariable int yrycUseDtlsSn) {
        VacationUseVO vo = service.loadVacationData(yrycUseDtlsSn);
        return ResponseEntity.ok(vo);
    }

    // enum 처리 함
    @GetMapping("/detail/{yrycUseDtlsSn}")
    @ResponseBody
    public VacationUseVO loadVacationDetail(@PathVariable int yrycUseDtlsSn) {
        return service.loadVacationDetail(yrycUseDtlsSn);
    }

    @PostMapping("/modify/request")
    @ResponseBody
    public int modifyRequest(VacationUseVO vo) {
        return service.modifyRequest(vo);
    }


//    /* 휴가 신청 폼 */
//    @GetMapping("/request")
//    public String requestVacation(Model model, Principal principal) {
//        String emplId = principal.getName();
//        List<VacationUseVO> vacationRecord = service.loadVacationRecord(emplId);
//        model.addAttribute("vacationRecord", vacationRecord);
//        return "employee/vacation/request";
//    }

    /* 휴가 신청 submit */
    @PostMapping("/request")
    @ResponseBody
    public int inputVacation(VacationUseVO vo) {
        return service.inputVacation(vo);
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

    @GetMapping("/sanction")
    public String loadSanction (Model model) {
        List<VacationVO> allEmplVacation = service.loadAllEmplVacation();
        model.addAttribute("allEmplVacation", allEmplVacation);
        return "admin/hrt/employee/sanction";
    }

}
