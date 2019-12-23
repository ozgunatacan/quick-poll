// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

const el = document.getElementById('add_option');
el.onclick = function(e){
  e.preventDefault();
  const el = document.getElementById('add_option');
  const time = new Date().getTime();
  const template = el.getAttribute('data-template');
  let uniq_template = template.replace(/\[0\]/g, `[${time}]`);
  uniq_template = uniq_template.replace(/_0_/g, `_${time}_`);
  this.insertAdjacentHTML('beforebegin', uniq_template);
};
