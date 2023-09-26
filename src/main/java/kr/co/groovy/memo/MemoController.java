package kr.co.groovy.memo;

import java.security.Principal;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.groovy.vo.MemoVO;

@Controller
@RequestMapping("/memo")
public class MemoController {
	final
	MemoService memoService;
	
	public MemoController(MemoService memoService) {
		this.memoService = memoService;
	}
	
	@GetMapping("/memoMain")
	public String getMemo(Model model, Principal principal) {
		String memoEmplId = principal.getName();
		List<MemoVO> list = memoService.getMemo(memoEmplId);
		model.addAttribute("memoList", list);
		return "memo/memo";
	}
	
	
	@ResponseBody
	@GetMapping("/memoMain/{memoSn}")
	public String getOneMemo(@PathVariable int memoSn) {
	    memoService.getOneMemo(memoSn);
		return "success";
	}
	
	
	@ResponseBody
	@PostMapping("/memoMain")
	public String inputMemo(@RequestBody MemoVO memoVO, Principal principal) {
		String emplId = principal.getName();
		memoVO.setMemoEmplId(emplId);
		memoService.inputMemo(memoVO);
		return "success";
	}
	
	
	@ResponseBody
	@PutMapping("/memoMain/{memoSn}")
	public String modifyMemo(@RequestBody MemoVO memoVO, @PathVariable int memoSn) {
		memoService.modifyMemo(memoVO);
		return "success";
	}
	
	
	@ResponseBody
	@DeleteMapping("/memoMain/{memoSn}")
	public String deleteMemo(@RequestBody MemoVO memoVO, @PathVariable int memoSn) {
		memoService.deleteMemo(memoSn);
		return "success";
	}

}
