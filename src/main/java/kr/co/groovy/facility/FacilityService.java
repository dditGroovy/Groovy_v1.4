package kr.co.groovy.facility;

import kr.co.groovy.enums.Facility;
import kr.co.groovy.enums.Fixtures;
import kr.co.groovy.enums.Hipass;
import kr.co.groovy.vo.FacilityVO;
import kr.co.groovy.vo.VehicleVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class FacilityService {
    private final FacilityMapper mapper;

    public List<VehicleVO> getVehicles() {
        List<VehicleVO> vehicles = mapper.getVehicles();
        for (VehicleVO vehicleVO : vehicles) {
            vehicleVO.setCommonCodeHipassAsnAt(Hipass.valueOf(vehicleVO.getCommonCodeHipassAsnAt()).getLabel());
        }
        return vehicles;
    }

    public List<VehicleVO> getReservedVehicle(String vhcleNo) {
        return mapper.getReservedVehicleByVhcleNo(vhcleNo);
    }

    public List<VehicleVO> getReservedVehicleByEmplId(String vhcleResveEmplId) {
        return mapper.getReservedVehicleByEmplId(vhcleResveEmplId);
    }

    public int inputVehicleReservation(VehicleVO vehicleVO) {
        return mapper.inputVehicleReservation(vehicleVO);
    }

    public int deleteReservedByVhcleResveNo(int vhcleResveNo) {
        return mapper.deleteReservedByVhcleResveNo(vhcleResveNo);
    }

    public List<FacilityVO> getRooms(String commonCodeFcltyKind) {
        List<FacilityVO> restRooms = mapper.getRooms(commonCodeFcltyKind);
        setCommonCodeToFacility(restRooms);
        return restRooms;
    }

    public FacilityVO getFixturesByFcltyKind(String commonCodeFcltyKind) {
        FacilityVO fixture = mapper.getFixturesByFcltyKind(commonCodeFcltyKind);
        try {
            fixture.setProjector(Fixtures.valueOf(fixture.getProjector()).getLabel());
            fixture.setScreen(Fixtures.valueOf(fixture.getScreen()).getLabel());
            fixture.setExtinguisher(Fixtures.valueOf(fixture.getExtinguisher()).getLabel());
            fixture.setWhiteBoard(Fixtures.valueOf(fixture.getWhiteBoard()).getLabel());
        } catch (NullPointerException e) {
            e.getMessage();
        }
        return fixture;
    }

    public List<FacilityVO> getReservedRoomsByFcltyKind(String commonCodeFcltyKind) {
        List<FacilityVO> reservedRoomsByFcltyKind = mapper.getReservedRoomsByFcltyKind(commonCodeFcltyKind);
        setCommonCodeToFacility(reservedRoomsByFcltyKind);
        return reservedRoomsByFcltyKind;
    }

    public List<FacilityVO> getReservedRoomByFcltyResveEmplId(Map<String, String> map) {
        List<FacilityVO> list = mapper.getReservedRoomByFcltyResveEmplId(map);
        setCommonCodeToFacility(list);
        for (FacilityVO facilityVO : list) {
            if (facilityVO.getFcltyResveRequstMatter() == null || facilityVO.getFcltyResveRequstMatter().isEmpty()) {
                facilityVO.setFcltyResveRequstMatter("-");
            }
        }
        return list;
    }

    public int inputRestReservation(FacilityVO facilityVO) {
        return mapper.inputRestReservation(facilityVO);
    }

    public int deleteReservedByFcltyResveSn(int fcltyResveSn) {
        return mapper.deleteReservedByFcltyResveSn(fcltyResveSn);
    }

    private static void setCommonCodeToFacility(List<FacilityVO> list) {
        for (FacilityVO facilityVO : list) {
            facilityVO.setCommonCodeFcltyKind(Facility.valueOf(facilityVO.getCommonCodeFcltyKind()).getLabel());
        }
    }
}
