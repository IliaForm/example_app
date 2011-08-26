// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
      function CheckLength()
      {
      var limit = 140
      var src = document.getElementById('txt')
      var dst = document.getElementById('info')
      dst.innerHTML = limit-src.value.length
      return src.value.length < limit
      }

