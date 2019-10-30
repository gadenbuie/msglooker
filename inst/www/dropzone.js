$(document).ready(function() {
  const fileInputSelector =
    '.form-group.shiny-input-container ' +
    '.control-label[for="file"] + .input-group';

  const fileInputs = document.querySelectorAll(fileInputSelector);
  fileInputs.forEach(el => {
    el.innerHTML += '<div class="dropzone"></div>';
  });
});
