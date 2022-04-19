// This is just a sample app. You can structure your Neutralinojs app code as you wish.
// This example app is written with vanilla JavaScript and HTML.
// Feel free to use any frontend framework you like :)
// See more details: https://neutralino.js.org/docs/how-to/use-a-frontend-library

let ostype = document.getElementById("os"),
    dirStat,
    // hasJava=false,
    // hasBedrock=false,
    // javaFolder,
    // bedrockFolder,
    // javaSaves="saves",
    // bedrockWorlds="minecraftWorlds",
    state = 1,
    mcreply = {},
    mcrcpath = {},
    ptag = document.getElementsByClassName("p"),
    btn = document.querySelectorAll("#btnbar > button"),
    btnbar = document.getElementById("btnbar"),
    both = 0,
    stat=true,
    inx = document.querySelector("div#sel"),
    sct = document.querySelectorAll("div#sel > section"),
    ichx = document.querySelectorAll("div#sel > label > input"),
    sel = ptag[1].querySelectorAll("div > button"),
    pathedit = false,
    unavail = "",
    usecustompath=false

function states(){
    (state==3&&!pathedit)?(stat?state++:state--):pathedit=false
    switch (state) {
        case 0:
            Neutralino.app.exit();
            break;
        case 1:
            btn[0].innerHTML = "Thoát"
            btn[1].innerHTML = "Bắt đầu"
            ptag[state-1].style.display = "block"
            ptag[state].style.display = "none"
            inx.style.display = "none"
            // stat=true
            break;
        case 2:
            btn[0].innerHTML = "Trở lại"
            btn[1].innerHTML = "Tiếp tục"
            ptag[state-2].style.display = "none"
            ptag[state-1].style.display = "flex"
            ptag[state].style.display = "none"
            ptag[state+1].style.display = "none"
            inx.style.display = both!=1?"block":"none"
            sct[0].style.display = "none"
            sct[1].style.display = "none"
            document.querySelector(`.not.javaFolder`).style.display = "none"
            document.querySelector(`.not.bedrockFolder`).style.display = "none"
            stat=true
            usecustompath=false
            break;
        case 3:
            ptag[state-2].style.display = "none"
            ptag[state-1].style.display = "block"
            inx.style.display = "block"
            sct[0].style.display = "block"
            sct[1].style.display = "block"
            // stat=false
            usecustompath=true
            break;
        case 4:
            if (!document.getElementById("bedrockWorlds").value && !document.getElementById("javaWorlds").value) {
                state--
                break;
            }
            document.querySelector(`.not.javaFolder`).style.display = "none"
            document.querySelector(`.not.bedrockFolder`).style.display = "none"
            ptag[state-3].style.display = "none"
            ptag[state-2].style.display = "none"
            ptag[state-1].style.display = "block"
            inx.style.display = "none"
            sct[0].style.display = "none"
            sct[1].style.display = "none"
            stat=false
            break;
    }
}

function openLink(link) {
    Neutralino.os.open(`http://${link}`);
}

const checkOS = async (cmd)=>{
    let asd = await Neutralino.os.execCommand(cmd);
    ostype.innerHTML = asd.stdOut
}

// const exec = (cmd) => new Promise((resolve,reject)=>{
//     let out
//     let asd = (async ()=>await Neutralino.os.execCommand(cmd))()
//     if (asd.stdOut) resolve(asd.stdOut)
//     else reject(asd.stdErr)
// })
// async function exec(cmd){
//     let asd = await Neutralino.os.execCommand(cmd);
//     return JSON.parse(asd.stdOut)
// }
const checkFolder = async (dir)=>{
    let stats = await Neutralino.filesystem.getStats(dir).catch(error=>error);
    dirStat = stats.isDirectory

}
const checkMC = async ()=>{
    let asd = await Neutralino.os.execCommand(`sh -c './resources/scripts/checkmc ${NL_OS}'`);
    mcreply = JSON.parse(asd.stdOut)
    if (mcreply.java) {
        ichx[0].checked = true
    }
    if (mcreply.bedrock) {
        ichx[1].checked = true
    }
    if (mcreply.java && mcreply.bedrock) {
        both=2
    } else {
        both=1
        inx.style.display="none"
        let elem = ptag[1].querySelector("p"),
            a="Thiết bị của bạn được phát hiện đã cài đặt một phiên bản <strong>Minecraft ",
            b="</strong> đã được cài đặt ",
            c="tại <strong>"
        if (mcreply.java) {
            elem.innerHTML=`${a}Java${b}bởi <strong>${checkLauncher(mcreply.JLauncher)}</strong> ${c}${mcreply.javaFolder}</strong>.`
        } else if (mcreply.bedrock) {
            elem.innerHTML=`${a}Bedrock${b}${mcreply.bedrockFolder}</strong>.`
        } else {
            both=0
            inx.style.display="none"
            elem.innerHTML = `Thiết bị của bạn dường như không có phiên bản <strong>Minecraft</strong> nào đã được cài đặt. Vui lòng cài đặt <strong>Minecraft</strong> và thử lại!`
            sel[0].style.display = "block"
            btnbar.sttyle.display = "none"
        }
    }
    inpRenew(mcreply)
    chekBoxes()
}

