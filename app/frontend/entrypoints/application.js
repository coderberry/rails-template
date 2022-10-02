// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "main.scss";
import "@hotwired/turbo-rails";
import TurboReady from "turbo_ready";
import TurboReflex from "turbo_reflex";

// eslint-disable-next-line no-undef
TurboReady.initialize(Turbo.StreamActions);

window.TurboReady = TurboReady;
window.TurboReflex = TurboReflex;

import "./controllers";

// Force all scripts in <head> to reload/reparse after a Turbo visit.
// This ensures that libs which don't work with Turbo Drive...
// (i.e. the body being replaced without reparsing scripts in <head>)
// ...will continue to work.
document.addEventListener("turbo:load", () => {
  document.querySelectorAll("script[type=importmap]").forEach((el) => {
    const parent = el.parentNode;
    el.remove();
    parent.appendChild(el);
  });
});
