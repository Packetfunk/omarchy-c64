// Modern-retro CRT for Ghostty: colour fringe, glow, scanlines and vignette.
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 px = 1.0 / iResolution.xy;

    // 1. slight horizontal colour fringe (red and blue shifted apart)
    vec3 col;
    col.r = texture(iChannel0, uv + vec2(px.x * 1.2, 0.0)).r;
    col.g = texture(iChannel0, uv).g;
    col.b = texture(iChannel0, uv - vec2(px.x * 1.2, 0.0)).b;

    // 2. cheap glow: blend in a blurred sample so bright text blooms a little
    vec3 glow = vec3(0.0);
    for (int i = -2; i <= 2; i++) {
        glow += texture(iChannel0, uv + vec2(float(i) * px.x * 2.0, 0.0)).rgb;
        glow += texture(iChannel0, uv + vec2(0.0, float(i) * px.y * 2.0)).rgb;
    }
    col += glow / 10.0 * 0.25;

    // 3. scanlines: one dark band every 3 physical pixels; first number is the darkest the band gets
    float scan = 0.5 + 0.5 * cos(fragCoord.y * 6.28318 / 3.0);
    col *= mix(0.74, 1.0, scan);

    // 4. vignette: darker towards the corners
    vec2 d = uv - 0.5;
    col *= 1.0 - 0.45 * dot(d, d);

    // 5. brightness boost to compensate for the dimming above
    fragColor = vec4(col * 1.18, 1.0);
}