function inpRenew(data) {
    for (const key in {"javaFolder":"","bedrockFolder":"","javaWorlds":"","bedrockWorlds":""}) {
        document.querySelector(`input#${key}`).value = data[key]
    }
}

function checkLauncher(lid){
    let launcher = "Minecraft Launcher"
    switch (lid) {
        case "tl":
            launcher = "TLauncher"
            break;
        case "multimc":
            launcher = "MultiMC Launcher"
            break;
    }
    return launcher;
}

const checkPath = async (id)=>{
    let iw = id.split("Folder")[0]+"Worlds",
        pel = document.querySelector(`.not.${id}`),
        pal = document.getElementById(iw),
        asd = await Neutralino.os.execCommand(`sh -c './resources/scripts/checkmc ${NL_OS} ${document.getElementById(id).value}'`);
    mcrcpath = JSON.parse(asd.stdOut)
    pal.value = mcrcpath[iw]
    pel.style.display = "block"
    let a="Tìm thấy phiên bản <strong>Minecraft ",
        b="</strong> hợp lệ"
    pel.style.color = "#32cd32"
    if (mcrcpath.java && id.includes("java")) {
        pel.innerHTML = `${a}Java</strong> bởi <strong>${checkLauncher(mcrcpath.JLauncher)}${b}`
    } else if (mcreply.bedrock && id.includes("bedrock")) {
        pel.innerHTML = `${a}Bedrock${mcrcpath.JLauncher}${b}`
    } else {
        pel.innerHTML = "Không tìm thấy phiên bản <strong>Minecraft</strong> hợp lệ"
        pel.style.color = "red"
        unavail = iw
    }
}

function chekBoxes(){
    if (ichx[0].checked && ichx[1].checked) {
        ichx[0].disabled = false
        ichx[1].disabled = false
        for (let z = 0; z < 2; z++) for (const x in {"input":"","button":""}) for (let i = 0; i < 2; i++) sct[z].querySelectorAll(x)[i].disabled = false

    } else if (ichx[0].checked && !ichx[1].checked){
        ichx[0].disabled = true
        for (const x in {"input":"","button":""}) for (let i = 0; i < 2; i++) sct[1].querySelectorAll(x)[i].disabled = true
        document.querySelector(`.not.javaFolder`).style.display = "none"
        
    } else if (!ichx[0].checked && ichx[1].checked){
        ichx[1].disabled = true
        for (const x in {"input":"","button":""}) for (let i = 0; i < 2; i++) sct[0].querySelectorAll(x)[i].disabled = true
        document.querySelector(`.not.bedrockFolder`).style.display = "none"
        
    }
}

const selFolder = async (dir)=>{
    let tar = await Neutralino.os.showFolderDialog("Chọn thư mục")
    document.getElementById(dir).value = tar
    if (dir.includes("Folder")) checkPath(dir)
    else document.querySelector(`.not.${dir.split("Worlds")[0]+"Folder"}`).style.display = "none"
}

// function setTray() {
//     if(NL_MODE != "window") {
//         console.log("INFO: Tray menu is only available in the window mode.");
//         return;
//     }
//     let tray = {
//         icon: "/resources/icons/trayIcon.png",
//         menuItems: [
//             {id: "VERSION", text: "Get version"},
//             {id: "SEP", text: "-"},
//             {id: "QUIT", text: "Quit"}
//         ]
//     };
//     Neutralino.os.setTray(tray);
// }

// function onTrayMenuItemClicked(event) {
//     switch(event.detail.id) {
//         case "VERSION":
//             Neutralino.os.showMessageBox("Version information",
//                 `Neutralinojs server: v${NL_VERSION} | Neutralinojs client: v${NL_CVERSION}`);
//             break;
//         case "QUIT":
//             Neutralino.app.exit();
//             break;
//     }
// }

function onWindowClose() {
    Neutralino.app.exit();
}

Neutralino.init();

// Neutralino.events.on("trayMenuItemClicked", onTrayMenuItemClicked);
Neutralino.events.on("windowClose", onWindowClose);

// if(NL_OS != "Darwin") { // TODO: Fix https://github.com/neutralinojs/neutralinojs/issues/615
//     setTray();
// }

// showInfo();
// ostype.innerHTML = (NL_OS=="Darwin"?"Mac OS":NL_OS=="Windows"?:"");
checkOS("sh -c './resources/scripts/neofetch'")
checkMC()
states()
// let pyver = await Neutralino.os.execCommand('python --version');
// console.log(`Your Python version: ${pyver.stdOut}`);
// var f = await Neutralino.filesystem.getStats(dir).catch(error=>error);
// f.then(()=>{console.log(f.isDirectory)})