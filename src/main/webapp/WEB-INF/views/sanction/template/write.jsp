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
                    <button type="button" id="getLine" class="btn btn-free-blue sanctionBtn">결재선 지정</button>
                    <button type="button" id="sanctionSubmit" class="btn btn-free-white" disabled>결재 제출</button>
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

    <script>
        let before = new Date();
        let year = before.getFullYear();
        let month = String(before.getMonth() + 1).padStart(2, '0');
        let day = String(before.getDate()).padStart(2, '0');

        let approver = [];
        let receiver = [];
        let referrer = [];

        const dept = "${dept}" // 문서 구분용
        console.log(dept)

        const etprCode = "${etprCode}";
        const formatCode = "${format.commonCodeSanctnFormat}";
        const writer = "${CustomUser.employeeVO.emplId}"
        const today = year + '-' + month + '-' + day;
        const title = "${format.formatSj}";
        let content;
        let file = $('#sanctionFile')[0].files[0];
        let num = opener.$("#sanctionNum").val();
        let approvalListData = [];
        let attachListData = [];
        /*  팝업  */
        const getLineBtn = document.querySelector("#getLine");

        document.addEventListener("DOMContentLoaded", () => {
            $("#sanctionNo").html(etprCode);
            $("#writeDate").html(today);
            $("#writer").html("${CustomUser.employeeVO.emplNm}")
            $("#requestDate").html(`\${year}년 \${month}월 \${day}일`);

            if (dept == 'DEPT011') {
                loadCardData()
            } else {
                loadVacationData()
            }

            /*  팝업  */
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
                console.log(sanctionLineData, referLineData);

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
                    console.log(data)
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
                    console.log(data)
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


        function appendLine(app, ref) {
            approver = app;
            referrer = ref;
            if (approver.length > 0) {
                $("#sanctionSubmit").prop("disabled", false);
            } else {
                $("#sanctionSubmit").prop("disabled", true);
            }
        }

        $("#sanctionSubmit").on("click", function () {
            submitSanction()
        });

        function submitSanction() {
            updateStatus()
            content = $(".formContent").html();
            const jsonData = {
                approver: approver,
                receiver: receiver,
                referrer: referrer,
                etprCode: etprCode,
                formatCode: formatCode,
                writer: writer,
                today: today,
                title: title,
                content: content,
                vacationId: num,
            };

            if (dept === 'DEPT010') {
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
                    console.log("결재 업로드 성공");
                    if (file != null) {
                        uploadFile();
                    } else {
                        closeWindow()
                    }
                },
                error: function (xhr) {
                    console.log("결재 업로드 실패");
                }
            });
        }

        $("#selectFile").on("change", function() {
            const selectedFile = this.files[0];
            const fileNameInput = $(".file-name");
            fileNameInput.innerHTML = selectedFile.name;
            appendFile(selectedFile);
        });

        // 결재 테이블 insert 후 첨부 파일 있다면 업로드 실행
        function appendFile(paramFile) {
            file = paramFile;
            console.log(file)
        }

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
                    console.log("결재 파일 업로드 성공");
                    closeWindow()
                },
                error: function (xhr) {
                    console.log("결재 파일 업로드 실패");
                }
            });
        }


        // 문서의 결재 상태 변경
        function updateStatus() {
            let className;
            if (dept === 'DEPT011') {
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
                    alert("결재 상태 업데이트 성공");
                },
                error: function (xhr) {
                    alert("결재 상태 업데이트 실패");
                }
            });
        }

        function closeWindow() {
            alert("결재 상신이 완료되었습니다.")
            window.opener.refreshParent();
            window.close();
        }


        /*


        파일 드래그 앤 드롭


         */
        const fileBox = document.querySelector(".file-box");
        const fileBtn = fileBox.querySelector("#sanctionFile");
        let formData;

        /* 박스 안에 Drag 들어왔을 때 */
        fileBox.addEventListener('dragenter', function (e) {
        });
        /* 박스 안에 Drag를 하고 있을 때 */
        fileBox.addEventListener('dragover', function (e) {
            e.preventDefault();
            console.log(e.dataTransfer.types);
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

            //유효성 Check
            if (!isValid(data)) return;

            //파일 이름을 text로 표시
            const fileNameInput = document.querySelector(".file-name");
            let filename = e.dataTransfer.files[0].name;
            fileNameInput.innerHTML = filename;

            appendFile(data.files[0]);


        });
        console.log(formData);

        /*  파일 유효성 검사   */
        function isValid(data) {

            //파일인지 유효성 검사
            if (data.types.indexOf('Files') < 0)
                return false;

            //파일의 개수는 1개씩만 가능하도록 유효성 검사
            if (data.files.length > 1) {
                alert('파일은 하나씩 전송이 가능합니다.');
                return false;
            }

            //파일의 사이즈는 50MB 미만
            if (data.files[0].size >= 1024 * 1024 * 50) {
                alert('50MB 이상인 파일은 업로드할 수 없습니다.');
                return false;
            }

            return true;
        }

    </script>
</sec:authorize>


