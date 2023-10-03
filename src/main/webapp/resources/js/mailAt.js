const allCheck = document.querySelector("#selectAll");
let checkboxes = document.querySelectorAll('.selectmail:checked');

function checkAll() {
    let checkboxes = document.querySelectorAll(".selectmail");
    checkboxes.forEach(function (checkbox) {
        checkbox.checked = allCheck.checked;
    });
}

function modifyTableAt(td) {
    let code = td.getAttribute("data-type");
    if (code === 'redng' || code === 'imprtnc') {
        let at = td.innerText;
        let emailEtprCode = td.closest("tr").getAttribute("data-id");
        $.ajax({
            url: `/email/${code}/${emailEtprCode}`,
            type: 'put',
            data: at,
            beforeSend : function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
            },
            success: function (result) {
                at = result;
                td.innerHTML = at;
            },
            error: function (xhr, status, error) {
                console.log("code: " + xhr.status);
                console.log("message: " + xhr.responseText);
                console.log("error: " + xhr.error);
            }
        });
    } else {
        code = 'delete';
        let emailEtprCode = td.closest("tr").getAttribute("data-id");
        let at = document.querySelector("input[name=deleteAt]").value;
        $.ajax({
            url: `/email/${code}/${emailEtprCode}`,
            type: 'put',
            data: at,
            beforeSend : function(xhr) {
                xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
            },
            success: function (result) {
                td.remove();
            },
            error: function (xhr, status, error) {
                console.log("code: " + xhr.status);
                console.log("message: " + xhr.responseText);
                console.log("error: " + xhr.error);
            }
        });
    }
}

function modifyAtByBtn() {
    checkboxes = document.querySelectorAll(".selectmail:checked");
    checkboxes.forEach(function (checkbox) {
        let td = checkbox.parentNode.nextElementSibling;
        modifyTableAt(td);
        checkbox.checked = false;
        allCheck.checked = false;
    });
}

function modifyDeleteAtByBtn() {
    checkboxes = document.querySelectorAll(".selectmail:checked");
    checkboxes.forEach(function (checkbox) {
        let tr = checkbox.closest("tr");
        modifyTableAt(tr);
        checkbox.checked = false;
        allCheck.checked = false;
    });
}
