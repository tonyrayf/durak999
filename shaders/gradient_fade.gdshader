shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

uniform sampler2D albedo_texture : source_color;
uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float distortion_speed : hint_range(0.0, 5.0) = 0.5;
uniform float blob_scale : hint_range(1.0, 20.0) = 4.0;
uniform float spirit_size : hint_range(0.1, 1.5) = 0.8;
uniform float edge_softness : hint_range(0.0, 1.0) = 0.5;

vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float snoise(vec2 v) {
    const vec4 C = vec4(0.211324865405187, 0.366025403784439,
            -0.577350269189626, 0.024390243902439);
    vec2 i  = floor(v + dot(v, C.yy) );
    vec2 x0 = v -   i + dot(i, C.xx);
    vec2 i1;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = mod(i, 289.0);
    vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
            + i.x + vec3(0.0, i1.x, 1.0 ));
    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
            dot(x12.zw,x12.zw)), 0.0);
    m = m*m ;
    m = m*m ;
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 a0 = x - floor(x + 0.5);
    float gv = h.x * x0.x + h.y * x0.y; // упрощено для 2D
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

void fragment() {
    vec2 uv = UV;
    
    // Плавное движение блобов
    float n = snoise(uv * blob_scale + TIME * distortion_speed);
    
    vec4 tex = texture(albedo_texture, uv);
    float dist = distance(uv, vec2(0.5));
    
    // Смешиваем дистанцию с шумом для "рваных" краев
    float noise_influence = n * 0.2;
    float threshold = spirit_size + noise_influence;
    
    float alpha_mask = smoothstep(threshold, threshold - edge_softness, dist);
    
    ALBEDO = tex.rgb * tint_color.rgb;
    ALPHA = tex.a * alpha_mask;
}