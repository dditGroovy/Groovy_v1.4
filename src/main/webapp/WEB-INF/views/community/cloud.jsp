<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authentication property="principal" var="CustomUser"/>

<link rel="stylesheet" href="/resources/css/community/cloud.css">
<div class="content-container">
    <header id="tab-header">
        <div class="header">
            <h1><a href="#" class="on">GROOM(업로드하지마세요...)</a></h1>
            <p class="font-reg font-18">팀원들과 <span class="font-md span-text">구름</span>에서 만나요 ☁️</p>
        </div>
    </header>
    <div class="cloud">
        <div class="nav-box">
            <div class="path-box">
                <ul class="path-nav">

                </ul>
            </div>
            <div class="button-wrapper">
                <button class="addFolder btn btn-free-blue btn-cloud font-md font-14"><i class="icon i-folder"></i>폴더 생성
                </button>
                <button class="uploadFile btn btn-free-blue btn-cloud font-md font-14"><i class="icon i-download"></i>올리기
                </button>
            </div>
        </div>
        <div class="cloud-wrapper">
            <div class="file-wrapper">
                <c:forEach var="folder" items="${folderList}">
                    <div class="folder-click">
                        <a href="/cloud/main?path=${folder.path}" class="folder-box cursor-box"
                           oncontextmenu="right(event);">
                            <i class="icon-img folder-img"></i>
                            <p class="font-md font-14">${folder.subfolderName}</p>
                        </a>
                        <button class="folder-delete-box btn btn-fill-wh-sm font-14" data-path="${folder.path}"
                                onclick="deleteFolder(this)">폴더 삭제
                        </button>
                    </div>
                </c:forEach>
                <c:forEach var="file" items="${fileList}">
                    <c:set var="fileParts" value="${fn:split(file.key, '.')}"/>
                    <c:set var="extension" value="${fileParts[1]}"/>
                    <c:set var="extensionToIcon" value="${extensionList}"/>
                    <c:set var="iconClass" value="${extensionToIcon[extension]}"/>

                    <div class="file-box cursor-box" data-key="${file.storageClass}" onclick="fileInfo(this)">
                        <c:choose>
                            <c:when test="${empty iconClass}">
                                <i class="icon-img other-img"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="icon-img ${iconClass}"
                                   style="background: url('/resources/images/cloud/${iconClass}.png') no-repeat;"></i>
                            </c:otherwise>
                        </c:choose>
                        <p class="font-md font-14">${fileParts[0]}</p>
                    </div>
                </c:forEach>
            </div>
            <div class="cloud-preview">
                <div class="title-box">
                    <h1 class="content-name font-reg font-24"></h1>
                    <button type="button" class="close font-md font-18">X</button>
                </div>
                <div class="content-preview"></div>
                <div class="info-box">
                    <p class="font-md font-18 preview-title">유형</p>
                    <p class="content-type font-reg font-14 color-font-md"></p>
                </div>
                <div class="info-box">
                    <p class="font-md font-18 preview-title">마지막 수정</p>
                    <p class="last-date font-reg font-14 color-font-md"></p>
                </div>
                <div class="info-box">
                    <p class="font-md font-18 preview-title">크기</p>
                    <p class="content-size font-reg font-14 color-font-md"></p>
                </div>
                <div class="info-box border-none">
                    <p class="font-md font-18 preview-title">공유한 사람</p>
                    <p class="share-name font-reg font-14 color-font-md"></p>
                </div>
                <div class="button-box">
                    <button type="button" class="btn btn-download font-md font-14 color-font-md">다운로드</button>
                    <button type="button" class="btn btn-delete font-md font-14 color-font-md">삭제</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let dept = `${CustomUser.employeeVO.deptNm}`;
    let path = `${folderPath}`;
    let previewBox = document.querySelector(".cloud-preview");
    let closeBtn = document.querySelector(".close");
    let pathBox = document.querySelector(".path-nav");

    function pathMap() {
        code = `
            <li class="path-li"><a href="/cloud/main" class="font-reg font-24 color-font-md">\${dept}팀</a></li>
            `;

        let pathParts = path.split("/");

        let url = `\${pathParts[0]}/`;
        for (i = 1; i < pathParts.length; i++) {
            url += `\${pathParts[i]}/`;
            code += `<li class="path-li"><i class="icon i-arr-rt path-icon"></i><a href="/cloud/main?path=\${url}" class="font-reg font-24 color-font-md">\${pathParts[i]}</a></li>`;
        }
        pathBox.innerHTML = code;
    }

    function deleteFolder(deletebtn) {
        let url = deletebtn.getAttribute("data-path");

        if (!confirm("폴더를 삭제하시면 폴더의 모든 파일이 삭제됩니다. 정말 삭제하시겠습니까?")) {

        } else {
            $.ajax({
                type: 'delete',
                url: `/cloud/deleteFolder?path=\${url}`,
                success: function () {
                    deletebtn.parentElement.remove();
                },
                error: function (xhr) {
                    console.log(xhr.status);
                }
            });
        }
    }

    function fileInfo(infoBox) {
        let key = infoBox.getAttribute("data-key");
        console.log(key)
        let filename = infoBox.querySelector("p").innerText;
        console.log(filename)
        $.ajax({
            type: 'get',
            url: `/cloud/fileInfo?key=\${key}`,
            success: function (fileInfo) {
                console.log(fileInfo);
                let preview = document.querySelector(".content-preview");
                preview.style.background = '';
                preview.innerText = '';
                document.querySelector(".content-name").innerText = filename;
                document.querySelector(".content-type").innerText = fileInfo.type;

                let sizeBox = document.querySelector(".content-size");
                let size = fileInfo.size;
                if (size < 1000) {
                    sizeBox.innerText = size + "바이트";
                } else if (1000 <= size < 1000 * 1000) {
                    sizeBox.innerText = (size / 1000).toFixed(1) + "KB";
                } else if (1000 * 1000 <= size < 1000 * 1000 * 1000) {
                    sizeBox.innerText = (size / (1000 * 1000)).toFixed(1) + "MB";
                } else {
                    sizeBox.innerText = (size / (1000 * 1000 * 1000)).toFixed(1) + "GB";
                }
                document.querySelector(".last-date").innerText = fileInfo.lastDate;
                document.querySelector(".share-name").innerText = fileInfo.emplNm;
                let extensions = fileInfo.type.split("/");
                let extension = extensions[0];
                if (extension == 'image') {
                    console.log(key)
                    let imgUrl = `https://groovy-dazzi.s3.ap-northeast-2.amazonaws.com/\${key}`;
                    let imageElement = document.createElement("img");
                    imageElement.setAttribute("src", imgUrl);
                    preview.appendChild(imageElement);
                } else {
                    preview.innerHTML = '<p>미리보기를 지원하지 않는 파일입니다.</p>';
                }
                previewBox.style.display = "block";
            },
            error: function (xhr) {
                console.log(xhr.status);
            }
        })
    }

    function uploadFile(fileName) {
        console.log("fileName", fileName);
        let form = new FormData();
        form.append("file", fileName);
        form.append("path", path);
        $.ajax({
            url: "/cloud/uploadFile",
            type: "POST",
            data: form,
            contentType: false,
            processData: false,
            success: function () {
                location.reload();
            },
            error: function (error) {
                console.error("파일 업로드 실패", error.status);
            },
        });
    }

    let valid = false;
    const right = (event) => {
        event.preventDefault();
        let deleteBtn = event.target.parentElement.nextElementSibling;
        deleteBtn.classList.add("on");
        valid = true;
    }

    document.addEventListener('click', function (e) {
        if (valid == true && !e.target.classList.contains("folder-delete-box")) {
            let deleteBtns = document.querySelectorAll(".folder-delete-box");
            deleteBtns.forEach(btn => {
                btn.classList.remove("on");
            });
            valid = false;
        }
    });

    pathMap();

    closeBtn.addEventListener("click", () => {
        previewBox.style.display = "none";
    });

    /* 파일 드래그 앤 드롭 */
    const fileBox = document.querySelector(".file-wrapper");
    let formData;

    /* 박스 안에 Drag 들어왔을 때 */
    fileBox.addEventListener('dragenter', function (e) {
    });
    /* 박스 안에 Drag를 하고 있을 때 */
    fileBox.addEventListener('dragover', function (e) {
        e.preventDefault();
        const vaild = e.dataTransfer.types.indexOf('Files') >= 0;
        !vaild ? this.style.backgroundColor = '#F5FAFF': this.style.backgroundColor = '#F5FAFF';
        !vaild ? this.style.border = "2px solid #C3D8F5": this.style.border = "3px solid #C3D8F5";
        !vaild ? this.style.borderRadius = "12px" : this.style.borderRadius = "12px";
    });
    /* 박스 밖으로 Drag가 나갈 때 */
    fileBox.addEventListener('dragleave', function (e) {
        this.style.backgroundColor = '#F9FAFB';
        this.style.border = "none";
        this.style.borderRadius = "0";
    });
    /* 박스 안에서 Drag를 Drop했을 때 */
    fileBox.addEventListener('drop', function (e) {
        e.preventDefault();
        this.style.backgroundColor = '#F9FAFB';
        this.style.border = "none";
        this.style.borderRadius = "0";

        const data = e.dataTransfer;
        // 유효성 검사
        if (!isValid(data)) return;
        //파일 이름을 text로 표시
        uploadFile(data.files[0]);
    });

    /*  파일 유효성 검사   */
    function isValid(data) {

        // 파일인지 유효성 검사
        if (data.types.indexOf('Files') < 0)
            return false;

        // 파일의 개수 제한
        if (data.files.length > 1) {
            alert('파일은 하나씩 전송이 가능합니다.');
            return false;
        }

        // 파일의 사이즈 제한
        if (data.files[0].size >= 1024 * 1024 * 50) {
            alert('50MB 이상인 파일은 업로드할 수 없습니다.');
            return false;
        }
        return true;
    }
</script>