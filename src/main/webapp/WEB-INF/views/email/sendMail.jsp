<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    #cke_1_contents {
        min-height: 100px !important;
        height: 25vh !important;
        max-height: 32vh !important;
        overflow-y: auto;
    }
</style>
<link href="/resources/css/mail/mail.css" rel="stylesheet"/>
<sec:authentication property="principal" var="CustomUser"/>
<div class="content-container">
    <jsp:include page="header.jsp"></jsp:include>
    <div class="contentWrap card card-df send-wrap">
        <div class="send-wrap-inner">
            <form action="#" method="post" id="mailForm" enctype="multipart/form-data">
                <div class="serviceWrap">
                    <div class="writeWrap">
                        <button type="button" id="sendBtn" class="btn">보내기</button>
                        <a href="${pageContext.request.contextPath}/email/sendMine" class="send-mine"><i
                                class="icon i-change"></i>내게 쓰기</a>
                    </div>
                </div>
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="content-body">
                    <div class="mail-write-options">
                        <div class="mail-receive-wrap mail-write-option">
                            <h3><label for="emailToAddr">받는 사람</label></h3>
                            <div class="option-wrap">
                                <span id="receiveTo"></span>
                                <input type="text" id="emailToAddr" class="mail-input">
                                <button type="button" id="orgBtnTo" class="btn btn-flat btn-org">조직도</button>
                            </div>
                        </div>
                        <div class="mail-cc-wrap mail-write-option">
                            <h3><label for="emailCcAddr">참조</label></h3>
                            <div class="option-wrap">
                                <span id="receiveCc"></span>
                                <input type="text" id="emailCcAddr" class="mail-input">
                                <button type="button" id="orgBtnCc" class="btn btn-flat btn-org">조직도</button>
                            </div>
                        </div>
                        <div class="mail-title-wrap mail-write-option">
                            <h3><label for="emailFromSj">제목</label></h3>
                            <div class="option-wrap">
                                <input type="text" name="emailFromSj" id="emailFromSj" class="mail-input">
                            </div>
                        </div>
                        <div class="mail-file-wrap mail-write-option">
                            <h3><label for="file">파일 첨부</label></h3>
                            <div class="option-wrap">
                                <div class="file-wrap">
                                    <label for="file" class="btn btn-free-white file-btn">
                                        <i class="icon i-file"></i>
                                        내 PC
                                    </label>
                                    <input type="file" name="emailFiles" id="file" multiple onchange="addFile(this);">
                                    <div class="file-list"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="mail-write-editor">
                        <textarea id="editor" name="emailFromCn" required></textarea>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/ckeditor/ckeditor.js"></script>
