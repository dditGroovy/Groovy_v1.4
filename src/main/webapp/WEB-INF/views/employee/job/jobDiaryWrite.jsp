<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="/resources/ckeditor/ckeditor.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/job/job.css">
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/job/main">할 일</a></h1>
        <h1><a href="${pageContext.request.contextPath}/job/jobDiary" class="on">업무 일지</a></h1>
    </header>
    <main>
        <div class="main-inner">
            <div id="detail" class="card card-df">
                <form action="/job/insertDiary" method="post" enctype="multipart/form-data" style="width: 100%;">
                    <table class="form">
                        <tr>
                            <th>제목</th>
                            <td><input type="text" name="jobDiarySbj" placeholder="제목을 입력해주세요." required class="jobDiarySbj" /></td>
                        </tr>
                        <tr>
                            <th>등록일</th>
                            <td id="today"></td>
                            </td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td>
                                <textarea id="editor" name="jobDiaryCn" required></textarea>
                            </td>
                        </tr>
                    </table>
                    <div class="btn-wrap">
                        <button type="button" id="goDiary" class="btn btn-fill-wh-sm">목록으로</button>
                        <button type="submit" class="btn btn-fill-bl-sm">등록하기</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
<script>
    var editor = CKEDITOR.replace("editor", {
        extraPlugins: 'notification'
    });

    let date = new Date();
    let year = date.getFullYear();
    let month = date.getMonth() + 1;
    month = month < 10 ? month = `0\${month}` : month;
    let day = date.getDate();
    day = day < 10 ? day = `0\${day}` : day;
    let todayString = `\${year}-\${month}-\${day}`;
    let today = document.querySelector("#today");
    today.innerHTML = todayString;
    let goDiary = document.querySelector("#goDiary");
    goDiary.addEventListener("click", function () {
        window.location.href = "/job/jobDiary";
    });

    editor.on('required', function (evt) {
        editor.showNotification('This field is required.', 'warning');
        evt.cancel();
    });
</script>
