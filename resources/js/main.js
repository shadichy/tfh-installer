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
    opt = document.querySelector("div#btn"),
    sel = document.querySelectorAll("div#btn > button"),
    pathedit = false,
    unavail = "",
    usecustompath=false,
    info={},
    response={},
    lim=0,
    stage=0,
    nomc=false

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
            opt.style.display = "none"
            break;
        case 2:
            btn[0].innerHTML = "Trở lại"
            btn[1].innerHTML = "Tiếp tục"
            ptag[state-2].style.display = "none"
            ptag[state-1].style.display = "flex"
            ptag[state].style.display = "none"
            ptag[state+1].style.display = "none"
            inx.style.display = both==2?"block":"none"
            sct[0].style.display = "none"
            sct[1].style.display = "none"
            document.querySelector(`.not.javaFolder`).style.display = "none"
            document.querySelector(`.not.bedrockFolder`).style.display = "none"
            stat=true
            usecustompath=false
            opt.style.display = "flex"
            btnbar.style.display = nomc?"none":"flex"
            break;
        case 3:
            chekBoxes()
            ptag[state-2].style.display = "none"
            ptag[state-1].style.display = "block"
            inx.style.display = "block"
            sct[0].style.display = "block"
            sct[1].style.display = "block"
            // stat=false
            mcrcpath=mcreply
            usecustompath=true
            opt.style.display = "none"
            btnbar.style.display = "flex"
            break;
        case 4:
            for (const i of ["java","bedrock"]) if (document.getElementById(i).checked && !document.getElementById(i + "Worlds").value) {
                document.getElementById(i + "Worlds").style.borderColor = "red"
                state=3
                return;
            }
            usecustompath?info=mcrcpath:info=mcreply
            for (const i of ["java","bedrock"]) if (info[i + "Worlds"]) document.getElementById(i + "Final").style.visibility = "visible"
            for (const key of ["javaFolder","bedrockFolder","javaWorlds","bedrockWorlds"]) document.querySelector(`.final.${key}`).innerHTML = info[key]
            document.querySelector(`.not.javaFolder`).style.display = "none"
            document.querySelector(`.not.bedrockFolder`).style.display = "none"
            ptag[state-3].style.display = "none"
            ptag[state-2].style.display = "none"
            ptag[state-1].style.display = "block"
            ptag[state].style.display = "none"
            inx.style.display = "none"
            sct[0].style.display = "none"
            sct[1].style.display = "none"
            opt.style.display = "none"
            stat=false
            break;
        case 5:
            if (!document.getElementById("agdk").checked) {
                document.querySelector("#dksd > label").style.color="red"
                state--
                break;
            }
            startInstall(info)
            for (const i of ["java","bedrock"]) {
                if (info[i + "Worlds"]) {
                    document.querySelector(`#${i}Install`).style.display = "block"
                    lim++
                    loadInstall(i)
                }
            }
            ptag[state-2].style.display = "none"
            ptag[state-1].style.display = "block"
            btnbar.style.display = "none"
            break;
        case 6:
            ptag[state-2].style.display = "none"
            ptag[state-1].style.display = "block"
            break;
    }
}

const loadInstall = async (w)=>{
    let ps = document.getElementsByClassName("percent"),
        vers = ["java","bedrock"],
        defc = [20,20],
        d = [20,42,56,84,96],
        t = [20,10,15,10],
        prog = (i)=>{
            let g = 0,
                e = d[g],
                p = d[g+1],
                m=()=>{
                    // console.log("running")
                    if (response[vers[i]]) {
                        p=100
                        f()
                        stage++
                        if (stage == lim) {
                            state++
                            setTimeout(states,2000)
                        }
                    } else setTimeout(m,1000)
                },
                f=()=>{
                    e++
                    ps[i].style.width = e + "%"
                    if (e<p) {
                        setTimeout(f,1)
                        // console.log("updating")
                    } else if (e==p) {
                        if (g+1!=d.length){
                            g++
                            p = d[g+1]
                            setTimeout(f,t[g]*100)
                        }
                        if (g+1==d.length) {
                            m()
                        }
                    }
                }
            f()
        }
    for (const i of [0,1]) {
        let t
        i==0?t=2000:t=3000
        if (w == vers[i]) setTimeout(()=>{prog(i)},t)
    }
}

function openLink(link) {
    Neutralino.os.open(`http://${link}`);
}

const checkOS = async (cmd)=>{
    let asd = await Neutralino.os.execCommand(cmd);
    ostype.innerHTML = asd.stdOut
}