<script>
    const emplNm = "${CustomUser.employeeVO.emplNm}";

    let editor = CKEDITOR.replace("editor", {
        extraPlugins: 'notification'
    });

    //조직도 팝업
    let orgBtnTo = document.querySelector("#orgBtnTo");
    let orgBtnCc = document.querySelector("#orgBtnCc");

    let receiveTo = document.querySelector("#receiveTo");
    let receiveCc = document.querySelector("#receiveCc");

    let emailToAddrInput = document.querySelector("#emailToAddr");
    let emailCcAddrInput = document.querySelector("#emailCcAddr");


    getOrgChart(orgBtnTo, receiveTo);
    getOrgChart(orgBtnCc, receiveCc);

    addEmailAddrSpan(emailToAddrInput, receiveTo);
    addEmailAddrSpan(emailCcAddrInput, receiveCc);

    /*  메일 헤더 가리기   */
    document.querySelector("#tab-header").style.display = "none";
    document.querySelector(".mailnavWrap #search").style.display = "none";

    document.querySelector("#sendBtn").addEventListener("click", function () {
        let emplIdToArr = document.querySelectorAll("input[name=emplIdToArr]");
        let emplIdToList = []; //id
        emplIdToArr.forEach((emplId) => {
            emplIdToList.push(emplId.value);
        });
        let emplIdCcArr = document.querySelectorAll("input[name=emplIdCcArr]");
        let emplIdCcList = [];
        emplIdCcArr.forEach((emplId) => {
            emplIdCcList.push(emplId.value);
        });
        let emailToAddrArr = document.querySelectorAll("input[name=emailToAddrArr]");
        let emailToAddrList = [];
        emailToAddrArr.forEach((emailAddr) => {
            emailToAddrList.push(emailAddr.value);
        });
        let emailCcAddrArr = document.querySelectorAll("input[name=emailCcAddrArr]");
        let emailCcAddrList = [];
        emailCcAddrArr.forEach((emailAddr) => {
            emailCcAddrList.push(emailAddr.value);
        });

        const mailForm = document.querySelector("#mailForm");
        let formData = new FormData(mailForm);
        formData.append("emplIdToList", emplIdToList);
        formData.append("emplIdCcList", emplIdCcList);
        formData.append("emailToAddrList", emailToAddrList);
        formData.append("emailCcAddrList", emailCcAddrList);
        formData.append("emailFromCn", editor.getData());

        if (emplIdToList != null) {

            let xhr = new XMLHttpRequest();
            xhr.open("post", "/email/send", true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    if (xhr.responseText === "success") {
                        //알림 보내기
                        $.get("/alarm/getMaxAlarm").then(function (maxNum) {
                            maxNum = parseInt(maxNum) + 1;
                            let url = '/email/all';
                            let subject = formData.get("emailFromSj");
                            let content = `<div class="alarmBox">
                                         <a href="\${url}" id="fATag" data-seq="\${maxNum}">
                                                                    <h1>[메일]</h1>
                                                                    <p>[<span>\${subject}</span>]
                                                                        메일이 도착했습니다.
                                                                      \</p>
                                         </a>
                                        <button type="button" class="readBtn">읽음</button>
                                    </div>`;
                            let alarmVO = {
                                "ntcnSn": maxNum,
                                "ntcnUrl": url,
                                "ntcnCn": content,
                                "commonCodeNtcnKind": 'NTCN016',
                                "selectedEmplIds": emplIdToList
                            };

                            if (emplIdToList.length != 0) {
                                //알림 생성 및 페이지 이동
                                $.ajax({
                                    type: 'post',
                                    url: '/alarm/insertAlarmTargeList',
                                    data: alarmVO,
                                    success: function (rslt) {
                                        if (socket) {
                                            //알람번호,카테고리,url,제일,받는사람아이디리스트
                                            let msg = `\${maxNum},email,\${url},\${subject},\${emplIdToList}`;
                                            socket.send(msg);
                                        }
                                        Swal.fire({
                                            text: '메일을 성공적으로 전송했습니다',
                                            showConfirmButton: false,
                                            timer: 1500
                                        })
                                        location.href = "/email/sent";
                                    },
                                    error: function (xhr) {
                                        console.log(xhr.status);
                                    }
                                });
                            } else {
                                Swal.fire({
                                    text: '메일을 성공적으로 전송했습니다',
                                    showConfirmButton: false,
                                    timer: 1500
                                })
                                location.href = "/email/sent";
                            }
                        }).catch(function (error) {
                            console.log("최대 알람 번호 가져오기 오류:", error);
                        });
                    } else {
                        Swal.fire({
                            text: '메일 전송을 실패했습니다 다시 시도해주세요',
                            showConfirmButton: false,
                            timer: 1500
                        })
                    }
                }
            }
            xhr.send(formData);
        }
    });

    document.addEventListener("click", function (event) {
        if (event.target && event.target.classList.contains("close-empl")) {
            let spanToRemove = event.target.closest("span");
            if (spanToRemove) {
                spanToRemove.remove(); // 해당 span 태그 삭제
            }
        }
    });

    function addEmailAddrSpan(emailAddrInput, receive) {
        emailAddrInput.addEventListener('keyup', function (event) {
            if (event.key === 'Enter') {
                const value = emailAddrInput.value;
                const regExpEmail = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
                if (!regExpEmail.test(value)) {
                    Swal.fire({
                        text: '이메일 형식이 아닙니다 다시 입력해주세요',
                        showConfirmButton: false,
                        timer: 1500
                    })
                    emailAddrInput.value = '';
                    return;
                }
                if (value) {
                    let newSpan = document.createElement('span');
                    newSpan.textContent = value + " ";

                    let newButton = document.createElement("button");
                    newButton.setAttribute("type", "button");
                    newButton.setAttribute("class", "close-empl btn");
                    newButton.textContent = "X";

                    let newInput = document.createElement("input");
                    newInput.setAttribute("type", "hidden");
                    if (emailAddrInput.getAttribute("id") === "emailToAddr") {
                        newInput.setAttribute("name", "emailToAddrArr");
                    } else if (emailAddrInput.getAttribute("id") === "emailCcAddr") {
                        newInput.setAttribute("name", "emailCcAddrArr");
                    }
                    newInput.setAttribute("value", value);

                    receive.appendChild(newSpan);
                    newSpan.appendChild(newButton);
                    newSpan.appendChild(newInput);
                    emailAddrInput.value = ''; // 입력 필드를 비움
                }
            }
        });
    }

    function getOrgChart(orgBtn, receive) {
        orgBtn.addEventListener("click", () => {
            fetch("/job/jobOrgChart")
                .then((response) => response.text())
                .then((data) => {
                    let popup = window.open("", "_blank", "width=800,height=600");

                    popup.document.write(data);

                    popup.document.querySelector("#orgCheck").addEventListener("click", () => {
                        const checkboxes = popup.document.querySelectorAll("input[name=orgCheckbox]");
                        let str = ``;
                        checkboxes.forEach((checkbox) => {
                            if (checkbox.checked) {
                                const label = checkbox.closest("label");
                                const emplId = checkbox.id;
                                const emplNm = label.querySelector("span").innerText;

                                let empl = {
                                    emplId,
                                    emplNm
                                }
                                if (orgBtn.getAttribute("id") === "orgBtnTo") {
                                    str += `<span data-id=\${empl.emplId} class="badge emplBadge">
                                            \${empl.emplNm}
                                            <button type="button" class="close-empl btn">x</button>
                                        </span>
                                            <input type="hidden" name="emplIdToArr" value="\${empl.emplId}">`;
                                } else if (orgBtn.getAttribute("id") === "orgBtnCc") {
                                    str += `<span data-id=\${empl.emplId} class="badge emplBadge">
                                            \${empl.emplNm}
                                            <button type="button" class="close-empl btn">x</button>
                                            <input type="hidden" name="emplIdCcArr" value="\${empl.emplId}">
                                        </span>`;
                                }

                            }
                        });
                        receive.insertAdjacentHTML("afterend", str);
                    });

                    popup.document.querySelector("#orgCheck").addEventListener("click", () => {
                        popup.close();
                    });
                })
                .catch((error) => {
                    console.error("데이터 가져오기 실패:", error);
                });
        });
    }

    /*  파일 첨부   */
    let fileNo = 0;
    let filesArr = new Array();

    /* 첨부파일 추가 */
    function addFile(obj) {
        let maxFileCnt = 5;   // 첨부파일 최대 개수
        let attFileCnt = document.querySelectorAll('.filebox').length;    // 기존 추가된 첨부파일 개수
        let remainFileCnt = maxFileCnt - attFileCnt;    // 추가로 첨부가능한 개수
        let curFileCnt = obj.files.length;  // 현재 선택된 첨부파일 개수

        // 첨부파일 개수 확인
        if (curFileCnt > remainFileCnt) {
            Swal.fire({
                text: '첨부파일은 최대 ' + maxFileCnt + '개 까지 첨부 가능합니다.',
                showConfirmButton: false,
                timer: 1500
            })
        } else {
            for (const file of obj.files) {
                // 첨부파일 검증
                if (validation(file)) {
                    let reader = new FileReader();
                    reader.onload = function () {
                        filesArr.push(file);
                    };
                    reader.readAsDataURL(file);

                    // 목록 추가
                    let htmlData = '';
                    htmlData += '<div id="file' + fileNo + '" class="filebox">';
                    htmlData += '   <p class="name">' + file.name + '</p>';
                    htmlData += '   <a class="delete" onclick="deleteFile(' + fileNo + ');"><i class="icon i-close"></i></a>';
                    htmlData += '</div>';
                    $('.file-list').append(htmlData);
                    fileNo++;
                } else {
                    continue;
                }
            }
        }
        // 초기화
        document.querySelector("input[type=file]").value = "";
    }

    /* 첨부파일 검증 */
    function validation(file) {
        if (file.name.length > 100) {
            Swal.fire({
                text: '파일명이 100자 이상인 파일은 제외되었습니다',
                showConfirmButton: false,
                timer: 1500
            })
            return false;
        } else if (file.size > (100 * 1024 * 1024)) {
            Swal.fire({
                text: '최대 파일 용량인 100MB를 초과한 파일은 제외되었습니다',
                showConfirmButton: false,
                timer: 1500
            })
            return false;
        } else if (file.name.lastIndexOf('.') == -1) {
            Swal.fire({
                text: '확장자가 없는 파일은 제외되었습니다',
                showConfirmButton: false,
                timer: 1500
            })
            return false;
        } else {
            return true;
        }
    }

    /* 첨부파일 삭제 */
    function deleteFile(num) {
        document.querySelector("#file" + num).remove();
        filesArr[num].is_delete = true;
    }
</script>