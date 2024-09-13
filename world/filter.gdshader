shader_type canvas_item;

// Добавляем uniform для текстуры экрана
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec4 filter_color : source_color = vec4(0.0, 0.0, 0.1, 0.5);
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.75;
uniform float vignette_radius : hint_range(0.0, 1.5) = 0.75;
uniform float vignette_smoothness : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec2 uv = SCREEN_UV;

    // Центр экрана в нормализованных координатах
    vec2 screen_center = vec2(0.49, 0.7);

    // Виньетка (затемнение по краям)
    float dist = distance(uv, screen_center);
    float vignette = smoothstep(vignette_radius, vignette_radius - vignette_smoothness, dist);

    // Получаем цвет из текстуры экрана
    vec4 base_color = texture(SCREEN_TEXTURE, uv);

    // Применяем цветовой фильтр и виньетку
    base_color.rgb = mix(base_color.rgb, filter_color.rgb, vignette * vignette_intensity);

    COLOR = base_color;
}