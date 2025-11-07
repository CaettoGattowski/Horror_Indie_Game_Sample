shader_type spatial;
render_mode cull_disabled, diffuse_lambert_wrap, specular_disabled;

// ─── Parameters ─────────────────────────────────────────
uniform sampler2D albedo_texture;

uniform float color_steps = 6.0;          // number of toon steps
uniform float ambient_strength = 0.4;     // ambient fill
uniform vec3 warm_tint = vec3(1.05, 1.0, 0.9); // subtle warm overlay
uniform float rim_strength = 0.5;         // rim light intensity
uniform float rim_power = 2.0;            // rim light falloff
uniform float light_intensity = 0.6;      // main light scaling
uniform float brightness = 1.0;           // overall brightness

// ─── Pixel-art texture size ─────────────────────────────
uniform vec2 texture_size = vec2(85.0, 85.0); // width, height of your texture

// ─── Fragment stage ──────────────────────────────────────
void fragment() {
    // Snap UVs to pixel grid for crisp sampling
    vec2 uv_snapped = floor(UV * texture_size) / texture_size;
    ALBEDO = texture(albedo_texture, uv_snapped).rgb;
}

// ─── Light stage ─────────────────────────────────────────
void light() {
    // Standard Lambertian diffuse
    float NdotL = max(dot(NORMAL, LIGHT), 0.0);

    // Quantize for toon steps
    float diffuse = floor(NdotL * color_steps) / max(1.0, color_steps - 1.0);

    // Rim lighting
    float rim = pow(1.0 - max(dot(NORMAL, VIEW), 0.0), rim_power) * rim_strength;

    // Combine diffuse + rim and scale by light intensity
    float lighting = clamp(diffuse + rim, 0.0, 1.0) * light_intensity;

    // Apply lighting + ambient
    vec3 final_color = ALBEDO * (lighting + ambient_strength);

    // Apply warm tint and global brightness
    final_color *= warm_tint * brightness;

    DIFFUSE_LIGHT += final_color;
}
