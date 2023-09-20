package kr.co.groovy.reservation;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.groovy.vo.FacilityVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FacilityManageService {

	@Autowired
	private FacilityManageMapper mapper;
	
	// 시설 예약 현황 조회
	public List<FacilityVO> getAllReservedRooms() {
		List<FacilityVO> reservedRoom = mapper.getAllReservedRooms();
		// log.info("(서비스)값이 나오니? " + reservedRoom);
		return reservedRoom;
	}
	
	// 회의실 코드 세팅
	public String setMeetingCode(String CommonCodeFcltyKind) {
		if (CommonCodeFcltyKind.startsWith("FCLTY010")) {
			return "FCLTY010";
		} else {
			return CommonCodeFcltyKind;
		}
	}

	// 휴게실 코드 세팅
	public String setRetiringCode(String CommonCodeFcltyKind) {
		if (CommonCodeFcltyKind.startsWith("FCLTY011")) {
			return "FCLTY011";
		} else {
			return CommonCodeFcltyKind;
		}
	}
	
	// 각 시설별 비품 목록 가져오기
	public List<FacilityVO> findEquipmentList(String commonCodeFcltyKind) {
	    return mapper.findEquipmentList(commonCodeFcltyKind);
	}
	
	// 휴게실 구분코드 가져오기
	public List<FacilityVO> getRetiringRoom(String commonCodeFcltyKind){
		return mapper.getRetiringRoom(commonCodeFcltyKind);
	}
	
	// 저장된 시설 이름 vo에 전달
	public FacilityVO getFacilityName(FacilityVO facilityVO) {
		String commonCodeFcltyKind = facilityVO.getCommonCodeFcltyKind();
		String fcltyName = putFacilityName(commonCodeFcltyKind);
		// VO에 시설이름 저장
		facilityVO.setFcltyName(fcltyName);
		return facilityVO;
	}

	// 시설 이름 저장
	public String putFacilityName(String commonCodeFcltyKind) {
	    if (commonCodeFcltyKind == null) {
	        return "";
	    }
	    
	    if (commonCodeFcltyKind.startsWith("FCLTY010")) {
	        return "회의실";
	    } else if (commonCodeFcltyKind.startsWith("FCLTY011")) {
	        return "휴게실";
	    } else {
	        return commonCodeFcltyKind;
	    }
	}
	
	// 예약 취소 매퍼 연결
	public void delResved(int fcltyResveSn) {
		mapper.delReserve(fcltyResveSn);
	}
	
	// 시설 코드 vo에 전달
	public FacilityVO addFacility(FacilityVO facilityVO) {
		String meetingRoom = facilityVO.getCommonCodeFcltyKind();
		String meetingRoomCode = setMeetingCode(meetingRoom);

		String retiringRoom = facilityVO.getCommonCodeFcltyKind();
		String retiringRoomCode = setRetiringCode(retiringRoom);

		facilityVO.setCommonCodeFcltyKind(meetingRoomCode);
		facilityVO.setCommonCodeFcltyKind(retiringRoomCode);

		return facilityVO;
	}
	
	// 회의실 이름 세팅
	public String setMeetingName(String fcltyName) {
		if (fcltyName.startsWith("회의실")) {
			return "회의실";
		} else {
			return fcltyName;
		}
	}
	
	// 휴게실 이름 세팅
	public String setRetiringName(String fcltyName) {
		if (fcltyName.startsWith("휴게실")) {
			return "휴게실";
		} else {
			return fcltyName;
		}
	}
	
	//시설 갯수 
	public int getRoomCount(String roomCode) {
		return mapper.getRoomCount(roomCode);
	}
	
	//당일 예약 가져오기
	public List<FacilityVO> findTodayResve() {
		List<FacilityVO> todayResve = mapper.findTodayResve();
		log.info("당일 예약 나오니?? "+todayResve);
		return todayResve;
	}
}

