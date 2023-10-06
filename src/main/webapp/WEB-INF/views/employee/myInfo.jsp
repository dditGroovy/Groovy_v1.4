<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee/myInfo.css">
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-container">

        <header id="tab-header">
            <h1><a href="${pageContext.request.contextPath}/employee/myInfo" class="on">내 정보 관리</a></h1>
        </header>


        <div class="info-btn">
            <button type="button" id="saveButton" class="btn btn-fill-bl-sm "> 저장</button>
            <button type="button" id="modifyPass" class="btn btn-fill-wh-sm  btn-modal"
                    data-name="modifyPassword" data-action="modify">비밀번호 변경
            </button>
        </div>
        <div class="info-content">
            <section class="left">
                <div class="section-inner flex-inner">
                    <div class="profile-wrap card-df pd-32">
                        <div class="info-header ">
                            <img src="${pageContext.request.contextPath}/resources/images/Icon3d/change.png"
                                 class="info-icon"/>
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
                            <img src="${pageContext.request.contextPath}/resources/images/Icon3d/Key.png"
                                 class="info-icon"/>
                            <div>
                                <h2 class="info-title font-b">서명 설정</h2>
                                <p class="info-desc  font-md">전자결재에 필요한 서명을 설정합니다.</p>
                            </div>
                        </div>
                        <div class="info-body">
                            <form id="signForm" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <input type="hidden" name="emplId"
                                       value="${CustomUser.employeeVO.emplId}"><br/>
                                <label for="emplSignFile">
                                    <c:choose>
                                        <c:when test="${CustomUser.employeeVO.signPhotoFileStreNm=='groovy_noSign.png'}">
                                            <img id="userSignProfile"
                                                 src="${pageContext.request.contextPath}/resources/images/noSign.png"
                                                 alt="signImage"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img id="userSignProfile"
                                                 src="${pageContext.request.contextPath}/uploads/sign/${CustomUser.employeeVO.signPhotoFileStreNm}"
                                                 alt="signImage"/>
                                        </c:otherwise>
                                    </c:choose>
                                        <%--                                            <div class="sign-btn"><i class="icon i-add"></i>등록하기</div>--%>
                                </label>
                                <input type="file" name="signPhotoFile" id="emplSignFile" hidden="hidden"/>

                            </form>
                        </div>
                    </div>
                </div>
            </section>
            <section class="right">
                <div class="alert-wrap card-df pd-32 ">
                    <div class="info-header ">
                        <img src="${pageContext.request.contextPath}/resources/images/Icon3d/alarm.png"
                             class="info-icon"/>
                        <div>
                            <h2 class="info-title font-b">알림 설정</h2>
                            <p class="info-desc font-md">알림 범위를 설정합니다.</p>
                        </div>
                    </div>
                    <div class="info-body">
                        <form action="#" id="alertForm">
                            <div class="box-toggle" style="margin-top: 3%">
                                <p class="toggle-title  font-14 ">업무 요청</p>
                                <label class="toggle" for="dutyRequest">
                                    <input type="checkbox" id="dutyRequest" name="dutyRequest"
                                           value="${CustomUser.employeeVO.notificationVO.dutyRequest}">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div class="box-toggle">
                                <p class="toggle-title font-14">댓글</p>
                                <label class="toggle" for="answer">
                                    <input type="checkbox" id="answer" name="answer"
                                           value="${CustomUser.employeeVO.notificationVO.answer}">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div class="box-toggle">
                                <p class="toggle-title font-14">팀 커뮤니티</p>
                                <label class="toggle" for="teamNotice">
                                    <input type="checkbox" id="teamNotice" name="teamNotice"
                                           value="${CustomUser.employeeVO.notificationVO.teamNotice}">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div class="box-toggle">
                                <p class="toggle-title font-14">공지사항</p>
                                <label class="toggle" for="companyNotice">
                                    <input type="checkbox" id="companyNotice" name="companyNotice"
                                           value="${CustomUser.employeeVO.notificationVO.companyNotice}">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div class="box-toggle">
                                <p class="toggle-title font-14">일정</p>
                                <label class="toggle" for="schedule">
                                    <input type="checkbox" id="schedule" name="schedule"
                                           value="${CustomUser.employeeVO.notificationVO.schedule}">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div class="box-toggle">
                                <p class="toggle-title font-14">채팅 방 개설 알림</p>
                                <label class="toggle" for="newChattingRoom">
                                    <input type="checkbox" id="newChattingRoom" name="newChattingRoom"
                                           value="${CustomUser.employeeVO.notificationVO.newChattingRoom}">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div class="box-toggle">
                                <p class="toggle-title font-14">메일 수신 알림</p>
                                <label class="toggle" for="emailReception">
                                    <input type="checkbox" id="emailReception" name="emailReception"
                                           value="${CustomUser.employeeVO.notificationVO.emailReception}">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div class="box-toggle">
                                <p class="toggle-title font-14">전자 결재 수신</p>
                                <label class="toggle" for="electronSanctionReception">
                                    <input type="checkbox" id="electronSanctionReception"
                                           name="electronSanctionReception"
                                           value="${CustomUser.employeeVO.notificationVO.electronSanctionReception}">
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div class="box-toggle">
                                <p class="toggle-title font-14">전자 결재 결과</p>
                                <label class="toggle" for="electronSanctionResult">
                                    <input type="checkbox" id="electronSanctionResult" name="electronSanctionResult"
                                           value="${CustomUser.employeeVO.notificationVO.electronSanctionResult}">
                                    <span class="slider"></span>
                                </label>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="alert-wrap card-df pd-32 ">
                    <div class="info-header ">
                        <img src="${pageContext.request.contextPath}/resources/images/Icon3d/User.png"
                             class="info-icon"/>
                        <div>
                            <h2 class="info-title font-b">내 정보</h2>
                            <p class="info-desc font-md">개인 정보를 확인 · 변경합니다.</p>
                        </div>
                    </div>
                    <div class="info-body my-info">

                        <form name="" id="myInfoForm" method="post">
                            <div class="">
                                <label>사번</label> <br/>
                                <input type="text" value="${CustomUser.employeeVO.emplId}" name="emplId"
                                       readonly><br/>
                            </div>
                            <div class="">
                                <label>직무</label> <br/>
                                <input type="text" value="${CustomUser.employeeVO.deptNm}"
                                       readonly><br/>
                            </div>
                            <div class="">
                                <label>이메일</label> <br/>
                                <input type="text" value="${CustomUser.employeeVO.emplEmail}" readonly><br/>
                            </div>
                            <div class="">
                                <div class="tel-div">
                                    <button type="button" id="modifyTel" class="btn font-11 modify-btn">연락처 수정
                                            <%--                                        <img--%>
                                            <%--                                            class="modify-icon"--%>
                                            <%--                                            src="${pageContext.request.contextPath}/resources/images/modifySign.png"/>--%>
                                    </button>
                                </div>
                                <label>연락처</label>
                                <input type="text"
                                       value="${CustomUser.employeeVO.emplTelno}"
                                       name="emplTelno" readonly>
                            </div>

                            <div class="accordion-row">
                                <div class="addr-div">
                                    <button type="button" id="findZip" class="btn  font-11 modify-btn">
                                        주소 수정
                                    </button>
                                </div>
                                <div class="addrWrap">
                                    <label>우편번호</label>
                                    <input type="text" name="emplZip" class="emplZip"
                                           value="${CustomUser.employeeVO.emplZip}" readonly><br/>
                                    <div>
                                        <label>주소</label><br/>
                                        <input type="text" name="emplAdres" class="emplAdres"
                                               value="${CustomUser.employeeVO.emplAdres}" readonly>
                                    </div>
                                    <div>
                                        <label>상세주소</label>
                                        <input type="text" name="emplDetailAdres" class="emplDetailAdres"
                                               value="${CustomUser.employeeVO.emplDetailAdres}" readonly>
                                    </div>
                                </div>
                            </div>
                        </form>


                    </div>
                </div>
            </section>
        </div>


            <%--

            비밀번호 수정 모달

                 --%>
        <div id="modal" class="modal-dim">
            <div class="dim-bg"></div>
            <div class="modal-layer card-df sm modifyPassword">
                <div class="modal-top">
                    <div class="modal-title">비밀번호 변경</div>
                    <button type="button" class="modal-close btn close">
                        <i class="icon i-close close">X</i>
                    </button>
                </div>
                <div class="modal-container">
                    <div class="pass-wrap">
                        <form method="post" id="passForm">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="emplId" value="${CustomUser.employeeVO.emplId}">

                            <div class="current-pass">
                                <label for="emplPassword">현재 비밀번호 입력</label>
                                <div>
                                    <input type="password" name="currentPassword" id="emplPassword"
                                           placeholder="현재 비밀번호를 입력하세요."/>
                                </div>
                            </div>
                            <div class="new-pass">
                                <label for="emplPasswordCheck1">새로운 비밀번호 입력</label>
                                <div>
                                    <input type="password" name="newPassword" id="emplPasswordCheck1"
                                           placeholder="새로운 비밀번호를 입력하세요."/>
                                    <input type="password" name="reEmplPassword" placeholder="새로운 비밀번호를 입력하세요."/>
                                </div>
                            </div>
                        </form>
                        <div id="modifyRes">

                        </div>
                    </div>
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
<script src="${pageContext.request.contextPath}/resources/js/validate.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
    // 패스워드 변경
    $("#iSave").on("click", function () {
        let newPassword = $('input[name="newPassword"]').val();
        let reEnteredPassword = $('input[name="reEmplPassword"]').val();

        if (newPassword !== reEnteredPassword) {
            $("#modifyRes").html('새로운 비밀번호가 일치하지 않습니다.');
            return;
        } else if (!validatePassword(newPassword)) {
            $("#modifyRes").html('비밀번호는 영문자, 숫자, 특수문자 조합의 8~20자리를 사용해야 합니다.');
            return;
        }
        let formData = new FormData($("#passForm")[0]);
        $.ajax({
            type: "POST",
            url: "/employee/modifyPassword",
            data: formData,
            contentType: false,
            processData: false,
            success: function (response) {
                if (response === 'incorrect') {
                    $("#modifyRes").html('현재 비밀번호를 확인해 주세요.')
                } else {
                    Swal.fire({
                        text: '비밀번호 변경이 완료되었습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                    modalClose()
                }
            },
            error: function (xhr, textStatus, error) {
                Swal.fire({
                    text: '비밀번호 변경에 실패하였습니다',
                    showConfirmButton: false,
                    timer: 1500
                })
            }
        });
    });

    // 이미지 미리보기(프로필/서명)
    function previewImage(inputFieldId, imageId) {
        $(inputFieldId).on("change", function (e) {
            let file = e.target.files[0];
            let reader = new FileReader();
            reader.onload = function (e) {
                $(imageId).attr("src", e.target.result);
            };
            reader.readAsDataURL(file);
        });
    }

    previewImage("#empProflPhotoFile", "#profileImage");
    previewImage("#emplSignFile", "#userSignProfile");

    // 프로필/서명 파일 형식 제한
    const allowedExtensions = ["png", "jpg", "jpeg"];

    $("#empProflPhotoFile, #emplSignFile").on("change", function (e) {
        let file = e.target.files[0];
        if (file) {
            let extension = file.name.split(".").pop().toLowerCase();

            if (allowedExtensions.includes(extension)) {
                let reader = new FileReader();
                reader.onload = function (e) {
                    $(this).siblings("img").attr("src", e.target.result);
                };
                reader.readAsDataURL(file);
            } else {
                Swal.fire({
                    text: '허용되지 않은 파일 형식입니다',
                    showConfirmButton: false,
                    timer: 1500
                })
                $(this).val("");
            }
        }
    });

    $("#modifyTel").on("click", function () {
        let telInput = $("input[name='emplTelno']")
        telInput.val("010-")
        telInput.prop("readonly", false)
        telInput.css("border", '1px solid var(--color-stroke)')
        telInput.on('input', function () {
            let telno = telInput.val().replace(/-/g, '');

            if (telno.length >= 4) {
                telno = telno.slice(0, 3) + '-' + telno.slice(3);
            }
            if (telno.length >= 9) {
                telno = telno.slice(0, 8) + '-' + telno.slice(8);
            }
            if (telno.length > 13) {
                telno = telno.slice(0, 13);
            }
            telInput.val(telno);
        });
    })

    $(document).ready(function () {
        initializeCheckboxes();
        // 패스워드 변경 모달
        $("#modifyPass").on("click", function () {
            resetModal()
            openModal();
        })

        $("#findZip").on("click", function () {
            let addrInputs = $(".addrWrap input");
            addrInputs.prop("readonly", false)
            addrInputs.css("border", '1px solid var(--color-stroke)')
            new daum.Postcode({
                oncomplete: function (data) {
                    $(".emplZip").val(data.zonecode);
                    $(".emplAdres").val(data.address);
                    $(".emplDetailAdres").val("");
                    $(".emplDetailAdres").focus();
                }
            }).open();
        })

        // 저장 버튼 클릭 시 모든 변경 사항 업데이트
        $("#saveButton").on("click", function () {
            let profileForm = new FormData($("#profileForm")[0]);
            let profileFile = profileForm.get("profileFile");
            if (profileFile.size !== 0 && profileFile.name !== '') {
                updateProfile();
            }
            let signForm = new FormData($("#signForm")[0]);
            let signFile = signForm.get("signPhotoFile");
            if (signFile.size !== 0 || signFile.name !== '') {
                updateSign();
            }
            updateMyInfo();
            saveNotificationSettings();
            Swal.fire({
                text: '변경 완료!',
                showConfirmButton: false,
                timer: 1500
            })
        });

        // 개인 정보 수정
        function updateMyInfo() {
            let formData = new FormData($("#myInfoForm")[0]);
            $.ajax({
                type: "POST",
                url: "/employee/modifyInfo",
                data: formData,
                contentType: false,
                processData: false,
                cache: false,
                success: function (response) {
                    $(".my-info input").prop("readonly", true)
                    $(".my-info input").css("border", "none")
                },
                error: function (xhr, textStatus, error) {
                    console.log("AJAX 오류:", error);
                }
            });
        }


        // 프로필 사진 수정
        function updateProfile() {
            let formData = new FormData($("#profileForm")[0]);
            $.ajax({
                type: "POST",
                url: "/employee/modifyProfile",
                data: formData,
                contentType: false,
                processData: false,
                cache: false,
                success: function (response) {
                    let newImageUrl = "/uploads/profile/" + response;
                    $("#profileImage").attr("src", newImageUrl);
                    $("#asideProfile").attr("src", newImageUrl);
                    $("#empProflPhotoFile").val("");

                },
                error: function (xhr, textStatus, error) {
                    console.log("AJAX 오류:", error);
                }
            });
        }


        // 서명 사진 수정
        function updateSign() {
            let formData = new FormData($("#signForm")[0]);
            $.ajax({
                type: "POST",
                url: "/employee/modifySign",
                data: formData,
                contentType: false,
                processData: false,
                cache: false,
                success: function (response) {
                    let newImageUrl = "/uploads/sign/" + response;
                    $("#userSignProfile").attr("src", newImageUrl);
                    $("#emplSignFile").val("");

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
                },
                error: function (xhr, textStatus, error) {
                    console.log("AJAX 오류:", error);
                }
            });
        }

        function resetModal() {
            $('input[name="currentPassword"]').val('');
            $('input[name="newPassword"]').val('');
            $('input[name="reEmplPassword"]').val('');
        }
    });
</script>
