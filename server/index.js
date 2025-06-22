// Libraries

const Express = require("express")
const FileSystem = require("fs")
const Path = require("path")

// Constants

const Application = Express()
const Port = 8000

// Assets

const Assets = ["aimbot.lua", "esp.lua", "spinbot.lua", "noclip.lua", "uilibrary.lua", "loadstring.lua", "loader.lua"]

// Main

Application.use(Express.static(__dirname + "/assets"))
Application.use(Express.static(__dirname + "/pages"))
Application.use(Express.static(__dirname + "/pages/landingpage"))
Application.use(Express.static(__dirname + "/pages/landingpage/images"))
Application.use(Express.static(__dirname + "/pages/landingpage/images/intlTelInput"))

Application.get("/", (Request, Result) => {
    //Result.redirect("https://discord.gg/x-ro")
    Result.sendFile(Path.join(__dirname, "pages", "landingpage", "index.html"))
})

Application.get("/traphouse", (Request, Result) => {
    Result.send(FileSystem.readFileSync(__dirname + "/assets/traphouse.mp4"))
})

Application.get("/download", (Request, Result) => {
    Result.download(__dirname + "/assets/x-ro.lua")
})

for (let Asset of Assets) {
    Application.get("/modules/" + Asset, (Request, Result) => {
        if (Request.get("Accept-Language") || !Request.get("user-agent").match("Roblox/WinInet")) {
            Result.sendFile(Path.join(__dirname, "pages", "skid.html"))
        } else {
            Result.send(FileSystem.readFileSync("modules/" + Asset))
        }
    })
}

Application.listen(Port, () => {
    console.log("Application listening on port", Port)
})