package kr.co.groovy.community;

import kr.co.groovy.vo.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.*;

@Slf4j
@Service
@EnableScheduling
public class CommunityService {
    final CommunityMapper mapper;
    final String uploadPath;

    public CommunityService(CommunityMapper mapper, String uploadPath) {
        this.mapper = mapper;
        this.uploadPath = uploadPath;
    }

    public void inputPost(SntncVO vo, MultipartFile postFile) throws IOException {
        /* sntncEtprCode */
        String sntncEtprCode = makeSntncEtprCode();
        vo.setSntncEtprCode(sntncEtprCode);
        mapper.inputPost(vo);
        boolean hasFile = postFile.isEmpty();
        if (postFile != null && postFile.getSize() != 0 && !postFile.getName().equals("")) {
            String path = uploadPath + "/teamCommunity";
            File uploadDir = new File(path);
            if (!uploadDir.exists()) {
                if (uploadDir.mkdirs()) {
                    log.info("폴더 생성 성공");
                } else {
                    log.info("폴더 생성 실패");
                }
            }

            String originalFileName = postFile.getOriginalFilename();
            String extension = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
            String newFileName = UUID.randomUUID() + "." + extension;

            File saveFile = new File(path, newFileName);
            postFile.transferTo(saveFile);

            long fileSize = postFile.getSize();
            HashMap<String, Object> map = new HashMap<>();
            map.put("sntncEtprCode", sntncEtprCode);
            map.put("originalFileName", originalFileName);
            map.put("newFileName", newFileName);
            map.put("fileSize", fileSize);

            mapper.uploadPostFile(map);
        }


    }

    public void inputTeamNoti(Map<String, Object> map) {
        /* sntncEtprCode */
        String sntncEtprCode = makeSntncEtprCode();
        map.put("sntncEtprCode", sntncEtprCode);
        mapper.inputTeamNoti(map);
    }

    public List<SntncVO> loadTeamNoti(String emplId) {
        return mapper.loadTeamNoti(emplId);
    }

    public void modifyTeamNoti(Map<String, Object> map) {
        mapper.modifyTeamNoti(map);
    }

    public List<SntncVO> loadPost(String emplId) {
        return mapper.loadPost(emplId);
    }

    ;

    public int modifyPost(Map<String, Object> map) {
        return mapper.modifyPost(map);
    }

    ;

    public void deletePost(Map<String, Object> map) {
        mapper.deletePost(map);
    }

    /*public List<RecommendVO> loadRecommend(String emplId){return mapper.loadRecomend(emplId);}*/
    public int loadRecommend(String sntncEtprCode) {
        return mapper.loadRecommend(sntncEtprCode);
    }

    public int findRecommend(Map<String, Object> map) {
        return mapper.findRecommend(map);
    }

    public void inputRecommend(RecommendVO vo) {
        mapper.inputRecommend(vo);
    }

    public void deleteRecommend(RecommendVO vo) {
        mapper.deleteRecommend(vo);
    }

    /*  댓글  */
    public void inputAnswer(Map<String, Object> map) {
        mapper.inputAnswer(map);
    }

    public int loadAnswerCnt(String sntncEtprCode) {
        return mapper.loadAnswerCnt(sntncEtprCode);
    }

    public List<AnswerVO> loadAnswer(String sntncEtprCode) {
        return mapper.loadAnswer(sntncEtprCode);
    }

    /*  투표  */
    public List<VoteRegisterVO> loadAllRegistVote(String emplId) {
        List<VoteRegisterVO> voteRegistList = mapper.loadAllRegistVote(emplId);
        Map<String, Object> map = new HashMap<>();
        map.put("emplId", emplId);
        for (VoteRegisterVO vo : voteRegistList) {
            String voteRegistNo = String.valueOf(vo.getVoteRegistNo());
            map.put("voteRegistNo", voteRegistNo);
            List<VoteOptionVO> voteOptionList = mapper.loadVoteOption(map);
            vo.setVoteOptionList(voteOptionList);
        }
        return voteRegistList;
    }

    public void inputVote(Map<String, Object> map) {
        mapper.inputVote(map);
    }
    public void deleteVote(Map<String, Object> map){
        mapper.deleteVote(map);
    }

    @Transactional
    public void inputVoteRegist(VoteRegisterVO vo) {
        mapper.inputVoteRegist(vo);
        //  현재 시퀀스
        int voteRegistSeq = mapper.getVoteSeq();
        List<String> options = vo.getVoteOptionNames();
        VoteOptionVO voteOptionVO = new VoteOptionVO();
        for (String option : options) {
            voteOptionVO.setVoteRegistNo(voteRegistSeq);
            voteOptionVO.setVoteOptionContents(option);
            mapper.inputVoteOptions(voteOptionVO);
        }
    }
    public void updateVoteRegistAt(String voteRegistNo){
        mapper.updateVoteRegistAt(voteRegistNo);
    }
    @Scheduled(cron = "0 0 * * * ?")
    public void updateVoteRegistAtFromDate() {
        Instant now = Instant.now();
        String voteRegistAt = "1";
        Map<String, Object> map = new HashMap<>();
        map.put("now", now);
        map.put("voteRegistAt", voteRegistAt);
        mapper.updateVoteRegistAtFromDate(map);
    }
    public String makeSntncEtprCode() {
        int postSeq = mapper.getSeq();
        /*'SNTNC-'||SNTNC_SEQ.nextval||'-'||TO_CHAR(sysdate,'yyyyMMdd')*/
        // 현재 날짜 구하기
        Date now = new Date();
        // 날짜 포맷팅
        SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
        String nowDate = format.format(now);

        String sntncEtprCode = "SNTNC-" + postSeq + "-" + nowDate;
        return sntncEtprCode;
    }
}
