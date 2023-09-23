<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="/resources/css/employee/myInfo.css">
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-container">

        <header id="tab-header">
            <h1><a href="${pageContext.request.contextPath}/employee/myInfo" class="on">내 정보 관리</a></h1>
        </header>


        <div class="btn-wrap">
            <button type="button" id="saveButton" class="btn btn-free-white"> 저장</button>
            <button type="button" id="modifyPass" class="btn btn-free-white btn-modal"
                    data-name="modifyPassword" data-action="modify">비밀번호 변경
            </button>
        </div>
        <div class="content-body">
            <section class="left">
                <div class="section-inner flex-inner">
                    <div class="profile-wrap card-df pd-32">
                        <div class="info-header ">
                            <img src="/resources/images/Icon3d/change.png"/>
                            <div>
                                <h2 class="info-title font-b">프로필 변경</h2>
                                <p class="info-desc  font-md">프로필 사진을 변경합니다.</p>
                            </div>
                        </div>
                        <div class="info-body">
                            <form id="profileForm" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="emplId"
                                       value="${CustomUser.employeeVO.emplId}"><br/>
                                <label for="empProflPhotoFile">
                                    <img id="profileImage"
                                         src="${pageContext.request.contextPath}/uploads/profile/${CustomUser.employeeVO.proflPhotoFileStreNm}"
                                         alt="profileImage"/>
                                    <img class="modifyPhoto"
                                         src="${pageContext.request.contextPath}/resources/images/modify.png"/></label>
                                <input type="file" name="profileFile" id="empProflPhotoFile" hidden="hidden"/>
                            </form>
                        </div>
                    </div>


                    <div class="sign-wrap card-df pd-32">
                        <div class="info-header">
                            <img src="/resources/images/Icon3d/Key.png"/>
                            <div>
                                <h2 class="info-title font-b">서명 변경</h2>
                                <p class="info-desc  font-md">전자결재에 필요한 서명을 설정합니다.</p>
                            </div>
                        </div>
                        <div class="info-body">
                            <form id="signForm" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="emplId"
                                       value="${CustomUser.employeeVO.emplId}"><br/>
                                <label for="emplSignFile">
                                    <img id="userSignProfile"
                                         src="${pageContext.request.contextPath}/uploads/sign/${CustomUser.employeeVO.signPhotoFileStreNm}"
                                         alt="signImage"/></label>
                                <input type="file" name="signPhotoFile" id="emplSignFile" hidden="hidden"/>

                            </form>
                        </div>
                    </div>
                </div>
            </section>
            <section class="right">
                <div class="alert-wrap card-df pd-32 ">
                    <div class="info-header ">
                        <img src="/resources/images/Icon3d/alarm.png"/>
                        <div>
                            <h2 class="info-title font-b">알림 설정</h2>
                            <p class="info-desc font-md">알림 범위를 설정합니다.</p>
                        </div>
                    </div>
                    <form action="#">
                        <div class="box-toggle">
                            <p class="toggle-title ">업무 요청</p>
                            <label class="toggle" for="dutyRequest">
                                <input type="checkbox" id="dutyRequest" name="dutyRequest"
                                       value="${CustomUser.employeeVO.notificationVO.dutyRequest}">
                                <span class="slider"></span>
                            </label>
                        </div>
                        <div class="box-toggle">
                            <p class="toggle-title">댓글</p>
                            <label class="toggle" for="answer">
                                <input type="checkbox" id="answer" name="answer"
                                       value="${CustomUser.employeeVO.notificationVO.answer}">
                                <span class="slider"></span>
                            </label>
                        </div>
                        <div class="box-toggle">
                            <p class="toggle-title">팀 커뮤니티</p>
                            <label class="toggle" for="teamNotice">
                                <input type="checkbox" id="teamNotice" name="teamNotice"
                                       value="${CustomUser.employeeVO.notificationVO.teamNotice}">
                                <span class="slider"></span>
                            </label>
                        </div>
                        <div class="box-toggle">
                            <p class="toggle-title">공지사항</p>
                            <label class="toggle" for="companyNotice">
                                <input type="checkbox" id="companyNotice" name="companyNotice"
                                       value="${CustomUser.employeeVO.notificationVO.companyNotice}">
                                <span class="slider"></span>
                            </label>
                        </div>
                        <div class="box-toggle">
                            <p class="toggle-title">일정</p>
                            <label class="toggle" for="schedule">
                                <input type="checkbox" id="schedule" name="schedule"
                                       value="${CustomUser.employeeVO.notificationVO.schedule}">
                                <span class="slider"></span>
                            </label>
                        </div>
                        <div class="box-toggle">
                            <p class="toggle-title">채팅 방 개설 알림</p>
                            <label class="toggle" for="newChattingRoom">
                                <input type="checkbox" id="newChattingRoom" name="newChattingRoom"
                                       value="${CustomUser.employeeVO.notificationVO.newChattingRoom}">
                                <span class="slider"></span>
                            </label>
                        </div>
                        <div class="box-toggle">
                            <p class="toggle-title">메일 수신 알림</p>
                            <label class="toggle" for="emailReception">
                                <input type="checkbox" id="emailReception" name="emailReception"
                                       value="${CustomUser.employeeVO.notificationVO.emailReception}">
                                <span class="slider"></span>
                            </label>
                        </div>
                        <div class="box-toggle">
                            <p class="toggle-title">전자결재수신</p>
                            <label class="toggle" for="electronSanctionReception">
                                <input type="checkbox" id="electronSanctionReception" name="electronSanctionReception"
                                       value="${CustomUser.employeeVO.notificationVO.electronSanctionReception}">
                                <span class="slider"></span>
                            </label>
                        </div>
                        <div class="box-toggle">
                            <p class="toggle-title">전자결재결과</p>
                            <label class="toggle" for="electronSanctionResult">
                                <input type="checkbox" id="electronSanctionResult" name="electronSanctionResult"
                                       value="${CustomUser.employeeVO.notificationVO.electronSanctionResult}">
                                <span class="slider"></span>
                            </label>
                        </div>
                    </form>
                </div>
            </section>
        </div>
            <%--   비밀번호 수정 모달     --%>
        <div id="modal" class="modal-dim">
            <div class="dim-bg"></div>
            <div class="modal-layer card-df sm modifyPassword">
                <div class="modal-top">
                    <div class="modal-title">비밀번호 변경</div>
                    <button type="button" class="modal-close btn js-modal-close">
                        <i class="icon i-close close">X</i>
                    </button>
                </div>
                <div class="modal-container">
                    <form method="post" id="passForm">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <label for="emplPassword">현재 비밀번호 입력</label>
                        <input type="password" name="currentPassword" id="emplPassword" placeholder="현재 비밀번호를 입력하세요."/>
                        <label for="emplPasswordCheck1">새로운 비밀번호 입력</label>
                        <input type="password" name="emplPassword" id="emplPasswordCheck1"
                               placeholder="새로운 비밀번호를 입력하세요."/>
                        <input type="password" name="reEmplPassword" placeholder="새로운 비밀번호를 입력하세요."/>
                        <input type="hidden" name="emplId" readonly value="${CustomUser.employeeVO.emplId}"><br/>
                    </form>
                </div>
                <div class="modal-footer btn-wrapper">
                    <button type="submit" class="btn btn-fill-bl-sm" id="iSave">확인</button>
                    <button type="button" class="btn btn-fill-wh-sm close">취소</button>
                </div>
            </div>
        </div>

    </div>
