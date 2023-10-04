package kr.co.groovy.alarm;

import kr.co.groovy.employee.EmployeeService;
import kr.co.groovy.enums.Department;
import kr.co.groovy.vo.AlarmVO;
import kr.co.groovy.vo.EmployeeVO;
import kr.co.groovy.vo.NotificationVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AlarmService {
    final AlarmMapper mapper;
    final EmployeeService employeeService;
    public AlarmService(AlarmMapper mapper, EmployeeService employeeService) {
        this.mapper = mapper;
        this.employeeService = employeeService;
    }

    public void insertAlarm(AlarmVO alarmVO, String dept, String requestEmplId) {
        List<EmployeeVO> emplList = employeeService.loadEmpList();
        for (EmployeeVO employeeVO : emplList) {
            String emplId = employeeVO.getEmplId();
            NotificationVO noticeAt = employeeService.getNoticeAt(emplId);
            if (alarmVO.getCommonCodeNtcnKind().equals("NTCN013")) { //사내 공지사항
                if (noticeAt.getAnswer().equals("NTCN_AT010")) {
                    alarmVO.setNtcnEmplId(emplId);
                    mapper.insertAlarm(alarmVO);
                }
            }

            if (alarmVO.getCommonCodeNtcnKind().equals("NTCN012")) { //팀 공지사항
                String deptValue = Department.getValueByLabel(employeeVO.getCommonCodeDept());
                if (noticeAt.getCompanyNotice().equals("NTCN_AT010")
                        && deptValue.equals(dept)
                        && !emplId.equals(requestEmplId)) {
                    alarmVO.setNtcnEmplId(emplId);
                    mapper.insertAlarm(alarmVO);
                }
            }
        }
    }

    public void insertAlarmTarget(AlarmVO alarmVO) {
        NotificationVO noticeAt = employeeService.getNoticeAt(alarmVO.getNtcnEmplId());
        if (noticeAt.getAnswer().equals("NTCN_AT010")) {
            mapper.insertAlarm(alarmVO);
        }
    }

    public void deleteAlarm(AlarmVO alarmVO, String emplId) {
        alarmVO.setNtcnEmplId(emplId);
        mapper.deleteAlarm(alarmVO);
    }

    public void deleteAllAlarm(String emplId) {
        mapper.deleteAllAlarm(emplId);
    }

    public List<AlarmVO> getAlarmList(String ntcnEmplId) {
        return mapper.getAlarmList(ntcnEmplId);
    }

    public Integer getMaxAlarm () {
        if (mapper.getMaxAlarm() == null) {
            return 0;
        }
        return mapper.getMaxAlarm();
    }

    public void insertAlarmTargetList(AlarmVO alarmVO) {
        List<String> emplIdList = alarmVO.getSelectedEmplIds();
        for (String emplId : emplIdList) {
            alarmVO.setNtcnEmplId(emplId);
            mapper.insertAlarm(alarmVO);
        }
    }
}
