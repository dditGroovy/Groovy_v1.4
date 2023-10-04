package kr.co.groovy.reservation;

import kr.co.groovy.vo.FacilityVO;
import kr.co.groovy.vo.VehicleVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ReservationMapper {
    /* 차량 예약 */
    List<VehicleVO> getTodayReservedVehicles();

    List<VehicleVO> getAllVehicles();

    int inputVehicle(VehicleVO vo);

    List<VehicleVO> getAllReservation();

    int modifyReturnAt(String vhcleResveNo);

    //시설 예약조회
    public List<FacilityVO> getAllReservedRooms();

    //예약취소
    public void delReserve(int fcltyResveSn);

    //회의실 갯수
    public int getRoomCount(String roomCode);

    //당일 예약 조회
    public List<FacilityVO> findTodayResve();

    //각 시설별 비품 조회
    public List<FacilityVO> findEquipmentList(String commonCodeFcltyKind);

    //휴게실 구분코드
    public List<FacilityVO> getRetiringRoom(String commonCodeFcltyKind);

}
