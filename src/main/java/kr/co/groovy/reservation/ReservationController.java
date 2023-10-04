package kr.co.groovy.reservation;

import kr.co.groovy.vo.FacilityVO;
import kr.co.groovy.vo.VehicleVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/reserve")
public class ReservationController {

    final
    ReservationService service;

    public ReservationController(ReservationService service) {
        this.service = service;
    }

    /* 차량 예약 */
    @GetMapping("/manageVehicle")
    public String loadReservedAndRegisteredVehicle(Model model) {
        List<VehicleVO> allVehicles = service.getAllVehicles();
        List<VehicleVO> todayReservedVehicles = service.getTodayReservedVehicles();
        model.addAttribute("allVehicles", allVehicles);
        model.addAttribute("todayReservedVehicles", todayReservedVehicles);
        return "admin/gat/car/manage";
    }

    @GetMapping("/inputVehicle")
    public String inputVehicle() {
        return "admin/gat/car/register";
    }

    @PostMapping("/inputVehicle")
    public ModelAndView insertVehicle(VehicleVO vehicleVO, ModelAndView mav) {
        int count = service.inputVehicle(vehicleVO);
        if (count > 0) {
            mav.setViewName("redirect:/reserve/manageVehicle");
        }
        return mav;
    }

    @GetMapping("/loadVehicle")
    public String loadVehicle(Model model) {
        List<VehicleVO> allReservation = service.getAllReservation();
        model.addAttribute("allReservation", allReservation);
        return "admin/gat/car/list";
    }

    @PutMapping("/return")
    @ResponseBody
    public String modifyReturnAt(@RequestBody String vhcleResveNo) {
        return String.valueOf(service.modifyReturnAt(vhcleResveNo));
    }

    /* 회의실, 휴게실 예약 */
    @GetMapping("/manageRoom")
    public String getAllReservedRooms(Model model) {

        //시설 갯수 카운트
        int meetingCount = service.getRoomCount("FCLTY010");
        if (meetingCount == 0) {
            return "0";
        }

        int retiringCount = service.getRoomCount("FCLTY011");
        if (retiringCount == 0) {
            return "0";
        }

        //시설 구분 코드
        List<FacilityVO> meetingCode = service.findEquipmentList("FCLTY010");
        List<FacilityVO> retiringCode = service.getRetiringRoom("FCLTY011");
        List<FacilityVO> toDayList = service.findTodayResve();
        //List<FacilityVO> equipmentList = service.findEquipmentList(commonCodeFcltyKind);

        for (FacilityVO room : toDayList) {
            service.getFacilityName(room);
        }

        for (FacilityVO room : meetingCode) {
            service.getFacilityName(room);
        }

        for (FacilityVO room : retiringCode) {
            service.getFacilityName(room);
        }

        model.addAttribute("meetingCount", meetingCount);
        model.addAttribute("retiringCount", retiringCount);
        model.addAttribute("meetingCode", meetingCode);
        model.addAttribute("retiringCode", retiringCode);
        model.addAttribute("toDayList", toDayList);
        return "admin/gat/room/manage";
    }

    //삭제 버튼 메소드
    @GetMapping("/deleteReservation")
    @ResponseBody
    public String deleteReserved(@RequestParam int fcltyResveSn) {
        try {
            service.delResved(fcltyResveSn);
            return "success"; // 삭제 성공 시 "success" 반환
        } catch (Exception e) {
            e.printStackTrace();
            return "failure"; // 삭제 실패 시 "failure" 반환
        }
    }

    //시설 예약현황 정보을 담은 메소드
    @GetMapping("/loadReservation")
    public String loadTodayReseve(Model model) {
        List<FacilityVO> reservedRooms = service.getAllReservedRooms();

        // 시설 이름, 구분코드를 등록하고, VO를 jsp로 전달
        for (FacilityVO room : reservedRooms) {
            service.getFacilityName(room);
        }

        model.addAttribute("reservedRooms", reservedRooms);
        return "admin/gat/room/list";
    }
}