const startInstall = async (src)=>{
    let asd = await Neutralino.os.execCommand(`sh -c '\\
isjava=${src.java} \\
isbedrock=${src.bedrock} \\
javaFolder=${src.javaFolder} \\
bedrockFolder=${src.bedrockFolder} \\
javaWorlds=${src.javaWorlds} \\
bedrockWorlds=${src.bedrockWorlds} \\
JLauncher=${src.JLauncher} \\
resources/scripts/install'`);
    if (asd.stdErr) {
        document.querySelector("#p6>h1").innerHTML = "Đã xảy ra lỗi"
        document.querySelector("#p6>p").innerHTML = `Cài đặt thất bại! Vui lòng liên hệ với Team Fuho qua <button onclick="openLink('facebook.com/teamfuho')">Fanpage</button>, <button onclick="openLink('teamfuho.net/vi/comm#feedback')">Website</button> hoặc <button onclick="Neutralino.os.open('mailto:teamfuhovietnam@gmail.com')">Email</button> để được hỗ trợ.`
        document.getElementById("err").style.display = "block"
        document.querySelector("#err > div > p").innerHTML = asd.stdErr.replace(/\n/g,"<br/>")
        response = asd.stdErr.replace(/\n/g,"<br/>")
        state++
        states()
        return
    }
    response = JSON.parse(asd.stdOut)
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
    let asd = await Neutralino.os.execCommand(`sh -c 'resources/scripts/checkmc ${NL_OS}'`);
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
            a="Thiết bị của bạn được phát hiện đã cài đặt một phiên bản <strong class='ora'>Minecraft ",
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
            nomc=true
        }
    }
    inpRenew(mcreply)
    chekBoxes()
}

function inpRenew(data) {
    for (const key of ["javaFolder","bedrockFolder","javaWorlds","bedrockWorlds"]) {
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
        asd = await Neutralino.os.execCommand(NL_OS=="Windows"?`resources/scripts/checkmc.bat ${document.getElementById(id).value}`:`sh -c 'resources/scripts/checkmc ${NL_OS} ${document.getElementById(id).value}'`);
    mcrcpath = JSON.parse(asd.stdOut)
    pal.value = mcrcpath[iw]
    pel.style.display = "block"
    let a="ìm thấy phiên bản <strong style='color:inherit'>Minecraft ",
        b="</strong> hợp lệ"
    pel.style.color = "#32cd32"
    if (mcrcpath.java && id.includes("java")) {
        pel.innerHTML = `T${a}Java</strong> bởi <strong>${checkLauncher(mcrcpath.JLauncher)}${b}`
    } else if (mcreply.bedrock && id.includes("bedrock")) {
        pel.innerHTML = `T${a}Bedrock${b}`
    } else {
        pel.innerHTML = `Không t${a}${b}`
        pel.style.color = "red"
        unavail = iw
    }
}

function chekBoxes(){
    let ch = (a,b)=>{for (const x of ["input","button"]) for (let i = 0; i < 2; i++) sct[a].querySelectorAll(x)[i].disabled = b}
    btn[1].disabled = false
    if (ichx[0].checked && ichx[1].checked) {
        ichx[0].disabled = false
        ichx[1].disabled = false
        for (let z = 0; z < 2; z++) ch(z,false)

    }
    if (ichx[0].checked && !ichx[1].checked){
        ichx[0].disabled = true
        ch(1,true)
        document.querySelector(`.not.javaFolder`).style.display = "none"
        
    }
    if (!ichx[0].checked && ichx[1].checked){
        ichx[1].disabled = true
        ch(0,true)
        document.querySelector(`.not.bedrockFolder`).style.display = "none"
    }
    if (!ichx[0].checked && !ichx[1].checked && state == 3) {
        btn[1].disabled = true
    }
}

const selFolder = async (dir)=>{
    let tar = await Neutralino.os.showFolderDialog("Chọn thư mục")
    document.getElementById(dir).value = tar
    document.getElementById(dir.split("Worlds")[0]).checked=true
    if (dir.includes("Folder")) checkPath(dir)
    else document.querySelector(`.not.${dir.split("Worlds")[0]+"Folder"}`).style.display = "none"
    if (dir.includes("Worlds")) {
        mcrcpath[dir.split("Worlds")[0]] = true
        mcrcpath[dir] = tar
    }
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
checkOS(NL_OS=="Windows"?"ver":"sh -c 'resources/scripts/neofetch'")
checkMC()
states()
// let pyver = await Neutralino.os.execCommand('python --version');
// console.log(`Your Python version: ${pyver.stdOut}`);
// var f = await Neutralino.filesystem.getStats(dir).catch(error=>error);
// f.then(()=>{console.log(f.isDirectory)})