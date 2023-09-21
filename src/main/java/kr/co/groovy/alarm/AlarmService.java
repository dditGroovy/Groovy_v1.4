package kr.co.groovy.alarm;

import kr.co.groovy.vo.AlarmVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AlarmService {
    final AlarmMapper mapper;

    public AlarmService(AlarmMapper mapper) {
        this.mapper = mapper;
    }

    public void insertAlarm(AlarmVO alarmVO) {
        mapper.insertAlarm(alarmVO);
    }

    public void deleteAlarm(AlarmVO alarmVO) {
        mapper.deleteAlarm(alarmVO);
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
