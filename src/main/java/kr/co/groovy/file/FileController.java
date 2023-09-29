package kr.co.groovy.file;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import kr.co.groovy.vo.UploadFileVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

@Slf4j
@RestController
@RequestMapping("/file")
public class FileController {

    final
    String uploadPath;
    final
    FileService service;

    // TODO 경로 주입 바꾸기 (운영서버로)
    public FileController(String uploadPath, FileService service) {
        this.uploadPath = uploadPath;
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

    @GetMapping("/download/salary")
    public void fileDownloadByDate(@RequestParam String date, @RequestParam String data,
                                   HttpServletResponse resp) throws Exception {
        Map<String, String> map = new HashMap<>();
        map.put("date", date);
        map.put("emplId", data);
        try {
            UploadFileVO vo = service.downloadFileByDate(map);
            String originalName = new String(vo.getUploadFileStreNm().getBytes("utf-8"), "iso-8859-1");
            String filePath = uploadPath + "/salary";
            String fileName = vo.getUploadFileStreNm();

            File dtsmtFile = new File(filePath, fileName);

            if (!dtsmtFile.isFile()) {
                log.info("파일 없음");
                return;
            }

            resp.setContentType("application/octet-stream");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + originalName + "\"");
            resp.setHeader("Content-Transfer-Encoding", "binary");
            resp.setContentLength((int) dtsmtFile.length());

            FileInputStream inputStream = new FileInputStream(dtsmtFile);
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

    @GetMapping("/download/salaryZip")
    public String downloadSalaryZip(@RequestParam String date, @RequestParam String data, HttpServletResponse resp) throws Exception {
        ObjectMapper objectMapper = new ObjectMapper();
        List<String> emplIdArray = objectMapper.readValue(data, new TypeReference<List<String>>() {
        });

        List<File> fileList = new ArrayList<>();
        String filePath = null;
        Map<String, String> map = new HashMap<>();
        map.put("date", date);
        for (String emplId : emplIdArray) {
            map.put("emplId", emplId);
            UploadFileVO vo = service.downloadFileByDate(map);
            if (vo != null) {
                String originalName = new String(vo.getUploadFileOrginlNm().getBytes("utf-8"), "iso-8859-1");
                String fileName = vo.getUploadFileStreNm();
                filePath = this.uploadPath + "/salary";

                File file = new File(filePath, fileName);
                if (!file.isFile()) {
                    log.info("파일 없음");
                }
                fileList.add(file);
            }
        }
        File zipFile = new File(filePath, date.substring(0, 2) + "년 " + date.substring(2) + "월 급여명세서 목록.zip");
        byte[] buf = new byte[4096];
        try (ZipOutputStream zout = new ZipOutputStream(new FileOutputStream(zipFile))) {
            for (File file : fileList) {
                try (FileInputStream fin = new FileInputStream(file)) {
                    ZipEntry ze = new ZipEntry(file.getName());
                    zout.putNextEntry(ze);

                    int len;
                    while ((len = fin.read(buf)) > 0) {
                        zout.write(buf, 0, len);
                    }
                    zout.closeEntry();
                }
            }
        }

        downloadFile(zipFile, resp);
        return "압축성공";
    }

    public static void downloadFile(File file, HttpServletResponse resp) {
        try (FileInputStream inputStream = new FileInputStream(file)) {
            byte[] buffer = new byte[4096];
            int bytesRead = -1;

            resp.setContentType("application/octet-stream");

            String encodedFileName = URLEncoder.encode(file.getName(), "UTF-8");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");
            resp.setHeader("Content-Transfer-Encoding", "binary");
            resp.setContentLength((int) file.length());

            OutputStream outputStream = resp.getOutputStream();

            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            inputStream.close();
            outputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @PostMapping("/upload/{dir}/{etprCode}")
    public void fileUpload(@PathVariable("dir") String dir, @PathVariable("etprCode") String
            etprCode, MultipartFile file) throws Exception {
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
            e.printStackTrace();
        }
    }
}
