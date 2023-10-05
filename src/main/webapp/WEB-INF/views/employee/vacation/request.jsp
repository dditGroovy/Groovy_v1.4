<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sanction/request.css">

<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-container">
        <header id="tab-header">
            <h1><a href="${pageContext.request.contextPath}/vacation">내 휴가</a></h1>
            <h1><a href="${pageContext.request.contextPath}/employee/confirm/salary">내 급여</a></h1>
            <h1><a href="${pageContext.request.contextPath}/vacation/request" class="on">휴가 기록</a></h1>
        </header>
        <div class="request-btn">
            <button type="button" class="btn btn-fill-bl-sm font-18 btn-modal" data-name="requestVacation"
                    data-action="request" id="requestVacation">휴가 신청
                <i class="icon i-add-white"></i></button>
        </div>
        <div id="countWrap" class="color-font-md">전체 <span id="countBox" class="font-b font-14"></span></div>
        <div id="record" class="card-df">

        </div>
    </div>

    <div id="modal" class="modal-dim">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm requestVacation">
            <div class="modal-top">
                <div class="modal-title">휴가 신청</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <form action="${pageContext.request.contextPath}/vacation/request" method="post"
                      id="vacationRequestForm">
                    <div class="modal-content input-wrap">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <table class="form">
                            <input type="hidden" name="yrycUseDtlsEmplId" value="${CustomUser.employeeVO.emplId}"/>
                            <tr>
                                <th>휴가 구분</th>
                                <td>
                                    <input type="radio" name="commonCodeYrycUseKind" value="YRYC010">
                                    <label for="vacation1">연차</label>

                                    <input type="radio" name="commonCodeYrycUseKind" value="YRYC011">
                                    <label for="vacation2">공가</label>
                                </td>
                            </tr>
                            <tr>
                                <th>종류</th>
                                <td>
                                    <input type="radio" name="commonCodeYrycUseSe" value="YRYC020">
                                    <label for="morning">오전 반차</label>
                                    <input type="radio" name="commonCodeYrycUseSe" value="YRYC021">
                                    <label for="afternoon">오후 반차</label>
                                    <input type="radio" name="commonCodeYrycUseSe" value="YRYC022">
                                    <label for="allDay">종일</label>
                                </td>
                            </tr>
                            <tr>
                                <th>기간</th>
                                <td class="input-date">
                                    <input type="date" name="yrycUseDtlsBeginDate" placeholder="시작 날짜"> ~
                                    <input type="date" name="yrycUseDtlsEndDate" placeholder="끝 날짜">
                                </td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td>
                                <textarea name="yrycUseDtlsRm" cols="30" rows="10"
                                ></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
            </div>
            <div class="modal-footer btn-wrapper">
                <button type="submit" class="btn btn-fill-bl-sm" id="requestCard">확인</button>
                <button type="button" class="btn btn-fill-wh-sm close">취소</button>
            </div>
        </div>


            <%--   디테일/수정 모달     --%>
        <div class="modal-layer card-df sm detailVacation">
            <div class="modal-top">
                <div class="modal-title">휴가 신청 내용</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <form action="${pageContext.request.contextPath}/vacation/modify/request" method="post"
                      id="vacationModifyForm">
                    <div class="modal-content input-wrap">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <table class="form">
                            <input type="hidden" name="yrycUseDtlsEmplId" value="${CustomUser.employeeVO.emplId}"/>
                            <input type="hidden" name="yrycUseDtlsSn" id="sanctionNum"/>
                            <tr>
                                <th>휴가 구분</th>
                                <td>
                                    <div class="form-data-list">
                                        <input type="radio" name="commonCodeYrycUseKind" value="YRYC010" id="vacation1">
                                        <label for="vacation1">연차</label>
                                    </div>
                                    <div class="form-data-list">
                                        <input type="radio" name="commonCodeYrycUseKind" value="YRYC011" id="vacation2">
                                        <label for="vacation2">공가</label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>종류</th>
                                <td>
                                    <div class="form-data-list">
                                        <input type="radio" name="commonCodeYrycUseSe" id="morning" value="YRYC020">
                                        <label for="morning">오전 반차</label>
                                    </div>
                                    <div class="form-data-list">
                                        <input type="radio" name="commonCodeYrycUseSe" id="afternoon" value="YRYC021">
                                        <label for="afternoon">오후 반차</label>
                                    </div>
                                    <div class="form-data-list">
                                        <input type="radio" name="commonCodeYrycUseSe" id="allDay" value="YRYC022">
                                        <label for="allDay">종일</label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>기간</th>
                                <td>
                                    <div class="input-date">
                                        <input type="date" name="yrycUseDtlsBeginDate" id="startDay"
                                               placeholder="시작 날짜"> ~
                                        <input type="date" name="yrycUseDtlsEndDate" id="endDay" placeholder="끝 날짜">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td>
                                <textarea name="yrycUseDtlsRm" id="content" cols="30" rows="10"
                                          placeholder="내용"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
            </div>
            <div class="modal-footer btn-wrapper">
                <div id="beforeBtn">
                    <button type="button" class="btn btn-fill-bl-sm" id="modifyVacation">수정하기</button>
                    <button type="button" class="btn btn-fill-bl-sm" id="startSanction">결재하기</button>
                </div>
                <div id="submitBtn" style="display: none">
                    <button type="submit" class="btn btn-fill-bl-sm" id="modifySubmit" form="vacationRequestForm">저장하기
                    </button>
                    <button type="button" class="btn btn-fill-wh-sm close">취소</button>
                </div>
                <button type="button" class="btn btn-fill-wh-sm close" id="closeBtn" hidden="hidden">닫기</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/modal.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/validate.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/sanction.js"></script>
    <script>


        $(document).ready(function () {
            loadRecord()
        });

        function loadRecord() {
            $.ajax({
                url: "/vacation/record",
                type: "GET",
                success: function (data) {
                    count = data.length;
                    document.querySelector("#countBox").innerText = count;
                    let code = `<table border="1" class='requestTable'>
                        <thead><tr>
                        <th>번호</th>
                        <th>휴가 기간</th>
                        <th>휴가 구분</th>
                        <th>휴가 종류</th>
                        <th>결재 상태</th>
                        <th>상세 내용</th>
                        </tr></thead><tbody>`;
                    if (data.length === 0) {
                        code += `<tr>
                            <td colspan="5">휴가 신청 기록이 없습니다.</td>
                        </tr>`
                    } else {
                        $.each(data, function (index, recodeVO) {
                            code += `<tr>
                        <td>\${index + 1}</a></td>
                        <td>\${recodeVO.yrycUseDtlsBeginDate} - \${recodeVO.yrycUseDtlsEndDate}</td>
                        <td>\${recodeVO.commonCodeYrycUseKind}</td>
                        <td>\${recodeVO.commonCodeYrycUseSe}</td>
                        <td>\${recodeVO.commonCodeYrycState}</td>
                        <td><p class="state"><button href="#" data-name="detailVacation" data-seq="\${recodeVO.yrycUseDtlsSn}"
                               class="detailLink btn">자세히</button></p></td>
                    </tr>`;

                        });
                    }
                    code += "</tbody></table>"
                    $("#record").html(code);
                },
                error: function (xhr, status, error) {
                    console.log("code: " + xhr.status);
                }
            });
        }


        const startDateName = "yrycUseDtlsBeginDate";
        const endDateName = "yrycUseDtlsEndDate";

        setDate(startDateName)
        setDate(endDateName)
        setMinDate(startDateName)
        setMinDate(endDateName)

        const detailVacation = document.querySelector(".detailVacation");
        const detailLink = document.querySelectorAll(".detailLink");


        document.addEventListener('click', function (event) {
            if (event.target.classList.contains('detailLink')) {
                const num = event.target.getAttribute('data-seq');
                loadDetail(num);
            }
        });


        // 결재하기 시작
        let param;
        let childWindow;
        let vacationKind;
        const sign = '${CustomUser.employeeVO.signPhotoFileStreNm}'
        $("#startSanction").on("click", function () {
            if (sign === 'groovy_noSign.png') {
                Swal.fire({
                    text: '서명 등록이 필요합니다',
                    showConfirmButton: false,
                    timer: 1500
                })
                return;
            }
            $("#modifyVacation").prop("disabled", true)
            openChildWindow()
            checkChildWindow()
        })

        function openChildWindow() {
            if (vacationKind === 'YRYC010') {
                param = 'SANCTN_FORMAT011'
            } else {
                param = 'SANCTN_FORMAT012'
            }
            childWindow = window.open(`/sanction/format/DEPT010/\${param}`, '결재', getWindowSize());
        }

        function checkChildWindow() {
            if (childWindow && childWindow.closed) {
                $("#modifyVacation").prop("disabled", false);
            } else {
                setTimeout(checkChildWindow, 1000);
            }
        }


        // 수정 후 제출
        $("#modifySubmit").on("click", function () {
            event.preventDefault();
            if (validateDate("vacationModifyForm", startDateName, endDateName) && validateEmpty("vacationModifyForm")) {
                submitAjax("vacationModifyForm");
            }
        })
        // 사용 신청 제출
        $("#requestCard").on("click", function () {
            event.preventDefault();
            if (validateDate("vacationRequestForm", startDateName, endDateName) && validateEmpty("vacationRequestForm")) {
                Swal.fire({
                    text: "신청하시겠습니까??",
                    showCancelButton: true,
                    confirmButtonColor: '#5796F3FF',
                    cancelButtonColor: '#e1e1e1',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
                        submitAjax("vacationRequestForm");
                    } else {
                        return false;
                    }
                })
            }
        })

        function submitAjax(formId) {
            let formData = $("#" + formId).serialize();
            $.ajax({
                type: "POST",
                url: $("#" + formId).attr("action"),
                data: formData,
                success: function (res) {
                    Swal.fire({
                        text: '신청이 완료되었습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                    modalClose()
                    resetModal();
                    loadRecord()
                },
                error: function (error) {
                    Swal.fire({
                        text: '신청에 실패하였습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                }
            });
        }

        function loadDetail(num) {
            $.ajax({
                type: "GET",
                url: `/vacation/data/\${num}`,
                success: function (data) {
                    modalOpen();
                    detailVacation.classList.add("on");
                    let form = $("#vacationModifyForm");
                    vacationKind = data.commonCodeYrycUseKind;
                    for (let key in data) {
                        if (data.hasOwnProperty(key)) {
                            let value = data[key];
                            let inputElements = form.find(`input[name="\${key}"]`);
                            let textareaElement = form.find(`textarea[name="\${key}"]`);
                            let radioElements = form.find(`input[name="\${key}"][type="radio"]`);


                            if (radioElements.length) {
                                radioElements.each(function () {
                                    if ($(this).val() === value) {
                                        $(this).prop("checked", true);
                                    }
                                    radioElements.prop("disabled", true);
                                });
                            } else {
                                inputElements.val(value);
                                inputElements.css("border", "none");
                                inputElements.prop("readonly", true);
                            }
                            if (textareaElement.length) {
                                textareaElement.val(value);
                                textareaElement.css("border", "none");
                                textareaElement.prop("readonly", true);
                            }
                        }
                    }
                    if (data['commonCodeYrycState'] === 'YRYC030') {
                        $('#beforeBtn').css("display", "");
                        $('#closeBtn').prop("hidden", true);
                    } else {
                        $('#beforeBtn').css("display", "none");
                        $('#closeBtn').prop("hidden", false);
                    }

                },
                error: function (error) {
                    console.log("loadDatail 실패")
                }
            });
        }

        // 수정하기 버튼 클릭 시
        $("#modifyVacation").on("click", function () {
            let form = $("#vacationModifyForm");
            let inputElements = form.find("input, textarea");
            let radioElement = form.find("input[type='radio']");
            inputElements.each(function () {
                $(this).removeAttr("readonly");
                $(this).css("border", "1px solid var(--color-stroke)");
            });
            radioElement.each(function () {
                $(this).removeAttr("disabled");
                $(this).css("border", "");
            });
            $("#beforeBtn").css("display", "none");
            $("#submitBtn").css("display", "");
        });

        $(".close").on("click", function () {
            resetModal();
        });

        function resetModal() {
            $("#beforeBtn").css("display", "");
            $("#submitBtn").css("display", "none");
            let form = $("#vacationModifyForm");
            let inputElements = form.find("input, textarea");
            inputElements.each(function () {
                $(this).css("border", "none");
            });
        }
    </script>
</sec:authorize>