package kr.co.groovy.cloud;

import com.amazonaws.SdkClientException;
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.*;
import org.springframework.stereotype.Component;

import java.text.SimpleDateFormat;
import java.util.*;

@Component
public class S3Utils {
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
        List<String> folderList = new ArrayList<>();

        try {
            ListObjectsRequest listObjectsRequest = new ListObjectsRequest()
                    .withBucketName(bucketName)
                    .withPrefix(folderName + "/")
                    .withDelimiter("/")
                    .withMaxKeys(300);

            ObjectListing objectListing = s3Client.listObjects(listObjectsRequest);

            for (String commonPrefixes : objectListing.getCommonPrefixes()) {
                String[] folderParts = commonPrefixes.split("/");
                if (folderParts.length >= 2) {
                    String subfolderName = folderParts[1];
                    folderList.add(subfolderName);
                }
            }

            objectMap.put("folderList", folderList);

            for (S3ObjectSummary objectSummary : objectListing.getObjectSummaries()) {
                if (!objectSummary.getKey().endsWith("/")) {
                    String[] fileParts = objectSummary.getKey().split("/");
                    objectSummary.setStorageClass(objectSummary.getKey());
                    objectSummary.setKey(fileParts[1]);
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

        Map<String, Object> fileInfoMap = new HashMap<>();
        fileInfoMap.put("type", metadata.getContentType());
        fileInfoMap.put("lastDate", lastDate);
        fileInfoMap.put("size", metadata.getContentLength());
        return fileInfoMap;
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
}
