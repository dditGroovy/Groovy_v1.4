<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/resources/favicon.svg">
    <link rel="stylesheet" href="/resources/css/common.css">
    <link rel="stylesheet" href="/resources/css/password/password.css">
</head>
<body>
<div class="container init-wrap find-wrap">
    <main>
        <h1 style="display: none">그루비 비밀번호 찾기</h1>
        <div class="welcome-img-wrap">
            <img src="/resources/images/logo2.png" alt="groovy" class="welcome-img">
        </div>
        <div class="welcome-wrap">
            <h2 class="font-b font-32">비밀번호 찾기 &#129488;</h2>
            <p>사번을 입력해주세요</p>
        </div>
        <div class="init-div">
            <div class="input-wrap">
                <input type="text" name="emplId" id="emplId" class="btn-free-white input-l" placeholder="사번"/>
                <a href="${pageContext.request.contextPath}/" class="font-14 color-font-row" style="align-self: flex-end;">로그인으로 돌아가기</a>
            </div>
            <div class="btn-wrap">
                <div class="error"></div>
                <button type="button" class="btn btn-free-blue input-l">확인</button>
            </div>
        </div>
    </main>
</div>
</body>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
    $("button").on("click", function () {
        let emplId = $("#emplId").val();
        $.ajax({
            url: "/employee/findTelNo",
            type: "post",
            data: {"emplId": emplId},
            success: function (result) {
                if (result == "exists") {
                    Swal.fire({
                        text: '등록된 휴대폰 번호로 임시 비밀번호를 전송합니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                    $.ajax({
                        url: "/employee/findPassword",
                        data: {"emplId": emplId},
                        type: "post",
                        success: function (result) {
                            if (result == "success") {
                                alert("");
                                Swal.fire({
                                    text: '비밀번호가 초기화 되었습니다 로그인 화면으로 이동합니다',
                                    showConfirmButton: false,
                                    timer: 1500
                                })
                                location.href = "/employee/signIn";
                            }
                        },
                        error: function (xhr, textStatus, error) {
                            console.log("AJAX 오류:", error);
                        }
                    })
                } else if (result == "null") {
                    $(".error").text("등록되지 않은 사번입니다. 다시 시도하거나 인사팀에 문의하세요");
                }

            },
            error: function (xhr, textStatus, error) {
                console.log("AJAX 오류:", error);
            }
        });
    })
</script>
</html>