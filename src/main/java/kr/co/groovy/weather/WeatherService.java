package kr.co.groovy.weather;

import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

@Slf4j
@Service
@EnableScheduling
public class WeatherService {

    private String nx = "68";
    private String ny = "100";
    private String baseDate;
    private String baseTime;
    private String type = "json";
    final
    WeatherMapper mapper;

    public WeatherService(WeatherMapper mapper) {
        this.mapper = mapper;
    }

    //    @Scheduled(fixedRate = 30 * 1000) // 30초마다
    @Scheduled(cron = "0 5 2,5,8,11,14,17,20,23 * * *")
    public void saveWeather() throws IOException {
        String[] baseTimes = {"0200", "0500", "0800", "1100", "1400", "1700", "2000", "2300"};

        LocalDateTime currentDateTime = LocalDateTime.now();
        LocalTime currentTime = currentDateTime.toLocalTime();

        String closestBaseTime = findClosestBaseTime(currentTime, baseTimes);

        baseDate = currentDateTime.toLocalDate().toString().replace("-", "");
        baseTime = closestBaseTime;

        String apiUrl = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst";
        String serviceKey = "qZe4uWWBzGxh3ONQq9pLg2ttxtKjdcqH5RDNzmyGTr8JnV5p8RXvVxR%2Bnj21qUT9uZm%2FucTk9%2BWLviOGGsphtw%3D%3D";

        StringBuilder urlBuilder = new StringBuilder(apiUrl);
        urlBuilder.append("?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + serviceKey);
        urlBuilder.append("&" + URLEncoder.encode("nx", "UTF-8") + "=" + URLEncoder.encode(nx, "UTF-8"));
        urlBuilder.append("&" + URLEncoder.encode("ny", "UTF-8") + "=" + URLEncoder.encode(ny, "UTF-8"));
        urlBuilder.append("&" + URLEncoder.encode("base_date", "UTF-8") + "=" + URLEncoder.encode(baseDate, "UTF-8"));
        urlBuilder.append("&" + URLEncoder.encode("base_time", "UTF-8") + "=" + URLEncoder.encode(baseTime, "UTF-8"));
        urlBuilder.append("&" + URLEncoder.encode("dataType", "UTF-8") + "=" + URLEncoder.encode(type, "UTF-8"));

        URL url = new URL(urlBuilder.toString());

        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");

        BufferedReader rd;
        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }

        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }

        rd.close();
        conn.disconnect();
        String result = sb.toString();
        mapper.saveWeather(result);
//        return result;
    }

    public static String findClosestBaseTime(LocalTime currentTime, String[] baseTimes) {
        LocalTime closestTime = null;
        long minDifference = Long.MAX_VALUE;

        for (String baseTimeStr : baseTimes) {
            LocalTime baseTime = LocalTime.parse(baseTimeStr, DateTimeFormatter.ofPattern("HHmm"));

            // 현재 시간보다 크지 않은 시간으로
            if (!baseTime.isAfter(currentTime)) {
                long difference = Math.abs(currentTime.until(baseTime, java.time.temporal.ChronoUnit.MINUTES));

                if (difference < minDifference) {
                    minDifference = difference;
                    closestTime = baseTime;
                }
            }
        }

        return closestTime.format(DateTimeFormatter.ofPattern("HHmm"));
    }

    public String loadWeather() {
        return mapper.loadWeather();
    }
}
