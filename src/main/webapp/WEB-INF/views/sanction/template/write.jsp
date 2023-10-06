<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<style>
    .container {
        padding: 24px;
    }

</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/sanction/sanction.css">
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-wrapper">
        <div class="content-header">
            <div class="form-header">
                <div class="btn-wrap">
                    <button type="button" id="getLine" class="btn btn-fill-bl-sm sanctionBtn">결재선 지정</button>
                    <button type="button" id="sanctionSubmit" class="btn btn-fill-wh-sm" disabled>결재 제출</button>
                </div>
                <br/>
                <div class="formTitle">
                    <p class="main-title">${format.formatSj}</p>
                </div>
            </div>
            <div class="line-wrap">
                <div class="approval">
                    <table id="approval-line" class="line-table">
                        <tr id="applovalOtt" class="ott">
                            <th rowspan="2" class="sanctionTh">결재</th>
                            <th>기안</th>
                        </tr>
                        <tr id="applovalObtt" class="obtt">
                            <td>
                                <p class="approval-person">
                                        ${CustomUser.employeeVO.emplNm}
                                </p>
                                <span class="approval-date"></span>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="refer">
                    <table id="refer-line" class="line-table">
                        <tr id="referOtt" class="ott">
                            <th class="sanctionTh">참조</th>
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
                ${format.formatCn}
        </div>
        <div class="form-file">
            <div class="file-box">
                <p class="file-name">이곳에 파일을 끌어놓으세요. <label for="selectFile" class="select-file"> 직접 선택</label></p>
                <input type="file" id="sanctionFile"/>
                <input type="file" id="selectFile" hidden="hidden"/>

            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/resources/js/validate.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        const today = new Date();
        const year = today.getFullYear();
        const month = String(today.getMonth() + 1).padStart(2, '0');
        const day = String(today.getDate()).padStart(2, '0');

        const formattedDate = `\${year}년 \${month}월 \${day}일`;


        let approver = [];
        let referrer = [];


        const deptCode = "${dept}" // 문서 구분용
        const etprCode = "${etprCode}";
        const formatCode = "${format.commonCodeSanctnFormat}";
        const writer = "${CustomUser.employeeVO.emplId}";
        const emplNm = "${CustomUser.employeeVO.emplNm}";
        const title = "${format.formatSj}";
        const num = opener.$("#sanctionNum").val();
        let content;
        let file = $('#sanctionFile')[0].files[0];

        const getLineBtn = document.querySelector("#getLine"); // 팝업

        var socket = null;

        function connectWs() {
            //웹소켓 연결
            sock = new SockJS("/echo-ws");
            socket = sock;

            sock.onerror = function (err) {
                console.log("ERROR: ", err);
            }
        }

        document.addEventListener("DOMContentLoaded", () => {
            connectWs();
            $("#sanctionNo").html(etprCode);
            $("#writeDate").html(getCurrentDate());
            $("#writer").html("${CustomUser.employeeVO.emplNm}")
            $("#requestDate").html(formattedDate);

            // 부서 코드에 따른 데이터 불러오기
            if (deptCode === 'DEPT011') {
                loadCardData()
            } else {
                loadVacationData()
            }

            /*  결재선 팝업  */
            const url = "/sanction/line";
            const option = "width = 864, height = 720, top = 50, left = 300";
            let popupWindow;
            getLineBtn.addEventListener("click", () => {
                popupWindow = window.open(url, 'line', option);
            })

            /* Promise를 사용하여 데이터 받아오기 */
            function getDataFromPopup() {
                return new Promise((resolve, reject) => {
                    window.addEventListener('message', function (event) {
                        const data = event.data;
                        /*document.querySelector(".approval").innerHTML = data;*/
                        let approvalList = data; // 데이터를 변수에 저장
                        popupWindow.close();

                        // 데이터를 성공적으로 받아온 경우 resolve 호출
                        resolve(approvalList);
                    });
                });
            }

            // Promise를 사용하여 데이터를 받아온 후에 작업 수행
            getDataFromPopup().then((data) => {
                const sanctionLineData = data.sanctionLine;
                const referLineData = data.referLine;
                const applovalOtt = document.querySelector("#applovalOtt");
                const applovalObtt = document.querySelector("#applovalObtt");
                const referOtt = document.querySelector("#referOtt");

                /*  결재선 추가  */
                for (const key in sanctionLineData) {
                    if (sanctionLineData.hasOwnProperty(key)) {
                        const value = sanctionLineData[key];
                        /* 배열에 담기   */
                        approver.push(value.id);
                        /* 요소 추가 */
                        const newTh = document.createElement("th");
                        const newTd = document.createElement("td");
                        const newP = document.createElement("p");
                        const newSpan = document.createElement("span");

                        newTh.innerText = `\${key}차 결재자`;

                        newP.classList = "approval-person";
                        newP.innerText = value.name;
                        newSpan.classList = "approval-date";

                        newTd.append(newP);
                        newTd.append(newSpan);
                        applovalOtt.append(newTh);
                        applovalObtt.append(newTd);
                    }
                }
                for (const key in referLineData) {
                    if (referLineData.hasOwnProperty(key)) {
                        const value = referLineData[key];
                        /* 배열에 담기   */
                        referrer.push(value.id);

                        /* 요소 추가 */
                        const newTd = document.createElement("td");
                        newTd.innerText = value.name;
                        referOtt.append(newTd);
                    }
                }
                appendLine(approver, referrer)
            });
        });

        function loadVacationData() {
            $.ajax({
                url: `/vacation/detail/\${num}`,
                type: "GET",
                success: function (data) {
                    for (let key in data) {
                        if (data.hasOwnProperty(key)) {
                            let value = data[key];
                            let element = document.getElementById(key);
                            if (element) {
                                element.textContent = value;
                            }
                        }
                    }
                }
            })
        }

        function loadCardData() {
            $.ajax({
                url: `/card/data/\${num}`,
                type: "GET",
                success: function (data) {
                    for (let key in data) {
                        if (data.hasOwnProperty(key)) {
                            let value = data[key];
                            let element = document.getElementById(key);
                            if (element) {
                                if (key === "cprCardUseExpectAmount") {
                                    value = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + "원";
                                }
                                element.textContent = value;
                            }
                        }
                    }
                }
            })
        }

        // 부모창(결재선)으로부터 받은 결재라인 배열 append
        function appendLine(app, ref) {
            approver = app;
            referrer = ref;
            if (approver.length > 0) {
                $("#sanctionSubmit").prop("disabled", false);
            } else {
                $("#sanctionSubmit").prop("disabled", true);
            }
        }

        // 결재 제출
        $("#sanctionSubmit").on("click", function () {
            Swal.fire({
                text: "상신하시겠습니까?",
                showCancelButton: true,
                confirmButtonColor: '#5796F3FF',
                cancelButtonColor: '#e1e1e1',
                confirmButtonText: '확인',
                cancelButtonText: '취소'
            }).then((result) => {
                if (result.isConfirmed) {
                    submitSanction()
                } else {
                    return false;
                }
            })

        });


        function submitSanction() {
            updateStatus() // 결재 상태 업데이트

            content = $(".formContent").html();
            const jsonData = {
                approver: approver,
                referrer: referrer,
                etprCode: etprCode,
                formatCode: formatCode,
                writer: writer,
                today: today,
                title: title,
                content: content,
                vacationId: num,
            };
            // 부서 코드에 맞는 후처리 정보
            if (deptCode === 'DEPT010') {
                const param = {
                    vacationId: num
                };
                const afterProcess = {
                    className: "kr.co.groovy.commute.CommuteService",
                    methodName: "insertCommuteByVacation",
                    parameters: param
                };
                jsonData.afterProcess = JSON.stringify(afterProcess);
            } else {
                const param = {
                    approveId: num,
                    state: 'YRYC032'
                };
                const afterProcess = {
                    className: "kr.co.groovy.card.CardService",
                    methodName: "modifyStatus",
                    parameters: param
                };
                jsonData.afterProcess = JSON.stringify(afterProcess);
            }
            $.ajax({
                url: "/sanction/api/sanction",
                type: "POST",
                data: JSON.stringify(jsonData),
                contentType: "application/json",
                success: function (data) {
                    if (file != null) {
                        uploadFile();  // 결재 상신 후 파일이 있다면
                    } else {
                        // closeWindow()
                        alarm();
                    }
                },
                error: function (xhr) {
                    console.log("결재 업로드 실패");
                }
            });
        }

        // 파일 직접 선택
        $("#selectFile").on("change", function () {
            const selectedFile = this.files[0];
            const fileNameInput = $(".file-name");
            fileNameInput.text(selectedFile.name);
            appendFile(selectedFile);
        });

        // 드래그 앤 드롭 및 직접 선택 파일 append 처리 함수
        function appendFile(paramFile) {
            file = paramFile;
        }

        // 결재 insert 후 첨부 파일 있다면 업로드 실행
        function uploadFile() {
            let form = file;
            let formData = new FormData();
            formData.append('file', form);
            $.ajax({
                url: `/file/upload/sanction/\${etprCode}`,
                type: "POST",
                data: formData,
                contentType: false,
                processData: false,
                success: function (data) {
                    alarm();
                },
                error: function (xhr) {
                    console.log("결재 파일 업로드 실패");
                }
            });
        }

        // 문서의 결재 상태 변경 (진행)
        function updateStatus() {
            let className;
            if (deptCode === 'DEPT011') {
                className = 'kr.co.groovy.card.CardService'
            } else {
                className = 'kr.co.groovy.vacation.VacationService'
            }
            let data = {
                className: className,
                methodName: 'modifyStatus',
                parameters: {
                    approveId: num,
                    state: 'YRYC031'
                }
            };
            $.ajax({
                url: `/sanction/api/reflection`,
                type: "POST",
                data: JSON.stringify(data),
                contentType: "application/json",
                success: function (data) {

                },
                error: function (xhr) {
                    console.log("결재 상태 업데이트 실패");
                }
            });
        }

        function closeWindow() {
            window.opener.refreshParent();
            window.close();
        }


        /* 파일 드래그 앤 드롭 */
        const fileBox = document.querySelector(".file-box");
        const fileBtn = fileBox.querySelector("#sanctionFile");
        let formData;

        /* 박스 안에 Drag 들어왔을 때 */
        fileBox.addEventListener('dragenter', function (e) {
        });
        /* 박스 안에 Drag를 하고 있을 때 */
        fileBox.addEventListener('dragover', function (e) {
            e.preventDefault();
            const vaild = e.dataTransfer.types.indexOf('Files') >= 0;
            !vaild ? this.style.backgroundColor = '#F5FAFF' : this.style.backgroundColor = '#F5FAFF';
        });
        /* 박스 밖으로 Drag가 나갈 때 */
        fileBox.addEventListener('dragleave', function (e) {
            this.style.backgroundColor = '#F9FAFB';
        });
        /* 박스 안에서 Drag를 Drop했을 때 */
        fileBox.addEventListener('drop', function (e) {
            e.preventDefault();
            this.style.backgroundColor = '#F9FAFB';

            const data = e.dataTransfer;

            // 유효성 검사
            if (!isValid(data)) return;

            //파일 이름을 text로 표시
            const fileNameInput = document.querySelector(".file-name");
            let filename = e.dataTransfer.files[0].name;
            fileNameInput.innerHTML = filename;
            appendFile(data.files[0]);


        });

        /*  파일 유효성 검사   */
        function isValid(data) {

            // 파일인지 유효성 검사
            if (data.types.indexOf('Files') < 0)
                return false;

            // 파일의 개수 제한
            if (data.files.length > 1) {
                Swal.fire({
                    text: '파일은 하나만 업로드 가능합니다',
                    showConfirmButton: false,
                    timer: 1500
                })
                return false;
            }

            // 파일의 사이즈 제한
            if (data.files[0].size >= 1024 * 1024 * 50) {
                Swal.fire({
                    text: '50MB 이상인 파일은 업로드할 수 없습니다',
                    showConfirmButton: false,
                    timer: 1500
                })
                return false;
            }
            return true;
        }

        function alarm() {
            //알림
            $.get("/alarm/getMaxAlarm")
                .then(function (maxNum) {
                    maxNum = parseInt(maxNum) + 1;

                    let url = '/sanction/document';
                    let content = `<div class="alarmListBox">
                                        <a href="\${url}" class="aTag" data-seq="\${maxNum}">
                                            <h1>[결재 요청]</h1>
                                            <div class="alarm-textbox">
                                                <p>\${emplNm}님이[
                                                <span>\${title}</span>
                                                 ]결재를 요청하셨습니다.</p>
                                            </div>
                                        </a>
                                        <button type="button" class="readBtn">읽음</button>
                                    </div>`;
                    let alarmVO = {
                        "ntcnSn": maxNum,
                        "ntcnUrl": url,
                        "ntcnCn": content,
                        "commonCodeNtcnKind": 'NTCN017',
                        "selectedEmplIds": approver
                    };

                    $.ajax({
                        type: 'post',
                        url: '/alarm/insertAlarmTargeList',
                        data: alarmVO,
                        success: function () {
                            if (socket) {
                                //알람번호,카테고리,url,보낸사람이름,결재종류,결재자아이디
                                let msg = `\${maxNum},sanctionReception,\${url},\${emplNm},\${title},\${approver}`;
                                socket.send(msg);
                            }
                            closeWindow();
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


