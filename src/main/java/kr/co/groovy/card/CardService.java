package kr.co.groovy.card;

import kr.co.groovy.enums.Department;
import kr.co.groovy.utils.ParamMap;
import kr.co.groovy.vo.CardReservationVO;
import kr.co.groovy.vo.CardVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class CardService {

    private final CardMapper mapper;

    public CardService(CardMapper mapper) {
        this.mapper = mapper;
    }

    public int inputCard(CardVO cardVO) {
        return mapper.inputCard(cardVO);
    }

    public List<CardVO> loadAllCard() {
        List<CardVO> cardList = mapper.loadAllCard();
        for (CardVO cardVO : cardList) {
            String cprCardNo = cardVO.getCprCardNo();
            cardVO.setMaskCardNo(maskCardNumber(cprCardNo));
        }
        return cardList;
    }

    private String maskCardNumber(String cprCardNo) {
        if (cprCardNo.length() != 19 || !cprCardNo.matches("\\d{4}-\\d{4}-\\d{4}-\\d{4}")) {
            return "Invalid card number format";
        }

        String[] number = cprCardNo.split("-");
        number[1] = "****";
        number[2] = "****";

        String maskCardNo = String.join("-", number);

        return maskCardNo;
    }

    public int modifyCardNm(CardVO cardVO) {
        return mapper.modifyCardNm(cardVO);
    }

    public int modifyCardStatusDisabled(String cprCardNo) {
        return mapper.modifyCardStatusDisabled(cprCardNo);
    }

    public List<CardReservationVO> loadCardWaitingList() {
        return mapper.loadCardWaitingList();
    }

    public int assignCard(CardReservationVO cardReservationVO) {
        return mapper.assignCard(cardReservationVO);
    }

    public List<CardReservationVO> loadAllResveRecords() {
        return mapper.loadAllResveRecords();
    }

    public int returnChecked(CardReservationVO cardReservationVO) {
        return mapper.returnChecked(cardReservationVO);
    }

    public List<String> loadAllCardName() {
        return mapper.loadAllCardName();
    }


    /* */
    public int inputRequest(CardReservationVO cardReservationVO) {
        return mapper.inputRequest(cardReservationVO);
    }

    CardReservationVO loadRequestDetail(int cprCardResveSn) {
        return mapper.loadRequestDetail(cprCardResveSn);
    }

    List<CardReservationVO> loadCardRecord(String emplId) {
        return mapper.loadCardRecord(emplId);
    }

    public void modifyStatus(Map<String, Object> paramMap) {
//        log.info("modifyCardStatus");
//        log.info((String) paramMap.get("approveId"));
//        log.info((String) paramMap.get("state"));
        mapper.modifyStatus(paramMap);
    }

    public List<CardReservationVO> loadSanctionList() {
        List<CardReservationVO> list = mapper.loadSanctionList();
        for (CardReservationVO vo : list) {
            vo.setCommonCodeDept(Department.valueOf(vo.getCommonCodeDept()).label());
        }
        return list;
    }

    public int modifyRequest(CardReservationVO vo) {
        return mapper.modifyRequest(vo);
    }

}
