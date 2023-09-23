package kr.co.groovy.file;

import kr.co.groovy.vo.UploadFileVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.UUID;

@Slf4j
@RestController
@RequestMapping("/file")
public class FileController {

    final
    String uploadPath;
    final
    FileService service;
    // TODO 경로 주입 바꾸기 (운영서버로)
    public FileController(String uploadSeoju, FileService service) {
        this.uploadPath = uploadSeoju;
        this.service = service;
    }

    @GetMapping("/download/{dir}")
    public void fileDownload(@PathVariable("dir") String dir,
                             @RequestParam("uploadFileSn") int uploadFileSn,
                             HttpServletResponse resp) throws Exception {
        try {
            UploadFileVO vo = service.downloadFile(uploadFileSn);
            String originalName = new String(vo.getUploadFileOrginlNm().getBytes("utf-8"), "iso-8859-1");
            String filePath = uploadPath + "/" + dir;
            String fileName = vo.getUploadFileStreNm();

            File file = new File(filePath, fileName);
            if (!file.isFile()) {
                log.info("파일 없음");
                return;
            }

            resp.setContentType("application/octet-stream");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + originalName + "\"");
            resp.setHeader("Content-Transfer-Encoding", "binary");
            resp.setContentLength((int) file.length());

            FileInputStream inputStream = new FileInputStream(file);
            OutputStream outputStream = resp.getOutputStream();
            byte[] buffer = new byte[4096];
            int bytesRead = -1;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            inputStream.close();
            outputStream.close();
        } catch (IOException e) {
            log.info("파일 다운로드 실패");
        }
    }

    @PostMapping("/upload/{dir}/{etprCode}")
    public void fileUpload(@PathVariable("dir") String dir, @PathVariable("etprCode") String etprCode, MultipartFile file) throws Exception {
        try {
            String path = uploadPath + "/" + dir;
//            File uploadPath = new File(uploadPath ,FileUploadUtils.getFolder());
            File uploadDir = new File(path);
            if (!uploadDir.exists()) {
                if (uploadDir.mkdirs()) {
                    log.info("폴더 생성 성공");
                } else {
                    log.info("폴더 생성 실패");
                }
            }
            String originalFileName = file.getOriginalFilename();
            String extension = originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
            String newFileName = UUID.randomUUID() + "." + extension;

            File saveFile = new File(path, newFileName);
            file.transferTo(saveFile);

            long fileSize = file.getSize();
            HashMap<String, Object> map = new HashMap<>();
            map.put("etprCode", etprCode);
            map.put("originalFileName", originalFileName);
            map.put("newFileName", newFileName);
            map.put("fileSize", fileSize);
            service.uploadFile(map);
            log.info("파일 등록 성공");

        } catch (Exception e) {
            log.info("파일 등록 실패");
        }
    }
}
