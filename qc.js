// Generated by CoffeeScript 1.9.1
(function() {
  var load;

  PhiloGL.unpack();

  load = function() {
    var aspect, btnPlus, btnSub, canvas, frameIndex, frameLast, frameTimes, order, phaseS;
    canvas = document.getElementById('qcCanvas');
    order = 5;
    phaseS = 1.0;
    aspect = canvas.width / canvas.height;
    frameTimes = [0, 0, 0, 0, 0];
    frameLast = 0;
    frameIndex = 0;
    if (PhiloGL.hasWebGL() === !true) {
      alert("Your browser does not support WebGL");
    }
    PhiloGL('qcCanvas', {
      program: [
        {
          id: 'quasicrystals',
          from: 'ids',
          vs: 'shader-vs',
          fs: 'shader-fs'
        }
      ],
      onError: (function(_this) {
        return function(e) {
          return console.log(e);
        };
      })(this),
      onLoad: function(app) {
        var draw, time;
        time = Date.now();
        draw = function() {
          var avgFPS, ft, i, len, p, tmp;
          p = phaseS * ((Date.now() - time) / 20000);

          Media.Image.postProcess({
            width: canvas.width,
            height: canvas.height,
            toScreen: true,
            aspectRatio: 1,
            program: 'quasicrystals',
            uniforms: {
              p: p,
              order: order,
              aspect: aspect
            }
          });
          return Fx.requestAnimationFrame(draw);
        };
        return draw();
      }
    });

  };

  load();

}).call(this);
