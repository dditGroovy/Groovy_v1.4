package kr.co.groovy.chat;

import kr.co.groovy.vo.ChatRoomVO;
import kr.co.groovy.vo.ChatVO;
import kr.co.groovy.vo.EmployeeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.*;

@Slf4j
@Controller
@RequestMapping("/chat")
public class ChatController {

    private final ChatService service;

    public ChatController(ChatService service) {
        this.service = service;
    }

    @GetMapping("")
    public String chat(Model model, Principal principal) {
        String emplId = principal.getName();
        List<EmployeeVO> emplListForChat = service.loadEmpListForChat(emplId);
        model.addAttribute("emplListForChat", emplListForChat);
        return "chat/chat";
    }

    @GetMapping("/loadRooms")
    @ResponseBody
    public List<ChatRoomVO> loadRooms(Principal principal) {
        String emplId = principal.getName();
        List<ChatRoomVO> rooms = service.loadChatRooms(emplId);
        return rooms;
    }

    @PostMapping("/createRoom")
    @ResponseBody
    public int createRoom(@RequestBody List<EmployeeVO> roomMemList, Principal principal) {
        String emplId = principal.getName();
        return service.createRoom(emplId, roomMemList);
    }

    @PostMapping("/inputMessage")
    @ResponseBody
    public int inputMessage(@RequestBody ChatVO chatVO) {
        return service.inputMessage(chatVO);
    }

    @GetMapping("/loadRoomMessages/{chttRoomNo}")
    @ResponseBody
    public List<ChatVO> loadRoomMessages(@PathVariable int chttRoomNo) {
        return service.loadRoomMessages(chttRoomNo);
    }

    @PostMapping("/inviteEmpls")
    @ResponseBody
    public int inviteEmpls(@RequestBody Map<String, Object> newMem) {
        return service.inviteEmpl(newMem);
    }

    @GetMapping("/loadRoomMembers/{chttRoomNo}")
    @ResponseBody
    public List<String> loadRoomMembers(@PathVariable int chttRoomNo) {
        return service.loadRoomMembers(chttRoomNo);
    }

    @GetMapping(value = "/loadNewRoomName/{chttRoomNo}", produces = "application/text;charset=utf8")
    @ResponseBody
    public String loadNewRoomName(@PathVariable int chttRoomNo) {
        return service.loadNewRoomName(chttRoomNo);
    }
}
