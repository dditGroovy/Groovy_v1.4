<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script src="/resources/ckeditor/ckeditor.js"></script>

<style>
    .cke_top, .cke_bottom {
        display: none !important;
    }
    .cke_1_contents {
        border: none;
    }
    .cke_chrome {
        border: none;
    }
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/job/job.css">
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/job/main">할 일</a></h1>
        <h1><a href="${pageContext.request.contextPath}/job/jobDiary" class="on">업무 일지</a></h1>
    </header>
    <main>
        <div class="main-inner">
            <div id="detail" class="card card-df">
                <table class="form">
                    <tr>
                        <th>제목</th>
                        <td id="subject">${vo.jobDiarySbj}</td>
                    </tr>
                    <tr>
                        <th>작성자</th>
                        <td id="writer">${vo.jobDiaryWrtingEmplNm}</td>
                    </tr>
                    <tr>
                        <th>작성 날짜</th>
                        <td id="date">${vo.jobDiaryReportDate}</td>
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td><textarea id="editor" name="editor">${vo.jobDiaryCn}</textarea></td>
                    </tr>
                </table>
                <div class="btn-wrap">
                    <button type="button" id="goDiary" class="btn btn-fill-bl-sm">목록으로</button>
                </div>
            </div>
        </div>
    </main>
</div>
<script>
    CKEDITOR.replace('editor');
    $("#editor").attr("readOnly", true);

    /*window.onload = function () {
        document.querySelector("#cke_1_top").style.display = "none";
        document.querySelector("#cke_1_bottom").style.display = "none";
    }*/
    let goDiary = document.querySelector("#goDiary");
    goDiary.addEventListener("click", function () {
        window.location.href = "/job/jobDiary";
    });
</script>