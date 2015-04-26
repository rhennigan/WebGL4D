gl = undefined
shaders =
  fragReady: false
  vertReady: false
  frag: undefined
  vert: undefined
shaderProgram = undefined

mvMatrix = mat4.create()
pMatrix = mat4.create()
tVector = vec4.create()
pVector = vec4.create()
lightDirectionVector = vec4.create()

r1Float = 0.0
r2Float = 0.0
r3Float = 0.0
r4Float = 0.0
r5Float = 0.0
r6Float = 0.0

vertexPositionBuffer = undefined
vertexColorBuffer = undefined
vertexNormalBuffer = undefined
vertexIndexBuffer = undefined
vertexLinePositionBuffer = undefined
vertexLineIndexBuffer = undefined

meshBool = true

initGL = (canvas) ->
  try
    gl = canvas.getContext "experimental-webgl"
    gl.viewportWidth = canvas.width
    gl.viewportHeight = canvas.height
  catch e
    alert "initGL error: #{e}"
  if not gl then alert "Could not initialize WebGL"

loadShader = (path, type) ->
  request = new XMLHttpRequest()
  request.open 'GET', path, true
  request.onreadystatechange = ->
    if request.readyState is 4 and request.status is 200
      sourceString = request.responseText
      if type is 'frag'
        shaders.frag = gl.createShader gl.FRAGMENT_SHADER
        gl.shaderSource shaders.frag, sourceString
        gl.compileShader shaders.frag
        shaders.fragReady = true
      else if type is 'vert'
        shaders.vert = gl.createShader gl.VERTEX_SHADER
        gl.shaderSource shaders.vert, sourceString
        gl.compileShader shaders.vert
        shaders.vertReady = true
      else
        alert "unknown shader type: #{type}"
  request.send()

initShaders = ->
  if not shaders.fragReady
    alert "fragment shader script is not loaded"
  else if not shaders.vertReady
    alert "vertex shader script is not loaded"
  else
    shaderProgram = gl.createProgram()
    gl.attachShader shaderProgram, shaders.vert
    gl.attachShader shaderProgram, shaders.frag
    gl.linkProgram shaderProgram
    if not gl.getProgramParameter shaderProgram, gl.LINK_STATUS
      console.log shaders
      alert "failed to initialize shaders"
    else
      gl.useProgram shaderProgram
      shaderProgram.vertexPositionAttribute = gl.getAttribLocation shaderProgram, "aVertexPosition"
      shaderProgram.vertexColorAttribute = gl.getAttribLocation shaderProgram, "aVertexColor"
      shaderProgram.vertexNormalAttribute = gl.getAttribLocation shaderProgram, "aVertexNormal"
      gl.enableVertexAttribArray shaderProgram.vertexPositionAttribute
      gl.enableVertexAttribArray shaderProgram.vertexColorAttribute
      gl.enableVertexAttribArray shaderProgram.vertexNormalAttribute
      shaderProgram.pMatrixUniform = gl.getUniformLocation shaderProgram, "uPMatrix"
      shaderProgram.mvMatrixUniform = gl.getUniformLocation shaderProgram, "uMVMatrix"
      shaderProgram.tVectorUniform = gl.getUniformLocation shaderProgram, "uTVector"
      shaderProgram.pVectorUniform = gl.getUniformLocation shaderProgram, "uPVector"
      shaderProgram.lightDirectionUniform = gl.getUniformLocation shaderProgram, "uLightDirection"
      shaderProgram.r1FloatUniform = gl.getUniformLocation shaderProgram, "uR1Float"
      shaderProgram.r2FloatUniform = gl.getUniformLocation shaderProgram, "uR2Float"
      shaderProgram.r3FloatUniform = gl.getUniformLocation shaderProgram, "uR3Float"
      shaderProgram.r4FloatUniform = gl.getUniformLocation shaderProgram, "uR4Float"
      shaderProgram.r5FloatUniform = gl.getUniformLocation shaderProgram, "uR5Float"
      shaderProgram.r6FloatUniform = gl.getUniformLocation shaderProgram, "uR6Float"
      shaderProgram.meshBoolUniform = gl.getUniformLocation shaderProgram, "uMeshBool"

