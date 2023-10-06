package kr.co.groovy.card;

import kr.co.groovy.vo.CardReservationVO;
import kr.co.groovy.vo.CardVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/card")
public class CardController {

    private final CardService service;

    public CardController(CardService service) {
        this.service = service;
    }


    @GetMapping("/manage")
    public String manageCard(Model model) {
        List<CardReservationVO> loadCardWaitingList = service.loadCardWaitingList();
        model.addAttribute("loadCardWaitingList", loadCardWaitingList);
        model.addAttribute("waitingListCnt", loadCardWaitingList.size());
        return "admin/at/card/manage";
    }


    @PostMapping("/inputCard")
    @ResponseBody
    public int inputCard(CardVO cardVO) {
        int result = service.inputCard(cardVO);
        return result;
    }

    @GetMapping("/loadAllCard")
    @ResponseBody
    public List<CardVO> loadAllCard() {
        return service.loadAllCard();
    }

    @PostMapping("/modifyCardNm")
    @ResponseBody
    public int modifyCardNm(@RequestBody CardVO cardVO) {
        return service.modifyCardNm(cardVO);
    }

    @GetMapping("/modifyCardStatusDisabled/{cprCardNo}")
    @ResponseBody
    public int modifyCardStatusDisabled(@PathVariable String cprCardNo) {
        return service.modifyCardStatusDisabled(cprCardNo);
    }

    @PostMapping("/assignCard")
    @ResponseBody
    public int assignCard(@RequestBody CardReservationVO cardReservationVO) {
        return service.assignCard(cardReservationVO);
    }

    @GetMapping("/reservationRecords")
    public String manageCardReservationRecords(Model model) {
        List<String> cardName = service.loadAllCardName();
        List<CardReservationVO> records = service.loadAllResveRecords();
        model.addAttribute("cardName", cardName);
        model.addAttribute("records", records);
        return "admin/at/card/reservationRecords";
    }

    @PostMapping("/returnChecked")
    @ResponseBody
    public int returnChecked(@RequestBody CardReservationVO cardReservationVO) {
        return service.returnChecked(cardReservationVO);
    }

    /* 신청 및 결재 */
    @GetMapping("/record")
    @ResponseBody
    public List<CardReservationVO> loadRecord(Principal principal) {
        return service.loadCardRecord(principal.getName());
    }

    @GetMapping("/request")
    public String requestCard(Principal principal) {
        return "employee/card/request";
    }

    @PostMapping("/request")
    public String inputRequest(CardReservationVO cardReservationVO) {
//        log.info(cardReservationVO.toString());
        service.inputRequest(cardReservationVO);
        int generatedKey = cardReservationVO.getCprCardResveSn();
        return "redirect:/card/detail/" + generatedKey;
    }

    @GetMapping("/detail/{cprCardResveSn}")
    @ResponseBody
    public CardReservationVO loadRequestDetail(@PathVariable int cprCardResveSn) {
        return service.loadRequestDetail(cprCardResveSn);
    }

    @GetMapping("/data/{cprCardResveSn}")
    @ResponseBody
    public ResponseEntity<CardReservationVO> loadData(@PathVariable int cprCardResveSn) {
        CardReservationVO vo = service.loadRequestDetail(cprCardResveSn);
//        log.info(vo.toString());
        return ResponseEntity.ok(vo);
    }

    // 결재 관리 페이지
    @GetMapping("/sanction")
    public String loadSanction(Model model) {
        List<CardReservationVO> sanctionList = service.loadSanctionList();
        model.addAttribute("sanctionList", sanctionList);
        return "admin/at/card/sanction";
    }

    @PostMapping("/modify/request")
    @ResponseBody
    public int modifyRequest(CardReservationVO vo) {
        return service.modifyRequest(vo);
    }
}
