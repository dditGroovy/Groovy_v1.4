package kr.co.groovy.cloud;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.SdkClientException;
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.*;
import kr.co.groovy.vo.CloudVO;
import org.apache.commons.io.IOUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@Component
public class S3Utils {
    final CloudMapper mapper;

    public S3Utils(CloudMapper mapper) {
        this.mapper = mapper;
    }

    public Map<String, Object> getS3Info() {
        DefaultAWSCredentialsProviderChain credentialsProvider = DefaultAWSCredentialsProviderChain.getInstance();

        AmazonS3 s3Client = AmazonS3Client.builder()
                .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration("s3.ap-northeast-2.amazonaws.com", "ap-northeast-2"))
                .build();

        String bucketName = null;
        List<Bucket> buckets = s3Client.listBuckets();

        if (!buckets.isEmpty()) {
            Bucket firstBucket = buckets.get(0);
            bucketName = firstBucket.getName();
        }

        Map<String, Object> map = new HashMap<>();
        map.put("bucketName", bucketName);
        map.put("s3Client", s3Client);
        return map;
    }

    //상위폴더를 기준으로 모든 하위 폴더 및 파일
    public Map<String, Object> getAllInfos(String folderName) {
        Map<String, Object> s3Info = getS3Info();
        Map<String, Object> objectMap = new HashMap<>();

        String bucketName = (String) s3Info.get("bucketName");
        AmazonS3 s3Client = (AmazonS3) s3Info.get("s3Client");
        List<S3ObjectSummary> fileList = new ArrayList<>();
        List<Map<String, Object>> folderList = new ArrayList<>();
        try {
            ListObjectsRequest listObjectsRequest = new ListObjectsRequest()
                    .withBucketName(bucketName)
                    .withPrefix(folderName + "/")
                    .withDelimiter("/")
                    .withMaxKeys(300);

            ObjectListing objectListing = s3Client.listObjects(listObjectsRequest);

            for (String commonPrefixes : objectListing.getCommonPrefixes()) {
                Map<String, Object> folderInfoMap = new HashMap<>();
                folderInfoMap.put("path", commonPrefixes);
                String[] folderParts = commonPrefixes.split("/");
                if (folderParts.length >= 2) {
                    String subfolderName = folderParts[folderParts.length - 1];
                    folderInfoMap.put("subfolderName", subfolderName);
                }
                folderList.add(folderInfoMap);
            }
            objectMap.put("folderList", folderList);

            for (S3ObjectSummary objectSummary : objectListing.getObjectSummaries()) {
                if (!objectSummary.getKey().endsWith("/")) {
                    String[] fileParts = objectSummary.getKey().split("/");
                    objectSummary.setStorageClass(objectSummary.getKey());
                    objectSummary.setKey(fileParts[fileParts.length-1]);
                    fileList.add(objectSummary);
                }
            }
            objectMap.put("fileList", fileList);

        } catch (AmazonS3Exception e) {
            e.printStackTrace();
        } catch (SdkClientException e) {
            e.printStackTrace();
        }
        return objectMap;
    }

    //폴더 삭제
    public void deleteFolder(String path) {
        Map<String, Object> s3Info = getS3Info();
        String bucketName = (String) s3Info.get("bucketName");
        AmazonS3 s3Client = (AmazonS3) s3Info.get("s3Client");

        //내부 파일 삭제
        try {
            ListObjectsRequest listObjectsRequest = new ListObjectsRequest()
                    .withBucketName(bucketName)
                    .withPrefix(path);

            ObjectListing objectListing = s3Client.listObjects(listObjectsRequest);
            for (S3ObjectSummary objectSummary : objectListing.getObjectSummaries()) {
                s3Client.deleteObject(bucketName, objectSummary.getKey());
                mapper.deleteCloud(objectSummary.getKey());
            }
        } catch (AmazonS3Exception e) {
        }

        s3Client.deleteObject(bucketName, path);
        mapper.deleteCloud(path);
    }

    //파일 업로드
    public void uploadFile(MultipartFile file, String path, String emplId) throws IOException {
        Map<String, Object> s3Info = getS3Info();
        String bucketName = (String) s3Info.get("bucketName");
        AmazonS3 s3Client = (AmazonS3) s3Info.get("s3Client");
        String fileName = file.getOriginalFilename();
        CloudVO cloudVO = new CloudVO();
        fileName = path + "/" + fileName;
        cloudVO.setCloudObjectKey(fileName);
        cloudVO.setCloudShareEmplId(emplId);
        mapper.insertCloud(cloudVO);

        try {
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentType(file.getContentType());
            PutObjectRequest request = new PutObjectRequest(bucketName, fileName, file.getInputStream(), metadata);
            request.withCannedAcl(CannedAccessControlList.AuthenticatedRead); // 접근권한 체크
            PutObjectResult result = s3Client.putObject(request);
        } catch (AmazonServiceException e) {
            e.printStackTrace();
        } catch (SdkClientException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //파일 정보
    public Map<String, Object> getFileInfo(String key) {
        Map<String, Object> s3Info = getS3Info();
        String bucketName = (String) s3Info.get("bucketName");
        AmazonS3 s3Client = (AmazonS3) s3Info.get("s3Client");

        S3Object s3Object = s3Client.getObject(bucketName, key);
        ObjectMetadata metadata = s3Object.getObjectMetadata();
        Date lastModified = metadata.getLastModified();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String lastDate = dateFormat.format(lastModified);
        String emplNm = mapper.getEmplNm(key);
        String[] parts = key.split("\\.");
        String fileExtension = parts.length > 1 ? parts[parts.length - 1] : "";
        Map<String, Object> fileInfoMap = new HashMap<>();
        fileInfoMap.put("type", getContentType(fileExtension));
        fileInfoMap.put("lastDate", lastDate);
        fileInfoMap.put("emplNm", emplNm);
        fileInfoMap.put("size", metadata.getContentLength());
        return fileInfoMap;
    }

    //다운로드
    public ResponseEntity<byte[]> download(String url) throws IOException {
        Map<String, Object> s3Info = getS3Info();
        String bucketName = (String) s3Info.get("bucketName");
        AmazonS3 s3Client = (AmazonS3) s3Info.get("s3Client");

        S3Object s3Object = s3Client.getObject(new GetObjectRequest(bucketName, url));
        S3ObjectInputStream inputStream = s3Object.getObjectContent();
        byte[] bytes = IOUtils.toByteArray(inputStream);

        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.setContentType(contentType(url));
        httpHeaders.setContentLength(bytes.length);
        String[] urlParts = url.split("/");
        String type = urlParts[urlParts.length - 1];
        String fileName = URLEncoder.encode(type, "UTF-8").replaceAll("\\+", "%20");
        httpHeaders.setContentDispositionFormData("attachment", fileName);

        return new ResponseEntity<>(bytes, httpHeaders, HttpStatus.OK);
    }

    //폴더 생성
    public void createFolder(String path) {
        Map<String, Object> s3Info = getS3Info();
        String bucketName = (String) s3Info.get("bucketName");
        AmazonS3 s3Client = (AmazonS3) s3Info.get("s3Client");

        ObjectMetadata objectMetadata = new ObjectMetadata();
        objectMetadata.setContentLength(0L);
        objectMetadata.setContentType("application/x-directory");
        PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, path, new ByteArrayInputStream(new byte[0]), objectMetadata);

        try {
            s3Client.putObject(putObjectRequest);
        } catch (AmazonS3Exception e) {
            e.printStackTrace();
        } catch (SdkClientException e) {
            e.printStackTrace();
        }
    }

    private MediaType contentType(String key) {
        String[] keyParts = key.split("\\.");
        String type = keyParts[keyParts.length - 1];
        switch (type) {
            case "txt":
                return MediaType.TEXT_PLAIN;
            case "jpg":
                return MediaType.IMAGE_JPEG;
            case "jpeg":
                return MediaType.IMAGE_JPEG;
            case "png":
                return MediaType.IMAGE_PNG;
            case "gif":
                return MediaType.IMAGE_GIF;
            default:
                return MediaType.APPLICATION_OCTET_STREAM;
        }
    }

    //확장자
    public Map<String, Object> extensionToIcon() {
        Map<String, Object> extensionMap = new HashMap<>();
        extensionMap.put("jpeg", "jpeg-img");
        extensionMap.put("jpg", "jpeg-img");
        extensionMap.put("png", "png-img");
        extensionMap.put("gif", "gif-img");
        extensionMap.put("zip", "zip-img");
        extensionMap.put("pptx", "pptx-img");
        extensionMap.put("ppt", "pptx-img");
        extensionMap.put("xls", "xls-img");
        extensionMap.put("xlsx", "xls-img");
        extensionMap.put("mp3", "mp3-img");
        extensionMap.put("mp4", "mp4-img");
        extensionMap.put("pdf", "pdf-img");
        extensionMap.put("txt", "txt-img");
        extensionMap.put("doc", "doc-img");
        extensionMap.put("docx", "doc-img");

        return extensionMap;
    }

    //파일 유형
    public String getContentType(String extension) {
        Map<String, String> contentTypeMap = new HashMap<>();
        contentTypeMap.put("jpeg", "image/jpeg");
        contentTypeMap.put("jpg", "image/jpeg");
        contentTypeMap.put("png", "image/png");
        contentTypeMap.put("gif", "image/gif");
        contentTypeMap.put("zip", "application/zip");
        contentTypeMap.put("pptx", "application/pptx");
        contentTypeMap.put("ppt", "application/pptx");
        contentTypeMap.put("xls", "application/excel");
        contentTypeMap.put("xlsx", "application/excel");
        contentTypeMap.put("mp3", "audio/mpeg");
        contentTypeMap.put("mp4", "video/mp4");
        contentTypeMap.put("pdf", "application/pdf");
        contentTypeMap.put("txt", "text/plain");
        contentTypeMap.put("doc", "application/msword");
        contentTypeMap.put("docx", "application/word");

        return contentTypeMap.get(extension);
    }

    public static void main(String[] args) {
        S3Utils s3Utils = new S3Utils(null);
        s3Utils.deleteFolder("DEPT010/제발");
    }
}
