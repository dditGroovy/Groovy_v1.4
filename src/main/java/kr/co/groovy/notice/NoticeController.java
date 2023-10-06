package kr.co.groovy.notice;

import kr.co.groovy.vo.NoticeVO;
import kr.co.groovy.vo.UploadFileVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/notice")
public class NoticeController {
    final
    NoticeService service;
    final
    String uploadPath;
    public NoticeController(NoticeService service, String uploadPath) {
        this.service = service;
        this.uploadPath = uploadPath;
    }

    /* 관리자 */
    @GetMapping("/manage")
    public String manageNotice(Model model) {
        List<NoticeVO> list = service.loadNoticeListForAdmin();
        model.addAttribute("notiList", list);
        return "admin/gat/notice/manage";
    }

    @GetMapping("/inputNotice")
    public String inputNoticeForm() {
        return "admin/gat/notice/register";
    }

    @PostMapping("/input")
    @ResponseBody
    public String inputNotice(NoticeVO vo, MultipartFile[] notiFiles) {
        return service.inputNotice(vo, notiFiles);
    }

    @GetMapping("/detail")
    public String loadNoticeDetailForAdmin(Model model, String notiEtprCode) {
        NoticeVO vo = service.loadNoticeDetail(notiEtprCode);
        List<UploadFileVO> list = service.loadNotiFiles(notiEtprCode);
        model.addAttribute("noticeDetail", vo);
        if (list != null) {
            model.addAttribute("notiFiles", list);
        }
        return "admin/gat/notice/detail";
    }

    @GetMapping("/delete")
    public String deleteNotice(String notiEtprCode) {
        service.deleteNotice(notiEtprCode);
        return "redirect:/notice/manage";
    }


    /* 사원 */
    @GetMapping("/list")
    public String loadNoticeList(Model model) {
        List<NoticeVO> list = service.loadNoticeList();
        model.addAttribute("noticeList", list);
        return "common/notice";
    }

    @GetMapping("/detail/{notiEtprCode}")
    public String loadNoticeDetail(Model model, @PathVariable String notiEtprCode) {
        service.modifyNoticeView(notiEtprCode);
        NoticeVO vo = service.loadNoticeDetail(notiEtprCode);
        List<UploadFileVO> list = service.loadNotiFiles(notiEtprCode);
        model.addAttribute("noticeDetail", vo);
        model.addAttribute("notiFiles", list);
        return "common/noticeDetail";
    }

    @GetMapping("/find")
    public String findNotice(Model model, @RequestParam(value = "keyword") String keyword, @RequestParam(value = "sortBy") String sortBy, @RequestParam(value = "startDay") String startDay, @RequestParam(value = "endDay")String endDay) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("keyword", keyword);
        paramMap.put("sortBy", sortBy);
        paramMap.put("startDay", startDay);
        paramMap.put("endDay", endDay);
        List<NoticeVO> list = service.findNotice(paramMap);
        model.addAttribute("noticeList", list);
        return "common/notice";
    }
}
