shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);  // Цвет свечения
uniform float glow_intensity : hint_range(0.0, 1.0) = 0.01;          // Интенсивность свечения
uniform float blur_radius : hint_range(0.0, 0.3) = 0.003;            // Радиус размытия
uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.262;         // Порог прозрачности для свечения

// Gaussian blur kernel weights
float gaussian(float x, float sigma) {
    return exp(-x * x / (2.0 * sigma * sigma)) / (sqrt(2.0 * 3.14159) * sigma);
}

void fragment() {
    vec4 texColor = texture(TEXTURE, UV);

    // Применение Gaussian blur для создания размытой версии изображения
    vec4 blurredColor = vec4(0.0);
    int samples = 10; // Количество выборок для размытия
    float sigma = blur_radius;

    // Gaussian размытие по обеим осям
    for (int x = -samples; x <= samples; x++) {
        for (int y = -samples; y <= samples; y++) {
            vec2 offset = vec2(float(x), float(y)) * blur_radius / float(samples);
            float weight = gaussian(length(offset), sigma);
            blurredColor += texture(TEXTURE, UV + offset) * weight;
        }
    }

    blurredColor /= float((samples * 2 + 1) * (samples * 2 + 1));

    // Усиление размытия, чтобы создать свечение
    vec4 glow = blurredColor * glow_intensity * glow_color;

    // Учитываем прозрачность, чтобы контролировать влияние свечения на исходное изображение
    glow.a *= alpha_threshold;

    // Совмещаем исходное изображение со свечением
    COLOR = texColor + glow;
}