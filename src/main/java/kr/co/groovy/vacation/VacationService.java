package kr.co.groovy.vacation;

import kr.co.groovy.enums.VacationKind;
import kr.co.groovy.utils.ParamMap;
import kr.co.groovy.vo.VacationUseVO;
import kr.co.groovy.vo.VacationVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@EnableScheduling
public class VacationService {

    private final VacationMapper mapper;

    public VacationService(VacationMapper vacationMapper) {
        this.mapper = vacationMapper;
    }

    public Map<String, Object> loadVacationCnt(String emplId) {
        VacationVO vo = mapper.loadVacationCnt(emplId);
        Map<String, Object> map = new HashMap<>();
        if (vo != null) {
            double usedVacationCnt = vo.getYrycUseCo();
            double nowVacationCnt = vo.getYrycNowCo();
            double totalVacationCnt = usedVacationCnt + nowVacationCnt;
            if (usedVacationCnt == (int) usedVacationCnt) {
                map.put("usedVacationCnt", (int) usedVacationCnt);
            } else {
                map.put("usedVacationCnt", usedVacationCnt);
            }

            if (nowVacationCnt == (int) nowVacationCnt) {
                map.put("nowVacationCnt", (int) nowVacationCnt);
            } else {
                map.put("nowVacationCnt", nowVacationCnt);
            }

            if (totalVacationCnt == (int) totalVacationCnt) {
                map.put("totalVacationCnt", (int) totalVacationCnt);
            } else {
                map.put("totalVacationCnt", totalVacationCnt);
            }
        }
        return map;
    }

    public List<VacationUseVO> loadVacationRecord(String emplId) {
        List<VacationUseVO> list = mapper.loadVacationRecord(emplId);
        for(VacationUseVO vo : list ){
            vo.setCommonCodeYrycUseKind(VacationKind.valueOf(vo.getCommonCodeYrycUseKind()).label());
            vo.setCommonCodeYrycUseSe(VacationKind.valueOf(vo.getCommonCodeYrycUseSe()).label());
            vo.setCommonCodeYrycState(VacationKind.valueOf(vo.getCommonCodeYrycState()).label());
        }
        return list;
    }
    public int inputVacation(VacationUseVO vo){
        return mapper.inputVacation(vo);
    }

    public VacationUseVO loadVacationData(int yrycUseDtlsSn){
        return mapper.loadVacationDetail(yrycUseDtlsSn);
    }

    public VacationUseVO loadVacationDetail(int yrycUseDtlsSn){
        VacationUseVO vo = mapper.loadVacationDetail(yrycUseDtlsSn);
        vo.setCommonCodeYrycUseKind(VacationKind.valueOf(vo.getCommonCodeYrycUseKind()).label());
        vo.setCommonCodeYrycUseSe(VacationKind.valueOf(vo.getCommonCodeYrycUseSe()).label());
        vo.setCommonCodeYrycState(VacationKind.valueOf(vo.getCommonCodeYrycState()).label());
        return vo;
    }

    public List<VacationUseVO> loadConfirmedVacation(String emplId) {
        List<VacationUseVO> list = mapper.loadConfirmedVacation(emplId);
        return enumAndSubList(list);
    }

    public List<VacationUseVO> loadTeamMemVacation(String emplId) {
        List<VacationUseVO> list = mapper.loadTeamMemVacation(emplId);
        return enumAndSubList(list);
    }

    private List<VacationUseVO> enumAndSubList(List<VacationUseVO> list) {
        for(VacationUseVO vo : list) {
            String useKind = VacationKind.valueOf(vo.getCommonCodeYrycUseKind()).label();
            vo.setCommonCodeYrycUseKind(useKind);
        }
        if(list.size() > 10) {
            List<VacationUseVO> subList = list.subList(0, 10);
            return subList;
        } else {
            return list;
        }
    }

    public void modifyVacationCount(VacationUseVO vacationUseVO) {mapper.modifyVacationCount(vacationUseVO);}

    public VacationUseVO loadVacationBySn(int yrycUseDtlsSn) {
        return mapper.loadVacationBySn(yrycUseDtlsSn);
    }

    public void modifyStatus(Map<String, Object> paramMap) {
        ParamMap map = ParamMap.init();
        map.put("approveId", paramMap.get("approveId"));
        map.put("state", paramMap.get("state"));
        mapper.modifyStatus(map);
    }

    public List<VacationVO> loadAllEmplVacation() {
        return mapper.loadAllEmplVacation();
    }

    public int modifyYrycNowCo(VacationVO vacationVO) {
        return mapper.modifyYrycNowCo(vacationVO);
    }

    @Transactional
    @Scheduled(cron = "0 0 0 1 1 ?")
    public void modifyVacationOnNewYear() {
        mapper.modifyVacationOnNewYear();
    }

    int modifyRequest(VacationUseVO vo){
       return mapper.modifyRequest(vo);
    }

}
