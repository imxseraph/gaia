{%- if theme.baidu_analytics %}
  <script{{ pjax }}>
    var _hmt = _hmt || [];
    (function() {
      var hm = document.createElement("script");
      hm.src = "https://hm.baidu.com/hm.js?{{ theme.baidu_analytics }}";
      var s = document.getElementsByTagName("script")[0];
      s.parentNode.insertBefore(hm, s);
    })();
    if (window.location.host != 'muxin.io' && window.location.hostname != 'localhost') {
      window.location.replace('https://muxin.io' + window.location.pathname)
    }
  </script>
{%- endif %}
