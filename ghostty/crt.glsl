// Modern-retro CRT for Ghostty: visible scanlines, soft phosphor glow, faint RGB fringe, vignette.
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 px = 1.0 / iResolution.xy;

    // slight horizontal colour fringe
    vec3 col;
    col.r = texture(iChannel0, uv + vec2(px.x * 1.2, 0.0)).r;
    col.g = texture(iChannel0, uv).g;
    col.b = texture(iChannel0, uv - vec2(px.x * 1.2, 0.0)).b;

    // cheap glow: blend in a blurred sample so bright text blooms a little
    vec3 glow = vec3(0.0);
    for (int i = -2; i <= 2; i++) {
        glow += texture(iChannel0, uv + vec2(float(i) * px.x * 2.0, 0.0)).rgb;
        glow += texture(iChannel0, uv + vec2(0.0, float(i) * px.y * 2.0)).rgb;
    }
    col += glow / 10.0 * 0.25;

    // scanlines: one dark band every 3 physical pixels
    float scan = 0.5 + 0.5 * cos(fragCoord.y * 6.28318 / 3.0);
    col *= mix(0.62, 1.0, scan);

    // vignette
    vec2 d = uv - 0.5;
    col *= 1.0 - 0.45 * dot(d, d);

    fragColor = vec4(col * 1.12, 1.0);
}
