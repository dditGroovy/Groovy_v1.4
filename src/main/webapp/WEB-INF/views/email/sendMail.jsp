<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .contentWrap {
        margin-left: 400px;
    }
</style>
<sec:authentication property="principal" var="CustomUser"/>
<div class="contentWrap">
    <form action="#" method="post" id="mailForm" enctype="multipart/form-data">
        <table border="1" style="width: 50%">
            <tr>
                <th>받는 사람</th>
                <td>
                    <span id="receiveTo"></span>
                    <input type="text" name="emailToAddr" id="emailToAddr">
                    <button type="button" id="orgBtnTo">조직도</button>

                </td>
            </tr>
            <tr>
                <th>참조</th>
                <td>
                    <span id="receiveCc"></span>
                    <input type="text" name="emailCcAddr" id="emailCcAddr">
                    <button type="button" id="orgBtnCc">조직도</button>
                </td>
            </tr>
            <tr>
                <th>제목</th>
                <td>
                    <input type="text" name="emailFromSj" id="emailFromSj">
                </td>
            </tr>
            <tr>
                <th>파일첨부</th>
                <td>
                    <input type="file" name="emailFiles" id="file" multiple>
                </td>
            </tr>
            <tr>
                <th>내용</th>
                <td>
                    <textarea id="editor" name="emailFromCn" required></textarea>
                </td>
            </tr>
        </table>
        <div class="serviceWrap">
            <div class="serviceWrap">
                <div class="writeWrap">
                    <button type="button" id="sendBtn">보내기</button>
                    <button type="button" id="saveBtn">임시저장</button>
                    <button type="button" id="resveBtn">예약</button>
                </div>
            </div>
        </div>
    </form>
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

        let xhr = new XMLHttpRequest();
        xhr.open("post", "/email/send", true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                console.log(xhr.responseText);
                if (xhr.responseText === "success") {
                    //알림 보내기
                    $.get("/alarm/getMaxAlarm")
                        .then(function (maxNum) {
                            maxNum = parseInt(maxNum) + 1;
                            let url = '/email/all';
                            let subject = formData.get("emailFromSj");
                            let content = `<div class="alarmBox">
                                         <a href="\${url}" id="fATag" data-seq="\${maxNum}">
                                                                    <h1>[메일]</h1>
                                                                    <p>[<span style="white-space: nowrap;
                                                                      display: inline-block;
                                                                      overflow: hidden;
                                                                      text-overflow: ellipsis;
                                                                      max-width: 15ch;">\${subject}</span>]
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
                                    alert("메일을 성공적으로 전송했습니다.");
                                    location.href = "/email/all";
                                },
                                error: function (xhr) {
                                    console.log(xhr.status);
                                }
                            });
                        })
                        .catch(function (error) {
                            console.log("최대 알람 번호 가져오기 오류:", error);
                        });
                } else {
                    alert("메일 전송에 실패했습니다. 다시 시도해주세요");
                }
            }
        }
        xhr.send(formData);
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
                    alert("이메일 형식이 아닙니다. 다시 입력해주세요.");
                    emailAddrInput.value = '';
                    return;
                }
                if (value) {
                    let newSpan = document.createElement('span');
                    newSpan.textContent = value + " ";

                    let newButton = document.createElement("button");
                    newButton.setAttribute("type", "button");
                    newButton.setAttribute("class", "close-empl");
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
                                    str += `<span data-id=\${empl.emplId}>
                                            \${empl.emplNm}
                                            <button type="button" class="close-empl">X</button>
                                        </span>
                                            <input type="hidden" name="emplIdToArr" value="\${empl.emplId}">`;
                                } else if (orgBtn.getAttribute("id") === "orgBtnCc") {
                                    str += `<span data-id=\${empl.emplId}>
                                            \${empl.emplNm}
                                            <button type="button" class="close-empl">X</button>
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


</script>