package kr.co.groovy.club;

import kr.co.groovy.vo.ClubVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequestMapping("/club")
@Controller
public class ClubController {
    final ClubService service;
    String emplId;

    public ClubController(ClubService service) {this.service = service;}

    @GetMapping("")
    public String loadClub(Model model, Principal principal){
        emplId = principal.getName();
        List<ClubVO> loadAllClub = service.loadAllClub("1");
        model.addAttribute("clubList",loadAllClub);
        return "common/club";
    }
    @ResponseBody
    @GetMapping("/{clbEtprCode}")
    public List<ClubVO> loadClub(@PathVariable String clbEtprCode){
        Map<String, Object> map = new HashMap<>();
        map.put("clbEtprCode",clbEtprCode);
        map.put("clbMbrEmplId",emplId);
        List<ClubVO> clubDetail = service.loadClub(map);
        return clubDetail;
    }
    @PostMapping("/inputClub")
    public String inputClub(@RequestParam Map<String, Object> map){
        map.put("clbChirmnEmplId",emplId);
        map.put("clbMbrEmplId",emplId);
        service.inputClub(map);
        return "redirect:/club";
    }
    @ResponseBody
    @PostMapping("/inputClubMbr")
    public String inputClubMbr(@RequestBody Map<String, Object> map){
        map.put("clbMbrEmplId",emplId);
        service.inputClubMbr(map);
        return "가입 성공~";
    }
    @ResponseBody
    @PutMapping("/updateClubMbrAct")
    public int updateClubMbrAct(@RequestBody Map<String, Object> map){
        map.put("clbMbrEmplId",emplId);
        return service.updateClubMbrAct(map);
    }

    /*  관리자 - 동호회 관리    */
    @GetMapping("/admin")
    public String loadAdminClub(Model model){
        List<ClubVO> clubList = service.loadAllClub("0");
        List<ClubVO> clubRegistList = service.loadAllClub("1");
        model.addAttribute("clubList",clubList);
        model.addAttribute("clubRegistList",clubRegistList);
        return "admin/gat/club/manage";
    }
    @ResponseBody
    @PutMapping("/admin/update")
    public String approveClub(@RequestBody Map<String, Object> map){
        service.updateClubAt(map);
        return "완료";
    }
    @ResponseBody
    @PutMapping(value="/admin/disapprove", produces = "text/plain; charset=UTF-8")
    public String disapproveClub(String clbEtprCode){
        Map<String, Object> map = new HashMap<>();
        map.put("clbEtprCode",clbEtprCode);
        map.put("clbConfmAt",'2');
        service.updateClubAt(map);
        return "승인 거절 완료";
    }
    @GetMapping("/admin/proposalList")
    public String loadProposalClub(Model model){
        return "admin/gat/club/proposalList";
    }
    @ResponseBody
    @PostMapping("/admin/proposalList")
    public List<ClubVO> loadProposalList(){
        List<ClubVO> clubList = service.loadProposalList();
        return clubList;
    }
    @GetMapping("/admin/registList")
    public String loadRegistClub(Model model){
        return "admin/gat/club/registList";
    }
    @ResponseBody
    @PostMapping("/admin/registList")
    public List<ClubVO> loadRegistList(){
        List<ClubVO> clubList = service.loadRegistList();
        return clubList;
    }
    @GetMapping("/admin/{clbEtprCode}")
    public String loadClubDetail(@PathVariable String clbEtprCode, Model model){
        ClubVO clubDetail = service.loadClubDetail(clbEtprCode);
        model.addAttribute("clubDetail",clubDetail);
        return "admin/gat/club/detail";
    }
    @ResponseBody
    @PostMapping("/admin/updateClubInfo")
    public String updateClubInfo(ClubVO vo){
        String clbEtprCode = vo.getClbEtprCode();
        service.updateClubInfo(vo);
        return "success";
    }
    @ResponseBody
    @PutMapping("/admin/{clbEtprCode}/{clbMbrEmplId}")
    public String updateClubMbrAct(@PathVariable String clbEtprCode,@PathVariable String clbMbrEmplId){
        Map<String, Object> map = new HashMap<>();
        map.put("clbEtprCode",clbEtprCode);
        map.put("clbMbrEmplId",clbMbrEmplId);
        service.updateClubMbrAct(map);
        return "success";
    }

}
