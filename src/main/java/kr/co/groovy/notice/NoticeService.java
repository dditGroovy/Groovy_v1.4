package kr.co.groovy.notice;

import kr.co.groovy.enums.NoticeKind;
import kr.co.groovy.vo.NoticeVO;
import kr.co.groovy.vo.UploadFileVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;
@Slf4j
@Service
public class NoticeService {
    final
    NoticeMapper mapper;
    final
    String uploadPath;

    public NoticeService(NoticeMapper mapper, String uploadPath) {
        this.mapper = mapper;
        this.uploadPath = uploadPath;
    }
    /* 관리자 */
    public String inputNotice(NoticeVO vo, MultipartFile[] notiFiles) {
        int notiSeq = mapper.getNotiSeq();
        SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
        Date currentDate = new java.util.Date();
        String formattedDate = sdf.format(currentDate);

        String notiEtprCode = "NOTI-" + notiSeq + "-" + formattedDate;
        vo.setNotiEtprCode(notiEtprCode);
        mapper.inputNotice(vo);

        try {
            String path = uploadPath + "/notice";
            log.info("notice path: " + path);
            File uploadDir = new File(path);
            if (!uploadDir.exists()) {
                if (uploadDir.mkdirs()) {
                    log.info("폴더 생성 성공");
                } else {
                    log.info("폴더 생성 실패");
                }
            }
            for (MultipartFile notiFile : notiFiles) {
                String originalFileName = notiFile.getOriginalFilename();
                String extension = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
                String newFileName = UUID.randomUUID() + "." + extension;

                File saveFile = new File(path, newFileName);
                notiFile.transferTo(saveFile);

                long fileSize = notiFile.getSize();
                HashMap<String, Object> map = new HashMap<>();
                map.put("notiEtprCode", notiEtprCode);
                map.put("originalFileName", originalFileName);
                map.put("newFileName", newFileName);
                map.put("fileSize", fileSize);
                mapper.uploadNoticeFile(map);
                log.info("공지 파일 등록 성공");
            }
        } catch (Exception e) {
            log.info("공지 파일 등록 실패");
        }
        return notiEtprCode; //알림 url
    }

    public List<NoticeVO> loadNoticeListForAdmin() {
        List<NoticeVO> list = mapper.loadNoticeList();
        for (NoticeVO noticeVO : list) {
            String iconFileName = noticeVO.getNotiCtgryIconFileStreNm();
            String categoryLabel = NoticeKind.getCategoryLabel(iconFileName);
            noticeVO.setNotiCtgryIconFileStreNm(categoryLabel);
        }
        return list;
    }

    public void deleteNotice(String notiEtprCode) {
        mapper.deleteNotice(notiEtprCode);
    }

    public void modifyNoticeView(String notiEtprCode) {
        mapper.modifyNoticeView(notiEtprCode);
    }


    /* 사원 */
    public List<NoticeVO> loadNoticeList() {
        return mapper.loadNoticeList();
    }

    public List<UploadFileVO> loadNotiFiles(String notiEtprCode) {
        return mapper.loadNotiFiles(notiEtprCode);
    }

    public List<NoticeVO> findNotice(Map<String, Object> paramMap) {
        return mapper.findNotice(paramMap);
    }

    public NoticeVO loadNoticeDetail(String notiSeq) {
        return mapper.loadNoticeDetail(notiSeq);
    }

    public UploadFileVO downloadNotiFile(int uploadFileSn) {
        return mapper.downloadNotiFile(uploadFileSn);
    }

}
