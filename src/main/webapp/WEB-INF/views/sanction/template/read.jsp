<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sanction/sanction.css">
<style>
    .container {
        padding: 24px;
    }

    .file_box {
        border: 2px solid rgb(13 110 253 / 25%);
        border-radius: 10px;
        margin-top: 20px;
        padding: 40px;
        text-align: center;
    }
</style>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-wrapper">
        <div class="content-header">
            <div class="form-header">
                <div class="btn-wrap">
                    <a href="#" class="btn" id="downBtn" onclick="downloadAsPDF()"><i class="icon i-down"></i></a>
                    <c:if test="${CustomUser.employeeVO.emplId == sanction.elctrnSanctnDrftEmplId && sanction.commonCodeSanctProgrs == '상신' }">
                        <button type="button" onclick="collect()" class="btn btn-free-white" id="collectBtn">회수</button>
                    </c:if>
                    <c:forEach var="lineVO" items="${lineList}" varStatus="stat">
                        <c:if test="${ (CustomUser.employeeVO.emplId == lineVO.elctrnSanctnemplId)
                                    && (lineVO.commonCodeSanctProgrs == '대기')
                                    && (sanction.commonCodeSanctProgrs != '반려')
                                    && (lineVO.elctrnSanctnFinalAt == 'N')}">
                            <button type="button" onclick="approve(${lineVO.elctrnSanctnemplId})" id="approveBtn"
                                    class="btn btn-fill-wh-sm sanctionBtn">승인
                            </button>
                            <button type="button" onclick="reject(${lineVO.elctrnSanctnemplId})"
                                    class="btn btn-fill-wh-sm sanctionBtn rejectBtn" data-name="reject">반려
                            </button>
                        </c:if>
                        <c:if test="${ (CustomUser.employeeVO.emplId == lineVO.elctrnSanctnemplId)
                                    && (lineVO.commonCodeSanctProgrs == '대기')
                                    && (sanction.commonCodeSanctProgrs != '반려')
                                    && (lineVO.elctrnSanctnFinalAt == 'Y')}">
                            <button type="button" onclick="finalApprove(${lineVO.elctrnSanctnemplId})"
                                    class="btn btn-fill-wh-sm sanctionBtn" id="finalApproveBtn">최종승인
                            </button>
                            <button type="button" onclick="reject(${lineVO.elctrnSanctnemplId})"
                                    class="btn btn-fill-wh-sm sanctionBtn rejectBtn" data-name="reject">반려
                            </button>
                        </c:if>
                    </c:forEach>
                </div>
                </div>
                <br/>
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
                                <th>${lineVO.emplNm} ${lineVO.commonCodeClsf}</th>
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
                                        <p class="approval-person" id="${lineVO.elctrnSanctnemplId}">
                                            <c:choose>
                                                <c:when test="${lineVO.commonCodeSanctProgrs == '반려'}">
                                                    <img src="${pageContext.request.contextPath}/resources/images/reject.png"/>
                                                </c:when>
                                                <c:when test="${lineVO.commonCodeSanctProgrs == '승인'}">
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
                <c:if test="${refrnList!=null}">
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
                </c:if>
            </div>
        </div>
        <div class="content-body">

        </div>
        <div id="formCard">
            <div class="formContent">
                    ${sanction.elctrnSanctnDc}
            </div>
        </div>
        <c:if test="${file!=null}">
            <div class="form-file">
                <div class="file-label form-label">
                    첨부 파일
                </div>
                <c:choose>
                    <c:when test="${file != null}">
                        <p class="file-content form-out-content"><a
                                href="/file/download/sanction?uploadFileSn=${file.uploadFileSn}">${file.uploadFileOrginlNm}</a>
                            <fmt:formatNumber value="${file.uploadFileSize / 1024.0}"
                                              type="number" minFractionDigits="1" maxFractionDigits="1"/> KB</p>
                    </c:when>
                    <c:otherwise>
                        <p class="file-content form-out-content">파일 없음</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        <div id="returnResn">
            <c:forEach var="lineVO" items="${lineList}" varStatus="stat">
                <c:if test="${lineVO.sanctnLineReturnResn != null }">
                    <div class="form-label">
                        반려 사유
                    </div>
                    <p class="file-content form-out-content">${lineVO.sanctnLineReturnResn}</p>
                </c:if>
            </c:forEach>
        </div>
    </div>


    <br><br>
    <div class="btn-wrap close-btn-wrap">
        <button type="button" id="closeBtn" onclick="closeWindow()" class="btn btn-free-white sanctionBtn">닫기</button>
    </div>
    <!-- 모달창 -->
    <div id="modal" class="modal-dim">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm reject" id="rejectModal">
            <div class="modal-top">
                <div class="modal-title">반려하기</div>
                <button type="button" class="modal-close btn close">
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
    <script src="${pageContext.request.contextPath}/resources/js/validate.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        var socket = null;
        document.addEventListener("DOMContentLoaded", () => {
            connectWs();
        });

        function connectWs() {
            //웹소켓 연결
            sock = new SockJS("/echo-ws");
            socket = sock;

            sock.onerror = function (err) {
            }
        }
        // pdf 생성
        window.jsPDF = window.jspdf.jsPDF;

        function downloadAsPDF() {
            let element = document.querySelector(".content-wrapper");
            let options = {
                ignoreElements: (element) => {
                    return element.classList.contains("btn"); // 버튼 제외
                }
            };

            html2canvas(element, options).then((canvas) => {
                let imgData = canvas.toDataURL("image/png");
                let imgWidth = 210;
                let pageHeight = 297;
                let imgHeight = (canvas.height * imgWidth) / canvas.width;
                let heightLeft = imgHeight;
                let position = 0;
                let pdf = new jsPDF("p", "mm", "a4");

                pdf.addImage(imgData, "PNG", 0, position, imgWidth, imgHeight);
                heightLeft -= pageHeight;

                while (heightLeft >= 0) {
                    position = heightLeft - imgHeight;
                    pdf.addPage();
                    pdf.addImage(imgData, "PNG", 0, position, imgWidth, imgHeight);
                    heightLeft -= pageHeight;
                }

                let fileName = '${sanction.elctrnSanctnEtprCode}' + '.pdf'
                pdf.save(fileName);
            });
        }

        let rejectReason;
        let rejectId;
        let etprCode = '${sanction.elctrnSanctnEtprCode}';
        let afterPrcs = '${sanction.elctrnSanctnAfterPrcs}'
        let emplId = '${CustomUser.employeeVO.emplId}';
        let emplNm = '${CustomUser.employeeVO.emplNm}';
        let signUrl = '/uploads/sign/' + '${CustomUser.employeeVO.signPhotoFileStreNm}';
        let signElement = document.getElementById(emplId);
        let drftEmplId = '${sanction.elctrnSanctnDrftEmplId}';

        $(function () {
            $("#elctrnSanctnFinalDate").html('${sanction.elctrnSanctnFinalDate}');
        })

        function closeWindow() {
            window.close();
        }

        $("#testBtn").on("click", function () {
            appendReturnReason()
        })

        /* 승인 처리 */
        function approve(id) {


            $.ajax({
                url: `/sanction/api/approval/\${id}/\${etprCode}`,
                type: 'PUT',
                success: function (data) {
                    appendSignImg();
                    alarm('승인');
                    $(".sanctionBtn").prop("hidden", true);
                    Swal.fire({
                        text: '승인 처리되었습니다.',
                        showConfirmButton: false,
                        timer: 1500
                    })
                },
                error: function (xhr) {
                    Swal.fire({
                        text: '승인 처리에 실패하였습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                }
            });


        }

        function appendSignImg() {
            let imgElement = $('<img/>', {
                src: signUrl
            });
            $(signElement).empty();
            $(signElement).append(imgElement);
            let dateElement = $(signElement).siblings('.approval-date');
            dateElement.text(getCurrentDate());
        }

        function appendReturnReason() {
            let returnResnDiv = $('<div>', {
                class: 'form-label',
                text: '반려 사유'
            });

            let returnResnText = $('<p>', {
                class: 'file-content form-out-content',
                text: rejectReason
            });

            $('#returnResn').append(returnResnDiv, returnResnText);
        }

        /* 최종 승인 처리 */
        function finalApprove(id) {
            $.ajax({
                url: `/sanction/api/final/approval/\${id}/\${etprCode}`,
                type: 'PUT',
                success: function (data) {
                    appendSignImg();
                    alarm('최종승인');
                    $(".sanctionBtn").prop("hidden", true);
                    Swal.fire({
                        text: '최종 승인 처리되었습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                    if (afterPrcs != null) {
                        afterFinalApprove();
                    }
                },
                error: function (xhr) {
                    Swal.fire({
                        text: '승인 처리에 실패하였습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
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
                },
                error: function (xhr) {
                    console.log("후처리 실패");
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
                    signUrl = '/resources/images/reject.png';
                    appendSignImg();
                    alarm('반려');
                    $(".sanctionBtn").prop("hidden", true);
                    modalClose()
                    let returnResnElement = document.getElementById("returnResn");
                    returnResnElement.innerHTML = `<div class="form-label"> 반려 사유 </div><p class="file-content form-out-content">\${rejectReason}</p>`;
                    Swal.fire({
                        text: '반려 처리되었습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })


                },
                error: function (xhr) {
                    Swal.fire({
                        text: '반려 처리에 실패하였습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                }
            });
        }

        /* 회수 처리 */
        function collect() {
            $.ajax({
                url: `/sanction/api/collect/\${etprCode}`,
                type: 'PUT',
                success: function (data) {
                    Swal.fire({
                        text: '회수 처리되었습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                    $("#collectBtn").prop("hidden", true);
                    // location.reload()
                },
                error: function (xhr) {
                    Swal.fire({
                        text: '회수 처리에 실패하였습니다',
                        showConfirmButton: false,
                        timer: 1500
                    })
                }
            });
        }

        function alarm(status) {
            $.get("/alarm/getMaxAlarm")
                .then(function (maxNum) {
                    maxNum = parseInt(maxNum) + 1;

                    let url = '/sanction/document';
                    let title = document.querySelector(".main-title").innerText;
                    let content = `<div class="alarmListBox">
                                    <a href="\${url}" class="aTag" data-seq="\${maxNum}">
                                        <h1>[결재 결과]</h1>
                                        <div class="alarm-textbox">
                                            <p>\${emplNm}님이
                                            [<span>\${title}</span>] 결재를
                                             \${status}하셨습니다.</p>
                                        </div>
                                    </a>
                                    <button type="button" class="readBtn">읽음</button>
                                </div>`;
                    let alarmVO = {
                        "ntcnEmplId": drftEmplId,
                        "ntcnSn": maxNum,
                        "ntcnUrl": url,
                        "ntcnCn": content,
                        "commonCodeNtcnKind": 'NTCN018'
                    };

                    //알림 생성 및 페이지 이동
                    $.ajax({
                        type: 'post',
                        url: '/alarm/insertAlarmTarget',
                        data: alarmVO,
                        success: function (rslt) {
                            if (socket) {
                                //알람번호,카테고리,url,보낸사람이름,받는사람아이디, 결재 종류, 상태
                                let msg = maxNum + ",sanctionResult," + url + "," + emplNm + "," + drftEmplId + "," + title + "," + status;
                                socket.send(msg);
                            }
                        },
                        error: function (xhr) {
                            console.log(xhr.status);
                        }
                    });
                })
                .catch(function (error) {
                    console.log("최대 알람 번호 가져오기 오류:", error);
                });
        }
    </script>
</sec:authorize>
