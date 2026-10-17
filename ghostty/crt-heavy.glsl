// Heavy CRT for the status-screen profile: strong scanlines, bloom, fringe, vignette (no curvature, no flicker).
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 res = iResolution.xy;
    vec2 uv = fragCoord / res;
    vec2 px = 1.0 / res;

    // strong colour fringe
    vec3 col;
    col.r = texture(iChannel0, uv + vec2(px.x * 1.6, 0.0)).r;
    col.g = texture(iChannel0, uv).g;
    col.b = texture(iChannel0, uv - vec2(px.x * 1.6, 0.0)).b;

    // bloom
    vec3 glow = vec3(0.0);
    for (int i = -3; i <= 3; i++) {
        glow += texture(iChannel0, uv + vec2(float(i) * px.x * 2.5, 0.0)).rgb;
        glow += texture(iChannel0, uv + vec2(0.0, float(i) * px.y * 2.5)).rgb;
    }
    col += glow / 14.0 * 0.38;

    // heavy scanlines, one dark band every 4 physical pixels
    float scan = 0.5 + 0.5 * cos(fragCoord.y * 6.28318 / 4.0);
    col *= mix(0.48, 1.0, scan);

    // vignette
    vec2 d = uv - 0.5;
    col *= 1.0 - 0.9 * dot(d, d);

    fragColor = vec4(col * 1.35, 1.0);
}
