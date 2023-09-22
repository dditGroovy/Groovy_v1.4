package kr.co.groovy.card;

import kr.co.groovy.utils.ParamMap;
import kr.co.groovy.vo.CardReservationVO;
import kr.co.groovy.vo.CardVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface CardMapper {

    int inputCard(CardVO cardVO);

    List<CardVO> loadAllCard();

    int modifyCardNm(CardVO cardVO);

    int modifyCardStatusDisabled(String cprCardNo);

    List<CardReservationVO> loadCardWaitingList();

    int assignCard(CardReservationVO cardReservationVO);

    List<CardReservationVO> loadAllResveRecords();

    int returnChecked(CardReservationVO cardReservationVO);

    List<String> loadAllCardName();

    /* */
    int inputRequest(CardReservationVO cardReservationVO);

    CardReservationVO loadRequestDetail(int cprCardResveSn);

    List<CardReservationVO> loadCardRecord(String emplId);

    void modifyStatus(Map<String, Object> paramMap);

    List<CardReservationVO> loadSanctionList();

    int modifyRequest(CardReservationVO vo);

}
