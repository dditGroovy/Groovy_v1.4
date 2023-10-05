<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sanction/request.css">

<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-container">
        <header id="tab-header">
            <h1><a href="${pageContext.request.contextPath}/card/request" class="on">법인카드 신청기록</a></h1>
        </header>
        <div class="request-btn">
            <button type="button" class="btn btn-fill-bl-sm font-18 btn-modal" data-name="requestCard"
                    data-action="request">
                법인카드
                신청
                <i class="icon i-add-white"></i></button>
        </div>
        <br><br>
        <div id="countWrap" class="color-font-md">전체 <span id="countBox" class="font-b font-14"></span></div>
        <div id="record" class="card-df">

        </div>
    </div>


    <div id="modal" class="modal-dim">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm requestCard">
            <div class="modal-top">
                <div class="modal-title">법인카드 신청</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <form action="${pageContext.request.contextPath}/card/request" method="post"
                      id="cardRequestForm">
                    <div class="modal-content input-wrap">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <table class="form">
                            <input type="hidden" name="cprCardResveEmplId" value="${CustomUser.employeeVO.emplId}"/>
                            <tr>
                                <th>기간</th>
                                <td class="date-area input-date">
                                    <input type="date" name="cprCardResveBeginDate" class="input-free-white"
                                           placeholder="시작 날짜" required> ~
                                    <input type="date" name="cprCardResveClosDate" class="input-free-white"
                                           placeholder="끝 날짜" required>
                                </td>
                            </tr>
                            <tr>
                                <th>사용처</th>
                                <td>
                                    <input type="text" name="cprCardUseLoca" class="input-free-white" required>
                                </td>
                            </tr>
                            <tr>
                                <th>사용목적</th>
                                <td><textarea name="cprCardUsePurps" class="input-free-white" cols="30" rows="10"
                                              required></textarea>
                                </td>
                            </tr>
                            <tr>
                                <th>사용예상금액</th>
                                <td>
                                    <input type="text" name="cprCardUseExpectAmount" class="input-free-white" required>
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
        <div class="modal-layer card-df sm detailCard">
            <div class="modal-top">
                <div class="modal-title">법인카드 신청 내용</div>
                <button type="button" class="modal-close btn close">
                    <i class="icon i-close close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <form action="${pageContext.request.contextPath}/card/modify/request" method="post"
                      id="cardModifyForm">
                    <div class="modal-content input-wrap">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <table class="form">
                            <input type="hidden" name="cprCardResveEmplId" value="${CustomUser.employeeVO.emplId}"/>
                            <input type="hidden" name="cprCardResveSn" id="sanctionNum"/>
                            <tr>
                                <th>기간</th>
                                <td class="date-area">
                                    <input type="date" name="cprCardResveBeginDate" class="input-free-white"
                                           placeholder="시작 날짜" disabled> ~
                                    <input type="date" name="cprCardResveClosDate" class="input-free-white"
                                           placeholder="끝 날짜" disabled>
                                </td>
                            </tr>
                            <tr>
                                <th>사용처</th>
                                <td>
                                    <input type="text" name="cprCardUseLoca" class="input-free-white" disabled>
                                </td>
                            </tr>
                            <tr>
                                <th>사용목적</th>
                                <td><textarea name="cprCardUsePurps" class="input-free-white" cols="30" rows="10"
                                              disabled></textarea>
                                </td>
                            </tr>
                            <tr>
                                <th>사용예상금액</th>
                                <td>
                                    <input type="text" name="cprCardUseExpectAmount" class="input-free-white" disabled>
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
            </div>
            <div class="modal-footer btn-wrapper">
                <div id="beforeBtn">
                    <button type="button" class="btn btn-fill-bl-sm" id="modifyRequest">수정하기</button>
                    <button type="button" class="btn btn-fill-bl-sm" id="startSanction">결재하기</button>
                </div>
                <div id="submitBtn" style="display: none">
                    <button type="submit" class="btn btn-fill-bl-sm" id="modifySubmit" form="cardRequestForm">저장하기
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
                url: "/card/record",
                type: "GET",
                success: function (data) {
                    count = data.length;
                    document.querySelector("#countBox").innerText = count;
                    let code = `<table border="1" class='requestTable'>
                        <thead><tr>
                            <th>신청 번호</th>
                            <th>사용 기간</th>
                            <th>사용처</th>
                            <th>사용 목적</th>
                            <th>사용 예상 금액</th>
                            <th>결재 상태</th>
                            <th>상세 내용</th>
                        </tr></thead><tbody>`;
                    if (data.length === 0) {
                        code += `<tr>
                            <td colspan="5">법인 카드 신청 기록이 없습니다.</td>
                        </tr>`
                    } else {
                        $.each(data, function (index, recodeVO) {
                            code += `<tr>
                            <td>\${index + 1}</td>
                            <td>\${recodeVO.cprCardResveBeginDate} - \${recodeVO.cprCardResveClosDate}</td>
                            <td>\${recodeVO.cprCardUseLoca}</td>
                            <td>\${recodeVO.cprCardUsePurps}</td>
                            <td>\${formatNumber(recodeVO.cprCardUseExpectAmount)}원</td>
                            <td>\${recodeVO.commonCodeYrycState === 'YRYC030' ? '미상신' : (recodeVO.commonCodeYrycState === 'YRYC031' ? '상신' : '승인')}</td>
                           <td><p class="state"><button href="#" data-name="detailCard" data-seq="\${recodeVO.cprCardResveSn}"
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

        const startDateName = "cprCardResveBeginDate";
        const endDateName = "cprCardResveClosDate";

        setDate(startDateName)
        setDate(endDateName)
        setMinDate(startDateName)
        setMinDate(endDateName)

        const detailCard = document.querySelector(".detailCard");
        const detailLink = document.querySelectorAll(".detailLink");

        document.addEventListener('click', function (event) {
            if (event.target.classList.contains('detailLink')) {
                const num = event.target.getAttribute('data-seq');
                loadDetail(num);
            }
        });

        let childWindow;

        function openChildWindow() {
            childWindow = window.open('/sanction/format/DEPT011/SANCTN_FORMAT010', '결재', getWindowSize());
        }

        function checkChildWindow() {
            if (childWindow && childWindow.closed) {
                $("#modifyRequest").prop("disabled", false);
            } else {
                setTimeout(checkChildWindow, 1000);
            }
        }

        function refreshParent() {
            location.reload();
        }

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
            $("#modifyRequest").prop("disabled", true);
            openChildWindow();
            checkChildWindow();
        });


        // 수정 후 제출
        $("#modifySubmit").on("click", function () {
            event.preventDefault();
            if (validateDate("cardModifyForm", startDateName, endDateName) && validateEmpty("cardModifyForm")) {
                submitAjax("cardModifyForm");
            }
        })
        // 사용 신청 제출
        $("#requestCard").on("click", function () {
            event.preventDefault();
            if (validateDate("cardRequestForm", startDateName, endDateName) && validateEmpty("cardRequestForm")) {
                Swal.fire({
                    text: "신청하시겠습니까??",
                    showCancelButton: true,
                    confirmButtonColor: '#5796F3FF',
                    cancelButtonColor: '#e1e1e1',
                    confirmButtonText: '확인',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
                        submitAjax("cardRequestForm");
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
                url: `/card/data/\${num}`,
                success: function (data) {
                    modalOpen();
                    detailCard.classList.add("on");
                    let form = $("#cardModifyForm");

                    for (let key in data) {
                        if (data.hasOwnProperty(key)) {
                            let value = data[key];
                            let inputElements = form.find(`input[name="\${key}"]`);
                            let textareaElement = form.find(`textarea[name="\${key}"]`);

                            if (inputElements.length) {
                                if (key === "cprCardUseExpectAmount") {
                                    value = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + "원";
                                }
                                inputElements.val(value);
                                inputElements.css("border", "none");
                            }
                            if (textareaElement.length) {
                                textareaElement.val(value);
                                textareaElement.css("border", "none");
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
        $("#modifyRequest").on("click", function () {
            let form = $("#cardModifyForm");
            let inputElement = form.find("input[name='cprCardUseExpectAmount']");
            let value = inputElement.val();
            value = value.replace(/,/g, '').replace('원', '');
            inputElement.val(value);

            let inputElements = form.find("input, textarea");
            inputElements.each(function () {
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
            let form = $("#cardModifyForm");
            let inputElements = form.find("input, textarea");
            inputElements.each(function () {
                $(this).css("border", "none");
            });
        }
    </script>
</sec:authorize>