setMatrixUniforms = ->
  gl.uniformMatrix4fv shaderProgram.pMatrixUniform, false, pMatrix
  gl.uniformMatrix4fv shaderProgram.mvMatrixUniform, false, mvMatrix
  gl.uniform4fv shaderProgram.tVectorUniform, tVector
  gl.uniform4fv shaderProgram.pVectorUniform, pVector
  gl.uniform4fv shaderProgram.lightDirectionUniform, lightDirectionVector
  gl.uniform1f shaderProgram.r1FloatUniform, r1Float
  gl.uniform1f shaderProgram.r2FloatUniform, r2Float
  gl.uniform1f shaderProgram.r3FloatUniform, r3Float
  gl.uniform1f shaderProgram.r4FloatUniform, r4Float
  gl.uniform1f shaderProgram.r5FloatUniform, r5Float
  gl.uniform1f shaderProgram.r6FloatUniform, r6Float
  gl.uniform1i shaderProgram.meshBoolUniform, meshBool

initBuffers = ->
# vertex positions
  vertexPositionBuffer = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, vertexPositionBuffer
  vertices =
    [
      -1, -1, -1, 1,
      -1, 1, -1, 1,
      -1, 1, 1, 1,
      -1, -1, 1, 1,
      -1, -1, -1, -1,
      -1, -1, 1, -1,
      -1, 1, 1, -1,
      -1, 1, -1, -1,
      -1, -1, 1, -1,
      -1, -1, 1, 1,
      -1, 1, 1, 1,
      -1, 1, 1, -1,
      -1, -1, -1, -1,
      -1, 1, -1, -1,
      -1, 1, -1, 1,
      -1, -1, -1, 1,
      -1, 1, -1, -1,
      -1, 1, 1, -1,
      -1, 1, 1, 1,
      -1, 1, -1, 1,
      -1, -1, -1, -1,
      -1, -1, -1, 1,
      -1, -1, 1, 1,
      -1, -1, 1, -1,
      -1, -1, -1, 1,
      1, -1, -1, 1,
      1, -1, 1, 1,
      -1, -1, 1, 1,
      -1, -1, -1, -1,
      -1, -1, 1, -1,
      1, -1, 1, -1,
      1, -1, -1, -1,
      -1, -1, 1, -1,
      -1, -1, 1, 1,
      1, -1, 1, 1,
      1, -1, 1, -1,
      -1, -1, -1, -1,
      1, -1, -1, -1,
      1, -1, -1, 1,
      -1, -1, -1, 1,
      1, -1, -1, -1,
      1, -1, 1, -1,
      1, -1, 1, 1,
      1, -1, -1, 1,
      -1, -1, -1, -1,
      -1, -1, -1, 1,
      -1, -1, 1, 1,
      -1, -1, 1, -1,
      -1, -1, -1, 1,
      1, -1, -1, 1,
      1, 1, -1, 1,
      -1, 1, -1, 1,
      -1, -1, -1, -1,
      -1, 1, -1, -1,
      1, 1, -1, -1,
      1, -1, -1, -1,
      -1, 1, -1, -1,
      -1, 1, -1, 1,
      1, 1, -1, 1,
      1, 1, -1, -1,
      -1, -1, -1, -1,
      1, -1, -1, -1,
      1, -1, -1, 1,
      -1, -1, -1, 1,
      1, -1, -1, -1,
      1, 1, -1, -1,
      1, 1, -1, 1,
      1, -1, -1, 1,
      -1, -1, -1, -1,
      -1, -1, -1, 1,
      -1, 1, -1, 1,
      -1, 1, -1, -1,
      -1, -1, 1, -1,
      1, -1, 1, -1,
      1, 1, 1, -1,
      -1, 1, 1, -1,
      -1, -1, -1, -1,
      -1, 1, -1, -1,
      1, 1, -1, -1,
      1, -1, -1, -1,
      -1, 1, -1, -1,
      -1, 1, 1, -1,
      1, 1, 1, -1,
      1, 1, -1, -1,
      -1, -1, -1, -1,
      1, -1, -1, -1,
      1, -1, 1, -1,
      -1, -1, 1, -1,
      1, -1, -1, -1,
      1, 1, -1, -1,
      1, 1, 1, -1,
      1, -1, 1, -1,
      -1, -1, -1, -1,
      -1, -1, 1, -1,
      -1, 1, 1, -1,
      -1, 1, -1, -1,
      1, -1, -1, 1,
      1, 1, -1, 1,
      1, 1, 1, 1,
      1, -1, 1, 1,
      1, -1, -1, -1,
      1, -1, 1, -1,
      1, 1, 1, -1,
      1, 1, -1, -1,
      1, -1, 1, -1,
      1, -1, 1, 1,
      1, 1, 1, 1,
      1, 1, 1, -1,
      1, -1, -1, -1,
      1, 1, -1, -1,
      1, 1, -1, 1,
      1, -1, -1, 1,
      1, 1, -1, -1,
      1, 1, 1, -1,
      1, 1, 1, 1,
      1, 1, -1, 1,
      1, -1, -1, -1,
      1, -1, -1, 1,
      1, -1, 1, 1,
      1, -1, 1, -1,
      -1, 1, -1, 1,
      1, 1, -1, 1,
      1, 1, 1, 1,
      -1, 1, 1, 1,
      -1, 1, -1, -1,
      -1, 1, 1, -1,
      1, 1, 1, -1,
      1, 1, -1, -1,
      -1, 1, 1, -1,
      -1, 1, 1, 1,
      1, 1, 1, 1,
      1, 1, 1, -1,
      -1, 1, -1, -1,
      1, 1, -1, -1,
      1, 1, -1, 1,
      -1, 1, -1, 1,
      1, 1, -1, -1,
      1, 1, 1, -1,
      1, 1, 1, 1,
      1, 1, -1, 1,
      -1, 1, -1, -1,
      -1, 1, -1, 1,
      -1, 1, 1, 1,
      -1, 1, 1, -1,
      -1, -1, 1, 1,
      1, -1, 1, 1,
      1, 1, 1, 1,
      -1, 1, 1, 1,
      -1, -1, 1, -1,
      -1, 1, 1, -1,
      1, 1, 1, -1,
      1, -1, 1, -1,
      -1, 1, 1, -1,
      -1, 1, 1, 1,
      1, 1, 1, 1,
      1, 1, 1, -1,
      -1, -1, 1, -1,
      1, -1, 1, -1,
      1, -1, 1, 1,
      -1, -1, 1, 1,
      1, -1, 1, -1,
      1, 1, 1, -1,
      1, 1, 1, 1,
      1, -1, 1, 1,
      -1, -1, 1, -1,
      -1, -1, 1, 1,
      -1, 1, 1, 1,
      -1, 1, 1, -1,
      -1, -1, 1, 1,
      1, -1, 1, 1,
      1, 1, 1, 1,
      -1, 1, 1, 1,
      -1, -1, -1, 1,
      -1, 1, -1, 1,
      1, 1, -1, 1,
      1, -1, -1, 1,
      -1, 1, -1, 1,
      -1, 1, 1, 1,
      1, 1, 1, 1,
      1, 1, -1, 1,
      -1, -1, -1, 1,
      1, -1, -1, 1,
      1, -1, 1, 1,
      -1, -1, 1, 1,
      1, -1, -1, 1,
      1, 1, -1, 1,
      1, 1, 1, 1,
      1, -1, 1, 1,
      -1, -1, -1, 1,
      -1, -1, 1, 1,
      -1, 1, 1, 1,
      -1, 1, -1, 1
    ]
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW
  vertexPositionBuffer.itemSize = 4
  vertexPositionBuffer.numItems = 192

  # triangle vertex colors
  vertexColorBuffer = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, vertexColorBuffer
  unpackedColors =
    [
      0.6682, 0.5, 0.125, 0.5,
      0.6682, 0.5, 0.125, 0.5,
      0.6682, 0.5, 0.125, 0.5,
      0.6682, 0.5, 0.125, 0.5,
      0.6682, 1.0, 0.125, 0.5,
      0.6682, 1.0, 0.125, 0.5,
      0.6682, 1.0, 0.125, 0.5,
      0.6682, 1.0, 0.125, 0.5,
      0.1682, 1.0, 0.125, 0.5,
      0.1682, 1.0, 0.125, 0.5,
      0.1682, 1.0, 0.125, 0.5,
      0.1682, 1.0, 0.125, 0.5,
      0.6682, 0.625, 0.25, 0.5,
      0.6682, 0.625, 0.25, 0.5,
      0.6682, 0.625, 0.25, 0.5,
      0.6682, 0.625, 0.25, 0.5,
      0.6682, 0.5, 0.625, 0.5,
      0.6682, 0.5, 0.625, 0.5,
      0.6682, 0.5, 0.625, 0.5,
      0.6682, 0.5, 0.625, 0.5,
      0.1682, 0.5, 0.625, 0.5,
      0.1682, 0.5, 0.625, 0.5,
      0.1682, 0.5, 0.625, 0.5,
      0.1682, 0.5, 0.625, 0.5,
      0.5072, 0.5, 0.405, 0.5,
      0.5072, 0.5, 0.405, 0.5,
      0.5072, 0.5, 0.405, 0.5,
      0.5072, 0.5, 0.405, 0.5,
      0.5072, 1.0, 0.405, 0.5,
      0.5072, 1.0, 0.405, 0.5,
      0.5072, 1.0, 0.405, 0.5,
      0.5072, 1.0, 0.405, 0.5,
      0.0072, 1.0, 0.405, 0.5,
      0.0072, 1.0, 0.405, 0.5,
      0.0072, 1.0, 0.405, 0.5,
      0.0072, 1.0, 0.405, 0.5,
      0.5072, 0.625, 0.53, 0.5,
      0.5072, 0.625, 0.53, 0.5,
      0.5072, 0.625, 0.53, 0.5,
      0.5072, 0.625, 0.53, 0.5,
      0.5072, 0.5, 0.905, 0.5,
      0.5072, 0.5, 0.905, 0.5,
      0.5072, 0.5, 0.905, 0.5,
      0.5072, 0.5, 0.905, 0.5,
      0.0072, 0.5, 0.905, 0.5,
      0.0072, 0.5, 0.905, 0.5,
      0.0072, 0.5, 0.905, 0.5,
      0.0072, 0.5, 0.905, 0.5,
      0.5, 0.5, 0.28125, 0.5,
      0.5, 0.5, 0.28125, 0.5,
      0.5, 0.5, 0.28125, 0.5,
      0.5, 0.5, 0.28125, 0.5,
      0.5, 1.0, 0.28125, 0.5,
      0.5, 1.0, 0.28125, 0.5,
      0.5, 1.0, 0.28125, 0.5,
      0.5, 1.0, 0.28125, 0.5,
      0.0, 1.0, 0.28125, 0.5,
      0.0, 1.0, 0.28125, 0.5,
      0.0, 1.0, 0.28125, 0.5,
      0.0, 1.0, 0.28125, 0.5,
      0.5, 0.625, 0.40625, 0.5,
      0.5, 0.625, 0.40625, 0.5,
      0.5, 0.625, 0.40625, 0.5,
      0.5, 0.625, 0.40625, 0.5,
      0.5, 0.5, 0.78125, 0.5,
      0.5, 0.5, 0.78125, 0.5,
      0.5, 0.5, 0.78125, 0.5,
      0.5, 0.5, 0.78125, 0.5,
      0.0, 0.5, 0.78125, 0.5,
      0.0, 0.5, 0.78125, 0.5,
      0.0, 0.5, 0.78125, 0.5,
      0.0, 0.5, 0.78125, 0.5,
      0.625, 0.5, 0.18, 0.5,
      0.625, 0.5, 0.18, 0.5,
      0.625, 0.5, 0.18, 0.5,
      0.625, 0.5, 0.18, 0.5,
      0.625, 1.0, 0.18, 0.5,
      0.625, 1.0, 0.18, 0.5,
      0.625, 1.0, 0.18, 0.5,
      0.625, 1.0, 0.18, 0.5,
      0.125, 1.0, 0.18, 0.5,
      0.125, 1.0, 0.18, 0.5,
      0.125, 1.0, 0.18, 0.5,
      0.125, 1.0, 0.18, 0.5,
      0.625, 0.625, 0.305, 0.5,
      0.625, 0.625, 0.305, 0.5,
      0.625, 0.625, 0.305, 0.5,
      0.625, 0.625, 0.305, 0.5,
      0.625, 0.5, 0.68, 0.5,
      0.625, 0.5, 0.68, 0.5,
      0.625, 0.5, 0.68, 0.5,
      0.625, 0.5, 0.68, 0.5,
      0.125, 0.5, 0.68, 0.5,
      0.125, 0.5, 0.68, 0.5,
      0.125, 0.5, 0.68, 0.5,
      0.125, 0.5, 0.68, 0.5,
      0.72445, 0.125, 0.245, 0.5,
      0.72445, 0.125, 0.245, 0.5,
      0.72445, 0.125, 0.245, 0.5,
      0.72445, 0.125, 0.245, 0.5,
      0.72445, 0.625, 0.245, 0.5,
      0.72445, 0.625, 0.245, 0.5,
      0.72445, 0.625, 0.245, 0.5,
      0.72445, 0.625, 0.245, 0.5,
      0.22445, 0.625, 0.245, 0.5,
      0.22445, 0.625, 0.245, 0.5,
      0.22445, 0.625, 0.245, 0.5,
      0.22445, 0.625, 0.245, 0.5,
      0.72445, 0.25, 0.37, 0.5,
      0.72445, 0.25, 0.37, 0.5,
      0.72445, 0.25, 0.37, 0.5,
      0.72445, 0.25, 0.37, 0.5,
      0.72445, 0.125, 0.745, 0.5,
      0.72445, 0.125, 0.745, 0.5,
      0.72445, 0.125, 0.745, 0.5,
      0.72445, 0.125, 0.745, 0.5,
      0.22445, 0.125, 0.745, 0.5,
      0.22445, 0.125, 0.745, 0.5,
      0.22445, 0.125, 0.745, 0.5,
      0.22445, 0.125, 0.745, 0.5,
      0.51445, 0.5, 0.18, 0.5,
      0.51445, 0.5, 0.18, 0.5,
      0.51445, 0.5, 0.18, 0.5,
      0.51445, 0.5, 0.18, 0.5,
      0.51445, 1.0, 0.18, 0.5,
      0.51445, 1.0, 0.18, 0.5,
      0.51445, 1.0, 0.18, 0.5,
      0.51445, 1.0, 0.18, 0.5,
      0.01445, 1.0, 0.18, 0.5,
      0.01445, 1.0, 0.18, 0.5,
      0.01445, 1.0, 0.18, 0.5,
      0.01445, 1.0, 0.18, 0.5,
      0.51445, 0.625, 0.305, 0.5,
      0.51445, 0.625, 0.305, 0.5,
      0.51445, 0.625, 0.305, 0.5,
      0.51445, 0.625, 0.305, 0.5,
      0.51445, 0.5, 0.68, 0.5,
      0.51445, 0.5, 0.68, 0.5,
      0.51445, 0.5, 0.68, 0.5,
      0.51445, 0.5, 0.68, 0.5,
      0.01445, 0.5, 0.68, 0.5,
      0.01445, 0.5, 0.68, 0.5,
      0.01445, 0.5, 0.68, 0.5,
      0.01445, 0.5, 0.68, 0.5,
      0.905, 0.5, 0.28125, 0.5,
      0.905, 0.5, 0.28125, 0.5,
      0.905, 0.5, 0.28125, 0.5,
      0.905, 0.5, 0.28125, 0.5,
      0.905, 1.0, 0.28125, 0.5,
      0.905, 1.0, 0.28125, 0.5,
      0.905, 1.0, 0.28125, 0.5,
      0.905, 1.0, 0.28125, 0.5,
      0.405, 1.0, 0.28125, 0.5,
      0.405, 1.0, 0.28125, 0.5,
      0.405, 1.0, 0.28125, 0.5,
      0.405, 1.0, 0.28125, 0.5,
      0.905, 0.625, 0.40625, 0.5,
      0.905, 0.625, 0.40625, 0.5,
      0.905, 0.625, 0.40625, 0.5,
      0.905, 0.625, 0.40625, 0.5,
      0.905, 0.5, 0.78125, 0.5,
      0.905, 0.5, 0.78125, 0.5,
      0.905, 0.5, 0.78125, 0.5,
      0.905, 0.5, 0.78125, 0.5,
      0.405, 0.5, 0.78125, 0.5,
      0.405, 0.5, 0.78125, 0.5,
      0.405, 0.5, 0.78125, 0.5,
      0.405, 0.5, 0.78125, 0.5,
      0.50605, 0.245, 0.28125, 0.5,
      0.50605, 0.245, 0.28125, 0.5,
      0.50605, 0.245, 0.28125, 0.5,
      0.50605, 0.245, 0.28125, 0.5,
      0.50605, 0.745, 0.28125, 0.5,
      0.50605, 0.745, 0.28125, 0.5,
      0.50605, 0.745, 0.28125, 0.5,
      0.50605, 0.745, 0.28125, 0.5,
      0.00605, 0.745, 0.28125, 0.5,
      0.00605, 0.745, 0.28125, 0.5,
      0.00605, 0.745, 0.28125, 0.5,
      0.00605, 0.745, 0.28125, 0.5,
      0.50605, 0.37, 0.40625, 0.5,
      0.50605, 0.37, 0.40625, 0.5,
      0.50605, 0.37, 0.40625, 0.5,
      0.50605, 0.37, 0.40625, 0.5,
      0.50605, 0.245, 0.78125, 0.5,
      0.50605, 0.245, 0.78125, 0.5,
      0.50605, 0.245, 0.78125, 0.5,
      0.50605, 0.245, 0.78125, 0.5,
      0.00605, 0.245, 0.78125, 0.5,
      0.00605, 0.245, 0.78125, 0.5,
      0.00605, 0.245, 0.78125, 0.5,
      0.00605, 0.245, 0.78125, 0.5
    ]
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(unpackedColors), gl.STATIC_DRAW
  vertexColorBuffer.itemSize = 4
  vertexColorBuffer.numItems = 192

  # vertex normals
  vertexNormalBuffer = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, vertexNormalBuffer
  normals =
    [
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      -1, 0, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, -1, 0, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, -1, 0,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      0, 0, 0, -1,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 1, 0,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1,
      0, 0, 0, 1
    ]
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(normals), gl.STATIC_DRAW
  vertexNormalBuffer.itemSize = 4
  vertexNormalBuffer.numItems = 192

  # indices for triangles
  vertexIndexBuffer = gl.createBuffer()
  gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, vertexIndexBuffer
  vertexIndices =
    [
      0, 1, 2, 0, 3, 2, 4, 5, 6, 4, 7, 6, 8, 9, 10, 8, 11, 10, 12, 13, 14, 12, 15, 14, 16, 17, 18, 16, 19, 18, 20, 21,
      22, 20, 23, 22, 24, 25, 26, 24, 27, 26, 28, 29, 30, 28, 31, 30, 32, 33, 34, 32, 35, 34, 36, 37, 38, 36, 39, 38,
      40, 41, 42, 40, 43, 42, 44, 45, 46, 44, 47, 46, 48, 49, 50, 48, 51, 50, 52, 53, 54, 52, 55, 54, 56, 57, 58, 56,
      59, 58, 60, 61, 62, 60, 63, 62, 64, 65, 66, 64, 67, 66, 68, 69, 70, 68, 71, 70, 72, 73, 74, 72, 75, 74, 76, 77,
      78, 76, 79, 78, 80, 81, 82, 80, 83, 82, 84, 85, 86, 84, 87, 86, 88, 89, 90, 88, 91, 90, 92, 93, 94, 92, 95, 94,
      96, 97, 98, 96, 99, 98, 100, 101, 102, 100, 103, 102, 104, 105, 106, 104, 107, 106, 108, 109, 110, 108, 111, 110,
      112, 113, 114, 112, 115, 114, 116, 117, 118, 116, 119, 118, 120, 121, 122, 120, 123, 122, 124, 125, 126, 124, 127,
      126, 128, 129, 130, 128, 131, 130, 132, 133, 134, 132, 135, 134, 136, 137, 138, 136, 139, 138, 140, 141, 142, 140,
      143, 142, 144, 145, 146, 144, 147, 146, 148, 149, 150, 148, 151, 150, 152, 153, 154, 152, 155, 154, 156, 157, 158,
      156, 159, 158, 160, 161, 162, 160, 163, 162, 164, 165, 166, 164, 167, 166, 168, 169, 170, 168, 171, 170, 172, 173,
      174, 172, 175, 174, 176, 177, 178, 176, 179, 178, 180, 181, 182, 180, 183, 182, 184, 185, 186, 184, 187, 186, 188,
      189, 190, 188, 191, 190
    ]
  gl.bufferData gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(vertexIndices), gl.STATIC_DRAW
  vertexIndexBuffer.itemSize = 1
  vertexIndexBuffer.numItems = 288

  # line vertices
  vertexLinePositionBuffer = gl.createBuffer()
  gl.bindBuffer gl.ARRAY_BUFFER, vertexLinePositionBuffer
  lineVertices =
    [
      -1, -1, -1, -1,
      -1, -1, -1, 1,
      -1, -1, 1, -1,
      -1, -1, 1, 1,
      -1, 1, -1, -1,
      -1, 1, -1, 1,
      -1, 1, 1, -1,
      -1, 1, 1, 1,
      1, -1, -1, -1,
      1, -1, -1, 1,
      1, -1, 1, -1,
      1, -1, 1, 1,
      1, 1, -1, -1,
      1, 1, -1, 1,
      1, 1, 1, -1,
      1, 1, 1, 1
    ]
  gl.bufferData gl.ARRAY_BUFFER, new Float32Array(lineVertices), gl.STATIC_DRAW
  vertexLinePositionBuffer.itemSize = 4
  vertexLinePositionBuffer.numItems = 16

  # indices for lines
  vertexLineIndexBuffer = gl.createBuffer()
  gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, vertexLineIndexBuffer
  vertexLineIndices =
    [
      0, 1, 0, 2, 0, 4, 0, 8, 1, 0, 1, 3, 1, 5, 1, 9, 2, 0, 2, 3, 2, 6, 2, 10, 3, 1, 3, 2, 3, 7, 3, 11, 4, 0, 4, 5, 4,
      6, 4, 12, 5, 1, 5, 4, 5, 7, 5, 13, 6, 2, 6, 4, 6, 7, 6, 14, 7, 3, 7, 5, 7, 6, 7, 15, 8, 0, 8, 9, 8, 10, 8, 12, 9,
      1, 9, 8, 9, 11, 9, 13, 10, 2, 10, 8, 10, 11, 10, 14, 11, 3, 11, 9, 11, 10, 11, 15, 12, 4, 12, 8, 12, 13, 12, 14,
      13, 5, 13, 9, 13, 12, 13, 15, 14, 6, 14, 10, 14, 12, 14, 15, 15, 7, 15, 11, 15, 13, 15, 14
    ]
  gl.bufferData gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(vertexLineIndices), gl.STATIC_DRAW
  vertexLineIndexBuffer.itemSize = 1
  vertexLineIndexBuffer.numItems = 128

