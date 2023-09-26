<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script src="/resources/ckeditor/ckeditor.js"></script>

<style>
    .cke_top, .cke_1_bottom {
        display: none !important;
    }
</style>
<div class="content-container">
    <div id="detail">
        <h2>업무 일지 (상세)</h2>
        <table border="1">
            <tr>
                <td>제목</td>
                <td id="subject">${vo.jobDiarySbj}</td>
            </tr>
            <tr>
                <td>작성자</td>
                <td id="writer">${vo.jobDiaryWrtingEmplNm}</td>
            </tr>
            <tr>
                <td>작성 날짜</td>
                <td id="date">${vo.jobDiaryReportDate}</td>
            </tr>
            <tr>
                <td>내용</td>
                <td><textarea id="editor" name="editor">${vo.jobDiaryCn}</textarea></td>
            </tr>
        </table>
    </div>

    <button type="button" id="goDiary">목록으로</button>
</div>
<script>
    CKEDITOR.replace('editor');
    $("#editor").attr("readOnly", true);

    window.onload = function () {
        document.querySelector("#cke_1_top").style.display = "none";
        document.querySelector("#cke_1_bottom").style.display = "none";
    }
    let goDiary = document.querySelector("#goDiary");
    goDiary.addEventListener("click", function () {
        window.location.href = "/job/jobDiary";
    });
</script>