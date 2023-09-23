<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sanction/sanction.css">
<style>
    .container {
        padding: var(--vh-24) var(--vw-24);
    }
    .file_box {
        border: 2px solid rgb(13 110 253 / 25%);
        border-radius: 10px;
        margin-top: 20px;
        padding: 40px;
        text-align: center;
    }
</style>
<a href="/pdf" class="btn btn-free-blue" id="downBtn">문서 다운로드</a>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-wrapper">
        <div class="content-header">
            <div class="form-header">
                <div class="btn-wrap">
                        <%--    세션에 담긴 사번이 문서의 기안자 사번과 같고 결재 코드가 최초 상신 상태일 때    --%>
                    <c:if test="${CustomUser.employeeVO.emplId == sanction.elctrnSanctnDrftEmplId && sanction.commonCodeSanctProgrs == '상신' }">
                        <button type="button" onclick="collect()" class="btn btn-free-blue" id="collectBtn">회수</button>
                    </c:if>
                            <c:forEach var="lineVO" items="${lineList}" varStatus="stat">
                                <%--&lt;%&ndash; 세션에 담긴 사번이 문서의 결재자 사번과 같고 결재 상태가 대기이며 결재의 상태가 반려가 아닌 경우&ndash;%&gt;--%>
                                <c:if test="${ (CustomUser.employeeVO.emplId == lineVO.elctrnSanctnemplId)
                                    && (lineVO.commonCodeSanctProgrs == '대기')
                                    && (sanction.commonCodeSanctProgrs != '반려')
                                    && (lineVO.elctrnSanctnFinalAt == 'N')}">
                                                <button type="button" onclick="approve(${lineVO.elctrnSanctnemplId})" class="btn btn-free-blue">승인</button>
                                                <button type="button" onclick="reject(${lineVO.elctrnSanctnemplId})" class="btn btn-free-red rejectBtn" data-name="reject">반려</button>
                                            </c:if>
                                            <c:if test="${ (CustomUser.employeeVO.emplId == lineVO.elctrnSanctnemplId)
                                    && (lineVO.commonCodeSanctProgrs == '대기')
                                    && (sanction.commonCodeSanctProgrs != '반려')
                                    && (lineVO.elctrnSanctnFinalAt == 'Y')}">
                                                <button type="button" onclick="finalApprove(${lineVO.elctrnSanctnemplId})">최종승인
                                                </button>
                                                <button type="button" onclick="reject(${lineVO.elctrnSanctnemplId})" class="btn btn-free-red rejectBtn" data-name="reject">반려</button>
                                </c:if>
                            </c:forEach>
                </div>
                <br/>
                <div class="formTitle">
                    <p class="main-title"> ${sanction.elctrnSanctnSj}</p>
                </div>
            </div>
            <div class="line-wrap">
                <div class="approval">
                    <table id="approval-line" class="line-table">
                        <tr id="applovalOtt" class="ott">
                            <th rowspan="2" class="sanctionTh">결재</th>
                            <th>기안</th>
                            <c:forEach var="lineVO" items="${lineList}" varStatus="stat">
                                <th>${lineVO.commonCodeClsf}</th>
                            </c:forEach>
                        </tr>
                        <tr id="applovalObtt" class="obtt">
                            <td>
                                <div class="obtt-inner">
                                <p class="approval-person">
                                    <img src="/uploads/sign/${sanction.uploadFileStreNm}"/>
                                </p>
                                <span class="approval-date">${sanction.elctrnSanctnRecomDate}</span>
                                </div>
                            </td>
                            <c:forEach var="lineVO" items="${lineList}" varStatus="stat">
                                <td>
                                    <div class="obtt-inner">
                                        <p class="approval-person">
                                            <c:choose>
                                                <c:when test="${lineVO.commonCodeSanctProgrs == '반려'}">
                                                    <img src="${pageContext.request.contextPath}/resources/images/reject.png"/>
                                                </c:when>
                                                <c:when test="${lineVO.commonCodeSanctProgrs == '승인' }">
                                                    <img src="/uploads/sign/${lineVO.uploadFileStreNm}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    ${lineVO.emplNm}
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <span class="approval-date">${lineVO.sanctnLineDate}</span>
                                    </div>
                                </td>
                            </c:forEach>
                        </tr>
                    </table>
                </div>
                <div id="refer">
                    <table id="refer-line" class="line-table">
                        <tr id="referOtt" class="ott">
                            <th class="sanctionTh">참조</th>
                            <c:forEach var="refrnVO" items="${refrnList}" varStatus="stat">
                                <td>${refrnVO.emplNm}</td>
                            </c:forEach>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="content-body">

        </div>
    </div>
    <div id="formCard">
        <div class="formContent">
                ${sanction.elctrnSanctnDc}
        </div>
        <div class="form-file">
            <div class="file-label form-label">
                첨부 파일
            </div>
            <c:choose>
                <c:when test="${file != null}">
                <p class="file-content form-out-content"><a href="/file/download/sanction?uploadFileSn=${file.uploadFileSn}">${file.uploadFileOrginlNm}</a>
                    <fmt:formatNumber value="${file.uploadFileSize / 1024.0}"
                                      type="number" minFractionDigits="1" maxFractionDigits="1"/> KB</p>
                </c:when>
                <c:otherwise>
                    <p class="file-content form-out-content">파일 없음</p>
                </c:otherwise>
            </c:choose>
        </div>
        <div id="returnResn">
            <c:forEach var="lineVO" items="${lineList}" varStatus="stat">
                <c:if test="${lineVO.sanctnLineReturnResn != null }">
                    <div class="form-label">
                        반려 사유
                    </div>
                    <p class="file-content form-out-content">${lineVO.sanctnLineReturnResn}${lineVO.emplNm}${lineVO.commonCodeClsf}</p>
                </c:if>
            </c:forEach>
        </div>
    </div>

   <%-- <div id="formCard">
        <div class="formHeader">
            <div class="btnWrap">
                <div id="myLine">
                    <hr>
                    <p>기안</p>
                    <p>${sanction.emplNm}</p>
                    <p><img src="/uploads/sign/${sanction.uploadFileStreNm}"/></p>
                    <p>${sanction.elctrnSanctnRecomDate}</p>
                    <p>${sanction.commonCodeSanctProgrs}</p>
                    <p>${sanction.commonCodeClsf}</p>
                    <hr>
                </div>
                <div id="approvalLine">
                    <p>결재선</p>

                    <c:forEach var="lineVO" items="${lineList}" varStatus="stat">
                        <c:choose>
                            <c:when test="${lineVO.commonCodeSanctProgrs == '반려'}">
                                <p>반려</p>
                            </c:when>
                            <c:when test="${lineVO.commonCodeSanctProgrs == '승인' }">
                                <p><img src="/uploads/sign/${lineVO.uploadFileStreNm}"/></p>
                            </c:when>
                            <c:otherwise>
                                <p>${lineVO.emplNm}</p>
                            </c:otherwise>
                        </c:choose>
                        <p>${lineVO.sanctnLineDate}</p>
                        <p>${lineVO.commonCodeSanctProgrs}</p>
                        <p>${lineVO.commonCodeClsf}</p>
                        <hr>
                    </c:forEach>

                    <c:forEach var="refrnVO" items="${refrnList}" varStatus="stat">
                        <p>참조</p>
                        <p>${refrnVO.emplNm} ${refrnVO.commonCodeDept} ${refrnVO.commonCodeClsf}</p>
                        <hr>
                    </c:forEach>
                </div>
            </div>
            <br/>
            <div class="formTitle">
                <p class="main-title"> ${sanction.elctrnSanctnSj}</p>
            </div>
        </div>
        <div class="formContent">
                ${sanction.elctrnSanctnDc}
        </div>
        <div class="formFile">
            <c:if test="${file != null}">
                <p><a href="/file/download/sanction?uploadFileSn=${file.uploadFileSn}">${file.uploadFileOrginlNm}</a>
                    <fmt:formatNumber value="${file.uploadFileSize / 1024.0}"
                                      type="number" minFractionDigits="1" maxFractionDigits="1"/> KB</p>
            </c:if>
        </div>
        <div id="returnResn">
            <c:forEach var="lineVO" items="${lineList}" varStatus="stat">
                <c:if test="${lineVO.sanctnLineReturnResn != null }">
                    <p>반려사유</p>
                    <p>${lineVO.emplNm}${lineVO.commonCodeClsf}</p>
                    <p>${lineVO.sanctnLineReturnResn}</p>
                </c:if>
            </c:forEach>
        </div>
            &lt;%&ndash; 세션에 담긴 사번이 문서의 기안자 사번과 같고 결재 코드가 최초 상신 상태일 때&ndash;%&gt;
        <c:if test="${CustomUser.employeeVO.emplId == sanction.elctrnSanctnDrftEmplId && sanction.commonCodeSanctProgrs == '상신' }">
            <button type="button" onclick="collect()">회수</button>
        </c:if>
        <c:forEach var="lineVO" items="${lineList}" varStatus="stat">
            &lt;%&ndash; 세션에 담긴 사번이 문서의 결재자 사번과 같고 결재 상태가 대기이며 결재의 상태가 반려가 아닌 경우&ndash;%&gt;
            <c:if test="${ (CustomUser.employeeVO.emplId == lineVO.elctrnSanctnemplId)
                        && (lineVO.commonCodeSanctProgrs == '대기')
                        && (sanction.commonCodeSanctProgrs != '반려')
                        && (lineVO.elctrnSanctnFinalAt == 'N')}">
                <button type="button" onclick="approve(${lineVO.elctrnSanctnemplId})">승인</button>
                <button type="button" onclick="reject(${lineVO.elctrnSanctnemplId})">반려</button>
            </c:if>
            <c:if test="${ (CustomUser.employeeVO.emplId == lineVO.elctrnSanctnemplId)
                        && (lineVO.commonCodeSanctProgrs == '대기')
                        && (sanction.commonCodeSanctProgrs != '반려')
                        && (lineVO.elctrnSanctnFinalAt == 'Y')}">
                <button type="button" onclick="finalApprove(${lineVO.elctrnSanctnemplId})">최종승인</button>
                <button type="button" onclick="reject(${lineVO.elctrnSanctnemplId})">반려</button>
            </c:if>
        </c:forEach>--%>
        <br><br>
    <div class="btn-wrap close-btn-wrap">
        <button type="button" onclick="closeWindow()" class="btn btn-fill-bl-sm">닫기</button>
    </div>
    <!-- 모달창 -->
    <div id="modal" class="modal-dim">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm reject" id="rejectModal">
            <div class="modal-top">
                <div class="modal-title">반려하기</div>
                <button type="button" class="modal-close btn js-modal-close">
                    <i class="icon i-close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <div class="modal-content input-wrap">
                    <label for="rejectReason" class="label-df"> 반려 사유</label>
                    <textarea cols="50" rows="5" id="rejectReason" class="bg-sky"></textarea>
                </div>
            </div>
            <div class="modal-footer btn-wrapper">
                <button type="button" id="submitReject" class="btn btn-fill-bl-sm" onclick="submitReject()">확인</button>
                <button type="button" class="btn btn-fill-wh-sm close">취소</button>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/resources/js/modal.js"></script>
    <script>
        let rejectReason;
        let rejectId;
        let etprCode = '${sanction.elctrnSanctnEtprCode}';
        let afterPrcs = '${sanction.elctrnSanctnAfterPrcs}'
        $(function () {
            $("#elctrnSanctnFinalDate").html('${sanction.elctrnSanctnFinalDate}');
        })

        function closeWindow() {
            window.close();
        }

        /* 승인 처리 */
        function approve(id) {
            console.log(id);
            $.ajax({
                url: `/sanction/api/approval/\${id}/\${etprCode}`,
                type: 'PUT',
                success: function (data) {
                    alert('승인 처리 성공')
                },
                error: function (xhr) {
                    alert('승인 처리 실패')
                }
            });
        }

        /* 최종 승인 처리 */
        function finalApprove(id) {
            console.log(id);
            $.ajax({
                url: `/sanction/api/final/approval/\${id}/\${etprCode}`,
                type: 'PUT',
                success: function (data) {
                    alert('최종 승인 처리 성공')
                    if (afterPrcs != null) {
                        afterFinalApprove();
                    }
                },
                error: function (xhr) {
                    alert('최종 승인 처리 실패')
                }
            });
        }

        /* 후처리 실행 */
        function afterFinalApprove() {
            $.ajax({
                url: `/sanction/api/reflection`,
                type: "POST",
                data: afterPrcs,
                contentType: "application/json",
                success: function (data) {
                    alert("후처리 실행(리플랙션) 성공");
                },
                error: function (xhr) {
                    alert("후처리 실행(리플랙션) 실패");
                }
            });
        }

        /* 반려 처리 */
        function reject(id) {
            rejectId = id;
            modalOpen("reject");
            document.querySelector(".reject").classList.add("on");
        }

        /*function openRejectModal() {
            $("#rejectModal").prop("hidden", false);
        }*/

        function submitReject() {
            rejectReason = $("#rejectReason").val()
            console.log(rejectReason);
            console.log(rejectId)
            console.log(etprCode)
            $.ajax({
                url: '/sanction/api/reject',
                type: 'PUT',
                data: JSON.stringify({
                    elctrnSanctnemplId: rejectId,
                    sanctnLineReturnResn: rejectReason,
                    elctrnSanctnEtprCode: etprCode
                }),
                contentType: "application/json",
                success: function (data) {
                    alert('반려 처리 성공')
                    close()
                },
                error: function (xhr) {
                    alert('반려 처리 실패')
                }
            });
        }

        /* 회수 처리 */
        function collect() {
            console.log(etprCode);
            $.ajax({
                url: `/sanction/api/collect/\${etprCode}`,
                type: 'PUT',
                success: function (data) {
                    alert('회수 처리 성공')
                },
                error: function (xhr) {
                    alert('회수 처리 실패')
                }
            });
        }
    </script>
</sec:authorize>