# TODO: do square stuff here!

drawTesseract = (x, y, z, w) ->
  vec4.set tVector, x, y, z, w

  # setup colors
  gl.bindBuffer gl.ARRAY_BUFFER, vertexColorBuffer
  gl.vertexAttribPointer(shaderProgram.vertexColorAttribute,
      vertexColorBuffer.itemSize, gl.FLOAT, false, 0, 0)

  # setup normals
  gl.bindBuffer gl.ARRAY_BUFFER, vertexNormalBuffer
  gl.vertexAttribPointer(shaderProgram.vertexNormalAttribute,
      vertexNormalBuffer.itemSize, gl.FLOAT, false, 0, 0)

  # setup line positions
  gl.bindBuffer gl.ARRAY_BUFFER, vertexLinePositionBuffer
  gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute,
      vertexLinePositionBuffer.itemSize, gl.FLOAT, false, 0, 0)

  # setup line index
  gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, vertexLineIndexBuffer
  setMatrixUniforms()
  gl.uniform1i shaderProgram.meshBoolUniform, true
  gl.drawElements gl.LINES, vertexLineIndexBuffer.numItems, gl.UNSIGNED_SHORT, 0

  # setup positions
  gl.bindBuffer gl.ARRAY_BUFFER, vertexPositionBuffer
  gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute,
      vertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0)

  # setup triangle index
  gl.bindBuffer gl.ELEMENT_ARRAY_BUFFER, vertexIndexBuffer
  setMatrixUniforms()
  gl.uniform1i shaderProgram.meshBoolUniform, false
  gl.drawElements gl.TRIANGLES, vertexIndexBuffer.numItems, gl.UNSIGNED_SHORT, 0

