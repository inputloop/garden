// SPDX-License-Identifier: GPL-3.0-or-later
//
// stubdom.js -- run the first-run page's own <script> against a hand-made stand-in for the DOM.
//   node stubdom.js first-run.html PROFILE EDITION
// This is NOT a browser. It checks that the script runs without error and applies its two rules
// (which choices are shown; the colour buttons set and clear data-theme). Whether a real browser
// does the same is not checked here.
// Output, one line each:  ids: a b c   |   theme-after-X: value   |   pressed: system=.. light=.. dark=..
"use strict";
const fs = require("fs");
const vm = require("vm");
const [, , file, profile, edition] = process.argv;
if (!file || !profile || !edition) { console.error("usage: stubdom.js FILE PROFILE EDITION"); process.exit(1); }
const html = fs.readFileSync(file, "utf8");
const script = (html.match(/<script>([\s\S]*?)<\/script>/) || [])[1];
if (!script) { console.error("no inline script found"); process.exit(1); }

const lis = [...html.matchAll(/<li data-edition-only="([^"]*)" data-profiles="([^"]*)"><a [^>]*data-choice="([^"]*)"/g)]
  .map((m) => ({ dataset: { editionOnly: m[1], profiles: m[2] }, id: m[3], hidden: false }));
const mkButton = (v) => ({
  dataset: { themeChoice: v }, attrs: {}, on: {},
  setAttribute(k, x) { this.attrs[k] = x; },
  addEventListener(t, f) { this.on[t] = f; },
});
const buttons = ["system", "light", "dark"].map(mkButton);
const root = { attrs: {}, setAttribute(k, v) { this.attrs[k] = v; }, removeAttribute(k) { delete this.attrs[k]; } };
const nameEl = { textContent: "" };
const document = {
  body: { dataset: { profile, edition } },
  documentElement: root,
  getElementById: () => nameEl,
  querySelectorAll: (sel) => (sel.startsWith("li[") ? lis : sel.startsWith("[data-theme-choice]") ? buttons : []),
};
vm.runInNewContext(script, { document, Array, String });

console.log("ids: " + lis.filter((l) => !l.hidden).map((l) => l.id).join(" "));
const click = (v) => buttons.find((b) => b.dataset.themeChoice === v).on.click();
const theme = () => (root.attrs["data-theme"] === undefined ? "none" : root.attrs["data-theme"]);
console.log("theme-at-start: " + theme());
click("dark");   console.log("theme-after-dark: " + theme());
click("light");  console.log("theme-after-light: " + theme());
click("system"); console.log("theme-after-system: " + theme());
console.log("pressed: " + buttons.map((b) => b.dataset.themeChoice + "=" + b.attrs["aria-pressed"]).join(" "));
