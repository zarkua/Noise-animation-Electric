// Star Nest by Pablo Román Andrioli

// This content is under the MIT License.

// these constants control the star effect.
// play with them to get different results.
#define iterations 17
#define formuparam 0.53

#define volsteps 24
#define stepsize 0.1

#define zoom   0.010
#define tile   0.850
#define speed  0.010

#define brightness 0.0015
#define darkmatter 0.300
#define distfading 0.730
#define saturation 0.150

// texture coordinates that are set in the vertex shader
uniform mediump vec4 iTime;        // x = секунды
uniform mediump vec4 iResolution;  // xy = пиксели
uniform lowp    sampler2D iChannel0;
// ---------- Electric helpers ----------
#define time (iTime.x * 0.45)
#define tau 6.2831853

mat2 makem2(in float theta){
	float c = cos(theta);
	float s = sin(theta);
	return mat2(c,-s,s,c);
}

// семплим шум из iChannel0 (аналог texture(iChannel0, x*0.01).x)
float noise(in vec2 x){
	return texture2D(iChannel0, x * 0.01).x;
}

// стандартный "ridged" fbm
float fbm(in vec2 p){
	float z  = 2.0;
	float rz = 0.0;
	vec2 bp  = p;
	// int-цикл — дружелюбнее к GLES-компиляторам
	for (int i = 1; i < 6; i++) {
		rz += abs((noise(p) - 0.5) * 2.0) / z;
		z  *= 2.0;
		p  *= 2.0;
	}
	return rz;
}

float dualfbm(in vec2 p){
	// два повернутых fbm, смещаем домен
	vec2 p2    = p * 0.7;
	vec2 basis = vec2(fbm(p2 - time * 1.2), fbm(p2 + time * 1.7));
	basis      = (basis - 0.5) * 0.9;
	p         += basis;

	// окрашивание — fbm в вращаемом пространстве
	return fbm(p * makem2(time * 0.1));
}

float circ(vec2 p){
	float r = length(p) + 1e-8;   // маленькая эпсилон, чтобы избежать log(0)
	r = log(sqrt(r));
	return abs(mod(r * 4.0, tau) - 3.14) * 10.0 + 0.2;
}
// --------------------------------------

// закрутка вокруг центра: угол нарастает к краю
vec2 swirl2(vec2 p, float angle_deg, float radius){
	float r = length(p);
	float k = smoothstep(0.0, radius, r);      // 0 в центре → 1 у края
	float a = radians(angle_deg) * k;
	return makem2(a) * p;
}

// простой domain-warp от двух fbm-каналов
vec2 warp2(vec2 p, float amount, float freq){
	float n1 = fbm(p * freq + vec2( 0.7 * time,  0.3 * time));
	float n2 = fbm(p * (freq*1.7) + vec2(-0.2 * time, -0.6 * time));
	vec2 d = vec2(n1, n2) - 0.5;
	return p + d * amount;
}

// маска круглого кольца
float ringMask(vec2 p, float r, float width){
	float d = abs(length(p) - r);
	// мягкие края кольца
	return 1.0 - smoothstep(width, width*1.2, d);
}

void main(){
	// координаты экрана → центрируем и выравниваем аспект
	vec2 p = gl_FragCoord.xy / iResolution.xy - 0.5;
	p.x *= iResolution.x / iResolution.y;
	p *= 12.0;

	float rz = dualfbm(p);

	// кольца
	vec2 pr = p / exp(mod(time * 4.0, 3.14159));
	rz *= pow(abs(0.1 - circ(pr)), 0.9);

	// финальный цвет
	vec3 col = vec3(0.4, 0.1, 0.2) / max(rz, 1e-4);
	col = pow(abs(col), vec3(0.99));

	gl_FragColor = vec4(col, 1.0);
}