JSON.minify = require("node-json-minify")
const
    { minify } = require("terser");
	csso = require("csso"),
	fs = require("fs"),
	path = require("path"),
	htminify = (o) => require("html-minifier").minify(o, {
		collapseWhitespace: true,
		conservativeCollapse: true,
		// removeEmptyAttributes: true,
		// removeRedundantAttributes: true,
		sortAttributes: true,
		useShortDoctype: true,
		removeComments: true,
		minifyJS: true,
		minifyCSS: true,
		removeScriptTypeAttributes: true,
		removeStyleLinkTypeAttributes: true,
		decodeEntities: true,
		keepClosingSlash: false,
	}),
    options = {
        toplevel: false,
        compress: {
            global_defs: {
                // "@console.log": "debug",
            },
            passes: 2
        },
        format: {
            preamble: "/* Copyright: Team Fuho Vietnam (tm), All Rights Reserved */"
        }
    },
    js = async (d)=>{
        const final = await minify(d, options)
        fs.writeFileSync(path.join(__dirname, "out/resources/js", "main.js"), final.code)
    },
    shorten = (i,o,n,cb)=>fs.writeFileSync(path.join(__dirname, o, n), cb(fs.readFileSync(path.join(__dirname, i, n), "utf8").toString())),
    sjson = (n)=>shorten("resources/scripts", "out/dist/hpvn", n, (e)=>JSON.minify(JSON.stringify(JSON.parse(e))))


// fs.writeFileSync(path.join(__dirname, "out/resources", "index.html"), htminify(fs.readFileSync(path.join(__dirname, "resources", "index.html"), "utf8").toString()))
shorten("resources", "out/resources", "index.html", htminify)

// fs.writeFileSync(path.join(__dirname, "out/resources", "styles.css"), csso.minify(fs.readFileSync(path.join(__dirname, "resources", "styles.css"), "utf8").toString()).css)
shorten("resources", "out/resources", "styles.css", (e)=>csso.minify(e).css)

fs.readFile(path.join(__dirname, "resources/js", "main.js"), "utf8",(e,r)=>js(r.replace(/resources\/scripts/g,".")))

fs.readFile(path.join(__dirname, "neutralino.config.json"), "utf8",(e,r)=>{
    let data = JSON.parse(r)
    if (!process.argv.includes("debug") && !process.argv.includes("\"debug\"")) data.modes.window.enableInspector = false
    fs.writeFileSync(path.join(__dirname, "out", "neutralino.config.json"), JSON.minify(JSON.stringify(data)))
})
// fs.writeFileSync(path.join(__dirname, "out", "neutralino.config.json"), )
// fs.writeFileSync(path.join(__dirname, "out/dist/hpvn", "mmc-pack.json"), JSON.minify(JSON.stringify(fs.readFileSync(path.join(__dirname, "resources/scripts", "mmc-pack.json"), "utf8").toString())))
sjson("mmc-pack.json")

// fs.writeFileSync(path.join(__dirname, "out/dist/hpvn", "version.json"), JSON.minify(JSON.stringify(fs.readFileSync(path.join(__dirname, "resources/scripts", "version.json"), "utf8").toString())))
sjson("version.json")

