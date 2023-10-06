package kr.co.groovy.commute;

import kr.co.groovy.enums.LaborStatus;
import kr.co.groovy.enums.VacationKind;
import kr.co.groovy.utils.ParamMap;
import kr.co.groovy.vacation.VacationMapper;
import kr.co.groovy.vo.CommuteVO;
import kr.co.groovy.vo.VacationUseVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class CommuteService {
    final CommuteMapper commuteMapper;
    final VacationMapper vacationMapper;

    public CommuteService(CommuteMapper commuteMapper, VacationMapper vacationMapper) {
        this.commuteMapper = commuteMapper;
        this.vacationMapper = vacationMapper;
    }

    public CommuteVO getCommute(String dclzEmplId) {
        return commuteMapper.getCommute(dclzEmplId);
    }

    public int getMaxWeeklyWorkTime(String dclzEmplId) {
        return commuteMapper.getMaxWeeklyWorkTime(dclzEmplId);
    }

    public int insertAttend(CommuteVO commuteVO) {
        return commuteMapper.insertAttend(commuteVO);
    }

    public int updateCommute(String dclzEmplId) {
        return commuteMapper.updateCommute(dclzEmplId);
    }

    public List<String> getWeeklyAttendTime(String dclzEmplId) {
        return commuteMapper.getWeeklyAttendTime(dclzEmplId);
    }

    public List<String> getWeeklyLeaveTime(String dclzEmplId) {
        return commuteMapper.getWeeklyLeaveTime(dclzEmplId);
    }

    public List<String> getAllYear(String dclzEmplId) {
        return commuteMapper.getAllYear(dclzEmplId);
    }

    public List<String> getAllMonth(Map<String, Object> map) {
        return commuteMapper.getAllMonth(map);
    }

    public List<CommuteVO> getCommuteByYearMonth(Map<String, Object> map) {
        return commuteMapper.getCommuteByYearMonth(map);
    }

    public CommuteVO getAttend(String dclzEmplId) {
        return commuteMapper.getAttend(dclzEmplId);
    }

    ;

    public int getMaxWeeklyWorkTimeByDay(CommuteVO commuteVO) {
        return commuteMapper.getMaxWeeklyWorkTimeByDay(commuteVO);
    }

    public void insertCommuteByVacation(Map<String, Object> paramMap) {
        int id = Integer.parseInt((String) paramMap.get("vacationId"));
        ParamMap map = ParamMap.init();
        map.put("approveId", id);
        map.put("state", "YRYC032");
        vacationMapper.modifyStatus(map);

        VacationUseVO vo = vacationMapper.loadVacationBySn(id);
        String vacationUse = vo.getCommonCodeYrycUseSe();
        String vacationKind = vo.getCommonCodeYrycUseKind();

        Date beginDate = vo.getYrycUseDtlsBeginDate();
        Date endDate = vo.getYrycUseDtlsEndDate();

        CommuteVO commuteVO = new CommuteVO();
        commuteVO.setDclzEmplId(vo.getYrycUseDtlsEmplId());

        Date currentDate = beginDate;
        Calendar calendar = Calendar.getInstance();

        while (!currentDate.after(endDate)) {
            calendar.setTime(currentDate);
            commuteVO.setDclzWorkDe(currentDate.toString());
            commuteVO.setDclzAttendTm(currentDate.toString());
            commuteVO.setDclzLvffcTm(currentDate.toString());

            if (vacationUse.equals(String.valueOf(VacationKind.YRYC020))
                    || vacationUse.equals(String.valueOf(VacationKind.YRYC021))) {
                commuteVO.setDclzDailWorkTime(4 * 60);
                commuteVO.setDclzWikWorkTime(getMaxWeeklyWorkTimeByDay(commuteVO) + (4 * 60));
            } else {
                commuteVO.setDclzDailWorkTime(8 * 60);
                commuteVO.setDclzWikWorkTime(getMaxWeeklyWorkTimeByDay(commuteVO) + (8 * 60));
            }
            if (vacationKind.equals(String.valueOf(VacationKind.YRYC010))) {
                commuteVO.setCommonCodeLaborSttus(String.valueOf(LaborStatus.LABOR_STTUS011));
            } else if (vacationKind.equals(String.valueOf(VacationKind.YRYC011))) {
                commuteVO.setCommonCodeLaborSttus(String.valueOf(LaborStatus.LABOR_STTUS014));
            }
            String workWik = commuteMapper.getWorkWik(String.valueOf(currentDate));
            commuteVO.setDclzWorkWik(workWik);

            vacationMapper.modifyVacationCount(vo);
            commuteMapper.insertCommute(commuteVO);

            calendar.add(Calendar.DATE, 1);
            java.sql.Date sqlDate = new java.sql.Date(calendar.getTime().getTime());
            currentDate = sqlDate;
        }
    }
}
