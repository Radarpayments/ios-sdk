function _postMessage(op, data) {
  window.webkit.messageHandlers.interOp.postMessage({ op, data });
}

_postMessage('ready', {});

window.__showBankLogo = function (logo) {
  view.innerHTML = `<img src=${logo} />`;
};
