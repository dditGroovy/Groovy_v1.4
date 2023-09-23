package kr.co.groovy.reservation;

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

    @PutMapping("/return")
    @ResponseBody
    public String modifyReturnAt(@RequestBody String vhcleResveNo) {
        return String.valueOf(service.modifyReturnAt(vhcleResveNo));
    }

    @GetMapping("/loadVehicle")
    public String loadVehicle(Model model) {
        List<VehicleVO> allReservation = service.getAllReservation();
        model.addAttribute("allReservation", allReservation);
        return "admin/gat/car/list";
    }
}
