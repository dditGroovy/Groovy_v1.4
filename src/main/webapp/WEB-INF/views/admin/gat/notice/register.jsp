<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="content-container">
    <form action="#" method="post"
          enctype="multipart/form-data" id="uploadForm">
        <label for="noti-title">공지 제목</label>
        <input type="text" name="notiTitle" id="noti-title" required><br/>
        <label for="noti-content">공지 내용</label>
        <textarea cols="50" rows="10" name="notiContent" id="noti-content" required></textarea><br>
        <label for="noti-category">카테고리</label>
        <select name="notiCtgryIconFileStreNm" id="noti-category">
            <option value="important.png">중요</option>
            <option value="notice.png">공지</option>
            <option value="event.png">행사</option>
            <option value="obituary.png">부고</option>
        </select>
        <br>
        <label for="noti-file">파일 첨부</label>
        <input type="file" name="notiFiles" id="noti-file" multiple><br/>
        <button type="button" id="submitBtn">등록</button>
    </form>
</div>
<script>
    let maxNum;

    $("#submitBtn").on("click", function () {
        let form = $('#uploadForm')[0];
        let formData = new FormData(form);

        $.ajax({
            url: "/notice/input",
            type: 'POST',
            data: formData,
            dataType: 'text',
            contentType: false,
            processData: false,
            success: function (notiEtprCode) {
                console.log(notiEtprCode);
                // 최대 알람 번호 가져오기
                $.get("/alarm/getMaxAlarm")
                    .then(function (maxNum) {
                        maxNum = parseInt(maxNum) + 1;
                        console.log("최대 알람 번호:", maxNum);

                        let url = '/notice/detail?notiEtprCode=' + notiEtprCode;
                        let content = `<div class="alarmBox">
                                            <a href="\${url}" class="aTag" data-seq="\${maxNum}">
                                                <h1>[전체공지]</h1>
                                                <p>관리자로부터 전체 공지사항이 등록되었습니다.</p>
                                            </a>
                                            <button type="button" class="readBtn">읽음</button>
                                        </div>`;

                        let alarmVO = {
                            "ntcnSn": maxNum,
                            "ntcnUrl": url,
                            "ntcnCn": content,
                            "commonCodeNtcnKind": 'NTCN013'
                        };

                        // 알림 생성 및 페이지 이동
                        $.ajax({
                            type: 'post',
                            url: '/alarm/insertAlarm',
                            data: alarmVO,
                            success: function (rslt) {
                                if (socket) {
                                    let msg = maxNum + ",noti," + url;
                                    socket.send(msg);
                                }
                                location.href = "/notice/manage";
                            },
                            error: function (xhr) {
                                console.log(xhr.status);
                            }
                        });
                    })
                    .catch(function (error) {
                        console.log("최대 알람 번호 가져오기 오류:", error);
                    });
            },
            error: function (xhr) {
                console.log(xhr.status)
            }
        })
    });
</script>