package kr.co.groovy.facility;

import kr.co.groovy.enums.Facility;
import kr.co.groovy.vo.FacilityVO;
import kr.co.groovy.vo.VehicleVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/facility")
@RequiredArgsConstructor
public class FacilityController {
    private final FacilityService service;

    @GetMapping("/{code}")
    public ModelAndView getVehicles(@PathVariable String code, ModelAndView mav) {
        if (code.equals("vehicle")) {
            List<VehicleVO> vehicles = service.getVehicles();
            mav.addObject("vehicles", vehicles);
            mav.setViewName("facility/carResve");
        } else if (code.equals("rest")) {
            List<FacilityVO> restRooms = service.getRooms("FCLTY011%");
            List<FacilityVO> bedList = new ArrayList<>();
            List<FacilityVO> sofaList = new ArrayList<>();
            for (int i = 0; i < restRooms.size(); i++) {
                if (restRooms.get(i).getCommonCodeFcltyKind().startsWith("R00")) {
                    bedList.add(restRooms.get(i));
                    mav.addObject("bedList", bedList);
                }
                if (restRooms.get(i).getCommonCodeFcltyKind().startsWith("R01")) {
                    sofaList.add(restRooms.get(i));
                    mav.addObject("sofaList", sofaList);
                }
            }
            mav.setViewName("facility/restResve");
        } else if (code.equals("meeting")) {
            List<FacilityVO> meetingRooms = service.getRooms("FCLTY010%");
            for (FacilityVO meetingRoom : meetingRooms) {
                String fcltyKind = Facility.getValueByLabel(meetingRoom.getCommonCodeFcltyKind());
                FacilityVO fixturesByFcltyKind = service.getFixturesByFcltyKind(fcltyKind);
                meetingRoom.setScreen(fixturesByFcltyKind.getScreen());
                meetingRoom.setProjector(fixturesByFcltyKind.getProjector());
                meetingRoom.setWhiteBoard(fixturesByFcltyKind.getWhiteBoard());
                meetingRoom.setExtinguisher(fixturesByFcltyKind.getExtinguisher());
            }
            mav.addObject("meetingRooms", meetingRooms);
            mav.setViewName("facility/meetingResve");
        }
        return mav;
    }

    @GetMapping("/vehicle/reserved/{vhcleNo}")
    @ResponseBody
    public List<VehicleVO> getReservedVehicle(@PathVariable String vhcleNo) {
        return service.getReservedVehicle(vhcleNo);
    }

    @GetMapping("/vehicle/myReservations")
    @ResponseBody
    public List<VehicleVO> getReservedVehicleByEmplId(Principal vhcleResveEmplId) {
        return service.getReservedVehicleByEmplId(vhcleResveEmplId.getName());
    }

    @PostMapping("/vehicle")
    @ResponseBody
    public String inputVehicleReservation(Principal vhcleResveEmplId, @RequestBody VehicleVO vo) {
        if (vo.getVhcleNo() == null || vo.getVhcleNo() == "") {
            return "vhcleNo is null";
        } else if (vo.getVhcleResveBeginTime() == null) {
            return "beginTime is null";
        } else if (vo.getVhcleResveEndTime() == null) {
            return "endTime is null";
        }

        if (vo.getVhcleResveBeginTime().equals(vo.getVhcleResveEndTime())) {
            return "same time";
        } else if (vo.getVhcleResveBeginTime().after(vo.getVhcleResveEndTime())) {
            return "end early than begin";
        } else {
            vo.setVhcleResveEmplId(vhcleResveEmplId.getName());
            int count = service.inputVehicleReservation(vo);
            return String.valueOf(count);
        }
    }

    @DeleteMapping("/vehicle/{vhcleResveNo}")
    @ResponseBody
    public String deleteReservedByVhcleResveNo(@PathVariable int vhcleResveNo) {
        int count = service.deleteReservedByVhcleResveNo(vhcleResveNo);
        return String.valueOf(count);
    }

    @DeleteMapping("/{fcltyResveSn}")
    @ResponseBody
    public String deleteReservedByFcltyResveSn(@PathVariable int fcltyResveSn) {
        int count = service.deleteReservedByFcltyResveSn(fcltyResveSn);
        return String.valueOf(count);
    }

    @GetMapping("/rest/reserved/{roomNo}")
    @ResponseBody
    public List<FacilityVO> getReservedRestRoomsByFcltyKind(@PathVariable String roomNo) {
        String commonCodeFcltyKind = Facility.getValueByLabel(roomNo);
        return service.getReservedRoomsByFcltyKind(commonCodeFcltyKind);
    }

    @GetMapping("/{code}/myReservations")
    @ResponseBody
    public List<FacilityVO> getReservedRestRoomByFcltyResveEmplId(Principal fcltyResveEmplId, @PathVariable String code) {
        Map<String, String> map = new HashMap<>();
        map.put("fcltyResveEmplId", fcltyResveEmplId.getName());
        if (code.equals("rest")) {
            map.put("fcltyKind", "FCLTY011%");
        } else if (code.equals("meeting")) {
            map.put("fcltyKind", "FCLTY010%");
        }
        return service.getReservedRoomByFcltyResveEmplId(map);
    }

    @PostMapping("/room")
    @ResponseBody
    public String inputRestReservation(Principal fcltyResveEmplId, @RequestBody FacilityVO vo) {
        vo.setCommonCodeFcltyKind(Facility.getValueByLabel(vo.getCommonCodeFcltyKind()));
        vo.setFcltyResveEmplId(fcltyResveEmplId.getName());
        if (vo.getCommonCodeFcltyKind() == null || vo.getCommonCodeFcltyKind() == "") {
            return "fcltyKind is null";
        } else if (vo.getFcltyResveBeginTime() == null) {
            return "beginTime is null";
        } else if (vo.getFcltyResveEndTime() == null) {
            return "endTime is null";
        }

        if (vo.getFcltyResveBeginTime().equals(vo.getFcltyResveEndTime())) {
            return "same time";
        } else if (vo.getFcltyResveBeginTime().after(vo.getFcltyResveEndTime())) {
            return "end early than begin";
        } else {
            int count = service.inputRestReservation(vo);
            return String.valueOf(count);
        }
    }
}
