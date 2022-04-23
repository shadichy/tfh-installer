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
    }

fs.writeFileSync(path.join(__dirname, "out/resources", "index.html"), htminify(fs.readFileSync(path.join(__dirname, "resources", "index.html"), "utf8").toString()))
fs.writeFileSync(path.join(__dirname, "out/resources", "styles.css"), csso.minify(fs.readFileSync(path.join(__dirname, "resources", "styles.css"), "utf8").toString()).css)
fs.readFile(path.join(__dirname, "resources/js", "main.js"), "utf8",(e,r)=>js(r.replace(/resources\/scripts/g,".")))
fs.readFile(path.join(__dirname, "neutralino.config.json"), "utf8",(e,r)=>{
    let data = JSON.parse(r)
    if (!process.argv.includes("debug") && !process.argv.includes("\"debug\"")) data.modes.window.enableInspector = false
    fs.writeFileSync(path.join(__dirname, "out", "neutralino.config.json"),JSON.minify(JSON.stringify(data)))
})
// fs.writeFileSync(path.join(__dirname, "out", "neutralino.config.json"), )