drawScene = (px, py, pz, pw) ->
# get scene ready
  gl.viewport 0, 0, gl.viewportWidth, gl.viewportHeight
  gl.clear (gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
  mat4.perspective pMatrix, 45, gl.viewportWidth / gl.viewportHeight, 0.001, 100.0
  mat4.identity mvMatrix
  #mat4.translate mvMatrix, mvMatrix, (new Float32Array([0, 0, 0]))
  #mat4.rotate(mvMatrix, mvMatrix, 1.0, new Float32Array([1, 1, 1]))

  vec4.set pVector, px, py, pz, pw
  vec4.set lightDirectionVector, 0.5, 0.5, -1, -1
  vec4.normalize(lightDirectionVector, lightDirectionVector)

  d = 3
  n = 3
  for x in [-n..n]
    for y in [-n, n]
      for z in [-n, n]
        for w in [-n, n]
          drawTesseract(d * x, d * y, d * z, d * w)

  for x in [-n, n]
    for y in [-n..n]
      for z in [-n, n]
        for w in [-n, n]
          drawTesseract(d * x, d * y, d * z, d * w)

  for x in [-n, n]
    for y in [-n, n]
      for z in [-n..n]
        for w in [-n, n]
          drawTesseract(d * x, d * y, d * z, d * w)

  for x in [-n, n]
    for y in [-n, n]
      for z in [-n, n]
        for w in [-n..n]
          drawTesseract(d * x, d * y, d * z, d * w)


#  d = 3
#  for x in [-1..1]
#    for y in [-1..1]
#      for z in [-1..1]
#        for w in [-1..1]
#          if not (x == 0 and y == 0 and z == 0 and w == 0)
#            drawTesseract(d * x, d * y, d * z, d * w)

center = {x: 0.0, y: 0.0}
mouseDragging = false
dragOffset = {x: 0, y: 0}
dragStart = {x: 0, y: 0}
dragCurrent = {x: 0, y: 0}
currentDirection =
  forward: 0
  right: 0
  up: 0
  charm: 0

moveSpeed = 0.005
px = 0
py = 0
pz = 25
pw = -50

rotationSpeed = 4.0 * Math.PI
window.rotateMode =
  x: 1
  y: 4

stepRotationMode = (dir) ->
  center = {x: 0.0, y: 0.0}
  switch dir
    when 0 then rotateMode.x = (rotateMode.x + 1) % 6
    when 1 then rotateMode.y = (rotateMode.y + 1) % 6
  console.log("rotation mode: #{rotateMode}")

modalRotate = (x0, y0) ->
  x = rotationSpeed * x0
  y = rotationSpeed * y0
  switch rotateMode.x
    when 0 then r1Float = x
    when 1 then r2Float = x
    when 2 then r3Float = x
    when 3 then r4Float = x
    when 4 then r5Float = x
    when 5 then r6Float = x
  switch rotateMode.y
    when 0 then r1Float = y
    when 1 then r2Float = y
    when 2 then r3Float = y
    when 3 then r4Float = y
    when 4 then r5Float = y
    when 5 then r6Float = y

window.auto = true

randAngle = -> Math.random() - 0.5
rSpeeds = (2.0*randAngle() for i in [1..6])
updateSpeeds = ->
  for i in [0..5]
    rSpeeds[i] += randAngle() / 100

lastTime = 0
animate = ->
  timeNow = (new Date).getTime()
  if lastTime != 0
    elapsed = timeNow - lastTime
    pz -= currentDirection.forward * moveSpeed * elapsed
    px += currentDirection.right * moveSpeed * elapsed
    py += currentDirection.up * moveSpeed * elapsed
    pw += currentDirection.charm * moveSpeed * elapsed
    pw = Math.max(0, pw)
    if auto
      updateSpeeds()
      r1Float += rSpeeds[0] * elapsed * rotationSpeed / 50000
      r2Float += rSpeeds[1] * elapsed * rotationSpeed / 50000
      r3Float += rSpeeds[2] * elapsed * rotationSpeed / 50000
      r4Float += rSpeeds[3] * elapsed * rotationSpeed / 50000
      r5Float += rSpeeds[4] * elapsed * rotationSpeed / 50000
      r6Float += rSpeeds[5] * elapsed * rotationSpeed / 50000
  lastTime = timeNow

tick = ->
  requestAnimFrame tick
  drawScene(px, py, pz, pw)
  animate()
# console.log(rFloat)

window.testing = ->
  canvas = document.getElementById 'canvas'
  canvas.width = window.innerWidth-20
  canvas.height = window.innerHeight-5
  getMousePos = (event) =>
    rect = canvas.getBoundingClientRect()
    x: event.clientX - rect.left
    y: event.clientY - rect.top

  canvas.addEventListener "mousedown", (e) =>
    dragStart = dragCurrent = getMousePos(e)
    mouseDragging = true

  canvas.addEventListener "mousemove", (e) =>
    if mouseDragging
      dragCurrent = getMousePos(e)
      turnRight = (dragStart.x - dragCurrent.x) / canvas.width
      turnUp = (dragStart.y - dragCurrent.y) / canvas.height
      modalRotate(turnRight, turnUp)
  #      r3Float = center.x + turnRight
  #      r4Float = center.y + turnUp

  canvas.addEventListener "mouseup", (e) =>
    mouseDragging = false
    center.x = center.x + (dragStart.x - dragCurrent.x) / canvas.width
    center.y = center.y + (dragStart.y - dragCurrent.y) / canvas.height
    dragStart = dragCurrent = {x: 0.0, y: 0.0}

  handleKeyPress = (event) ->
    code = event.keyCode
    console.log(code)
    switch code
      when 87 then currentDirection.forward = 1
      when 65 then currentDirection.right = -1
      when 68 then currentDirection.right = 1
      when 83 then currentDirection.forward = -1
      when 69 then currentDirection.up = 1
      when 81 then currentDirection.up = -1
      when 82 then currentDirection.charm = 1
      when 70 then currentDirection.charm = -1
  #      when 81 then stepRotationMode(0)
  #      when 69 then stepRotationMode(1)

  handleKeyRelease = (event) ->
    code = event.keyCode
    switch code
      when 87 then currentDirection.forward = 0
      when 65 then currentDirection.right = 0
      when 68 then currentDirection.right = 0
      when 83 then currentDirection.forward = 0
      when 69 then currentDirection.up = 0
      when 81 then currentDirection.up = 0
      when 82 then currentDirection.charm = 0
      when 70 then currentDirection.charm = 0

    console.log("position: (#{px}, #{py}, #{pz}, #{pw})")

  window.addEventListener "keydown", handleKeyPress, false

  window.addEventListener "keyup", handleKeyRelease, false

  initGL canvas
  loadShader 'shaders/fragment.glsl', 'frag'
  loadShader 'shaders/vertex.glsl', 'vert'

  waitForShaders = (continuation) ->
    if not (shaders.fragReady and shaders.vertReady)
      setTimeout (-> waitForShaders continuation), 10
    else
      continuation()

  finishGLInit = ->
    initShaders()
    initBuffers()
    gl.clearColor 0.1, 0.1, 0.1, 1 # default background color: black
    gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
    gl.enable(gl.BLEND)
    gl.disable(gl.DEPTH_TEST)
    gl.enable(gl.DEPTH_TEST)
    tick()

  waitForShaders finishGLInit