</sec:authorize>
<script src="${pageContext.request.contextPath}/resources/js/modal.js"></script>
<script>

    // 패스워드 변경
    $("#iSave").on("click", function () {
        let formData = new FormData($("#passForm")[0]);
        $.ajax({
            type: "POST",
            url: "/employee/modifyPassword",
            data: formData,
            contentType: false,
            processData: false,
            success: function (response) {
                alert("비밀번호가 정상적으로 변경되었습니다.");
                close()
            },
            error: function (xhr, textStatus, error) {
                console.log("AJAX 오류:", error);
            }
        });
    });


    $(document).ready(function () {
        initializeCheckboxes();

        $("#modifyPass").on("click", function () {
            openModal();
        })
        // 저장 버튼 클릭 시 모든 변경 사항을 업데이트
        $("#saveButton").on("click", function () {
            let profileForm = new FormData($("#profileForm")[0]);
            let profileFile = profileForm.get("profileFile");
            if (profileFile) {
                updateProfile();
            }
            let signForm = new FormData($("#signForm")[0]);
            let signFile = signForm.get("signPhotoFile");
            if (signFile) {
                updateSign();
            }
            saveNotificationSettings();
        });

        // 프로필 사진 수정
        function updateProfile() {
            $.ajax({
                type: "POST",
                url: "/employee/modifyProfile",
                data: formData,
                contentType: false,
                processData: false,
                cache: false,
                success: function (response) {
                    console.log("프로필 사진 수정 성공", response);
                    var newImageUrl = "/uploads/profile/" + response;
                    $("#profileImage").attr("src", newImageUrl);
                    $("#asideProfile").attr("src", newImageUrl);
                },
                error: function (xhr, textStatus, error) {
                    console.log("AJAX 오류:", error);
                }
            });
        }


        // 서명 사진 수정
        function updateSign() {
            $.ajax({
                type: "POST",
                url: "/employee/modifySign",
                data: formData,
                contentType: false,
                processData: false,
                cache: false,
                success: function (response) {
                    console.log("서명 사진 수정 성공");
                    var newImageUrl = "/uploads/sign/" + response;
                    $("#userSignProfile").attr("src", newImageUrl);
                },
                error: function (xhr, textStatus, error) {
                    console.log("AJAX 오류:", error);
                }
            });
        }

        // 초기 체크 상태 설정
        function initializeCheckboxes() {
            const checkboxIds = ["dutyRequest", "answer", "teamNotice", "companyNotice", "schedule", "newChattingRoom", "emailReception", "electronSanctionReception", "electronSanctionResult"];

            checkboxIds.forEach(function (checkboxId) {
                const checkbox = document.getElementById(checkboxId);
                const value = checkbox.value;
                if (value === "NTCN_AT010") {
                    checkbox.checked = true;
                } else {
                    checkbox.checked = false;
                }
            });
        }

        // 알림 설정 저장
        function saveNotificationSettings() {
            const notificationSettings = {};
            const checkboxIds = ["dutyRequest", "answer", "teamNotice", "companyNotice", "schedule", "newChattingRoom", "emailReception", "electronSanctionReception", "electronSanctionResult"];

            checkboxIds.forEach(function (checkboxId) {
                const checkbox = document.getElementById(checkboxId);
                notificationSettings[checkboxId] = checkbox.checked ? "NTCN_AT010" : "NTCN_AT011";
            });

            $.ajax({
                url: `/employee/modifyNoticeAt/${CustomUser.employeeVO.emplId}`,
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(notificationSettings),
                success: function (data) {
                    console.log("알림 설정 성공");
                },
                error: function (xhr, textStatus, error) {
                    console.log("AJAX 오류:", error);
                }
            });
        }
    });
</script>
